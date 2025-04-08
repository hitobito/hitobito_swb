# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Ts
  class Config
    FILE_PATH = HitobitoSwb::Wagon.root.join("config", "tournament_software.yml")
    KEYS = %w[host web_host username password organization].freeze

    class << self
      def exist?
        config.present?
      end

      KEYS.each do |key|
        define_method(key) do
          config[key]
        end
      end

      private

      def config
        return @config if defined?(@config)

        @config = load.freeze
      end

      def load
        return nil unless File.exist?(FILE_PATH)

        YAML.safe_load(ERB.new(File.read(FILE_PATH)).result)&.fetch("tournament_software", nil)
      end
    end
  end
end
