# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  class TeamsReplacement
    def initialize(log_dir: nil)
      @log_dir = log_dir
    end

    def run
      ::Team.transaction do
        ::Team.delete_all
        importer = Importer.new(Team, :teams, log_dir: @log_dir)
        importer.run
        raise_on_failures(importer)
      end
    end

    private

    def raise_on_failures(importer)
      raise "No teams found in import file, existing teams were kept" if importer.models.empty?

      failed = importer.counts[:failed]
      return if failed.zero?

      raise "#{failed} of #{importer.models.size} teams failed, existing teams were kept"
    end
  end
end
