# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

load File.expand_path("../../app_root.rb", __FILE__)
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require File.join(ENV["APP_ROOT"], "spec", "spec_helper.rb")

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[HitobitoSwb::Wagon.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Maybe extract to environment file
Rails.application.config.active_job.queue_adapter = :test

RSpec.configure do |config|
  config.fixture_paths = [
    File.expand_path("../fixtures", __FILE__)
  ]
  require_relative "support/ts/api_spec_helper"
  config.include Ts::ApiSpecHelper, :tests_ts_api

  config.before do
    allow(Ts::Config).to receive(:exist?).and_return(true)
    allow(Ts::Config).to receive(:host).and_return("https://ts.example.com")
    allow(Ts::Config).to receive(:username).and_return("user")
    allow(Ts::Config).to receive(:password).and_return("s3cure")
    allow(Ts::Config).to receive(:organization).and_return("b7755b71-068e-44e7-a061-ab26991fd6be")
  end
end
