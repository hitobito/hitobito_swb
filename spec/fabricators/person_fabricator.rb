# frozen_string_literal: true

#  Copyright (c) 2020-2024, Insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

Fabrication.manager.schematics[:core_person] =
  Fabrication.manager.schematics.delete(:person)

Fabricator(:person, from: :core_person) do
  gender { (Person::GENDERS + [""]).sample }
  ts_gender { |attrs| attrs[:gender].blank? ? Person::GENDERS.sample : attrs[:gender] }
end
