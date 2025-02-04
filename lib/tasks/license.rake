# frozen_string_literal: true

namespace :app do
  namespace :license do
    task :config do # rubocop:disable Rails/RakeEnvironment
      @licenser = Licenser.new('hitobito_swb',
                               'Swiss Badminton',
                               'https://github.com/hitobito/hitobito_swb')
    end
  end
end
