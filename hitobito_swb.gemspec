$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your wagon's version:
require "hitobito_swb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  # rubocop:disable Style/SingleSpaceBeforeFirstArg
  s.name = "hitobito_swb"
  s.version = HitobitoSwb::VERSION
  s.authors = ["Matthias Viehweger"]
  s.email = ["viehweger@puzzle.ch"]
  s.homepage = "https://swiss-badminton.ch"
  s.summary = "hitobito for Swiss Badminton"
  s.description = "hitobito for Swiss Badminton"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  # rubocop:enable Style/SingleSpaceBeforeFirstArg
end
