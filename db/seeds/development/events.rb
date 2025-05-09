# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.


require HitobitoSwb::Wagon.root.join("db", "seeds", "development", "support", "swb_event_seeder")

srand(42)

seeder = SwbEventSeeder.new

layer_types = Group.all_types.select(&:layer).collect(&:sti_name)
Group.where(type: layer_types).pluck(:id).each do |group_id|
  (0..3).rand.times do
    seeder.seed_event(group_id, :base)
  end
end

Group.root.tap do |group|
  10.times.each do
    seeder.seed_event(group.id, :tournament)
  end
  10.times.each do
    seeder.seed_event(group.id, :external_training)
  end
end
