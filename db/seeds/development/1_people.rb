# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require Rails.root.join("db", "seeds", "support", "person_seeder")

class SwbPersonSeeder < PersonSeeder
  def amount(role_type)
    case role_type.name.demodulize
    when /(member|lizenz|spieler)/i then (1..3).to_a.sample
    when /junior/i then (1..5).to_a.sample
    else 1
    end
  end

  def seed_additional_emails(...)
    super if Faker::Boolean.boolean(true_ratio: 0.2)
  end

  def seed_social_accounts(...)
    super if Faker::Boolean.boolean(true_ratio: 0.2)
  end

  def person_attributes(role_type)
    super.tap do |attrs|
      attrs[:birthday] = birthday_for(attrs[:birthday], role_type)
      attrs[:ts_gender] = attrs[:gender]
      attrs[:nationality] = Faker::Boolean.boolean(true_ratio: 0.9) ? "CH" : ["DE", "AT", "FR"].sample 
    end
  end

  def birthday_for(birthday, role_type)
    return birthday unless role_type < Role::Player
    from = role_type.year_range.begin || 10
    to = role_type.year_range.end || 99

    Faker::Date.in_date_period(year: Date.today.year - (from..to).to_a.sample)
  end
end

puzzlers = [
  "Matthias Viehweger",
  "Nils Rauch",
  "Thomas Ellenberger",
  "Daniel Illi",
  "Andreas Maierhofer",
  "Niklas Jäggi"
]

devs = {
  "Customer Name" => "customer@email.com"
}
puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase.gsub("ä", "ae")}@puzzle.ch"
end

seeder = SwbPersonSeeder.new

seeder.seed_all_roles

root = Group.root
devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::Dachverband::Administrator)
end
