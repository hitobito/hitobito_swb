# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::StandardFormBuilder
  def labeled_country_select(key)
    labeled(key) do
      country_select(key,
        {priority_countries: Settings.countries.prioritized, selected: object.send(key),
         include_blank: ""},
        {class: "form-select form-select-sm tom-select",
         data: {placeholder: " ", chosen_no_results: I18n.t("global.chosen_no_results")}})
    end
  end
end
