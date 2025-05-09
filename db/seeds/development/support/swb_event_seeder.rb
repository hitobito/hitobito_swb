# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class SwbEventSeeder < EventSeeder
  def seed_event(group_id, type)
    values = event_values(group_id)
    case type
    when :tournament then seed_tournament(values)
    when :external_training then seed_external_training(values)
    when :base then seed_base_event(values)
    end
  end

  def seed_tournament(values)
    event = seed(Event::Tournament, values.merge(name: Faker::Esport.event))
    seed_questions(event)
    seed_leaders(event)
    seed_participants(event)

    event
  end

 def seed_external_training(values)
   attrs = values.merge(name: Faker::Educator.course_name, external_link: Faker::Internet.url(host: "example.com"))
   seed(Event::ExternalTraining, attrs)
 end

 def seed(class_name, attrs)
   event = class_name
     .joins(:groups)
     .where(groups: {id: attrs[:group_ids]})
     .find_or_initialize_by(name: attrs[:name])
   event.attributes = attrs
   event.save(validate: false)

   date = attrs[:application_opening_at] + rand(180).days

   Event::Date.seed(:event_id, :start_at, {
     event_id: event.id,
     start_at: date,
     finish_at: date + rand(2).days
   })
   event
 end
end
