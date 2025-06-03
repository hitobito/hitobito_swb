# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  class Importer
    attr_reader :models, :name, :counts, :info, :saved, :failed, :validation_errors, :index

    def initialize(importer_class, from, log_dir: nil, lines: nil, filter: nil, index: nil, sort: false)
      @name = importer_class.name.demodulize.pluralize
      @csv = Csv.new(from, lines:, filter:).csv
      @models = @csv.map { |row| importer_class.from(row) }.uniq
      @models = models.sort if sort
      @counts ||= Hash.new(0)
      @info = open_logfile(:info, log_dir)
      @saved = open_logfile(:saved, log_dir, index)
      @failed = open_logfile(:failed, log_dir, index)
      @validation_errors = open_logfile(:invalid, log_dir, index)
      @started = get_time
      @sort = sort
    end

    def run
      write(:info)
      write(:info, "===")
      write(:info, "Got #{models.count} #{name}, running validations, pls stand by ..")
      valid, invalid = models.partition(&:valid?)
      write(:info, " valid: #{valid.size}, invalid: #{invalid.size}")
      invalid.each { |model| write(:validation_errors, model.to_s(details: true)) }

      # Still trying to save all, as we have more restrict validations in place
      models.select { |model| save(model) }

      write(:info, " success: #{counts[:success]}, failed: #{counts[:failed]}, duration: #{duration}")

      write(:info, "===")
      write(:info)

      close_files

      info
    end

    def save(model)
      operation = model.persisted? ? :update : :new
      model.save.tap do |success|
        if success
          write(:saved, "#{model} - #{operation}")
          counts[:success] += 1
        else
          write(:failed, model.to_s(details: true))
          counts[:failed] += 1
        end
      end
    rescue => e
      failed.puts "#{model}: #{model.full_error_messages} #{e}"
    end

    def write(key, message = nil)
      send(key).puts(message)
      puts message if key == :info || models.count < 10 # rubocop:disable Rails/Output
    end

    def get_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    def duration = (get_time - @started).round(1)

    def close_files = [info, saved, failed, validation_errors].each(&:close)

    def open_logfile(suffix, log_dir, index = nil)
      return File.open(File::NULL, "w") unless log_dir

      filename = index ? "#{index}-#{name.underscore}-#{suffix}" : suffix
      mode = index ? "w" : "a+"
      File.open(log_dir.join("#{filename}.log"), mode)
    end
  end
end
