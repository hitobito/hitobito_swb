# frozen_string_literal: true

#  Copyright (c) 2012-2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

Fabricator(:external_training, from: :event, class_name: "Event::ExternalTraining") do
  name { Faker::Educator.course_name }
  external_link { Faker::Internet.url(host: "example.com") }
  dates(count: 1) { Fabricate(:event_date) }
end

Fabricator(:tournament, from: :event, class_name: "Event::Tournament") do
  name { Faker::Educator.course_name }
  dates(count: 1) { Fabricate(:event_date) }
end
