# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class UpdatePeopleNationality < ActiveRecord::Migration[7.1]
  def up
    iso3166_ioc_country_mapping.each do |iso, ioc|
      next if iso.blank?

      execute "UPDATE people SET nationality = '#{iso}' WHERE nationality = '#{ioc}'"
    end
  end

  private

  def iso3166_ioc_country_mapping
    Person
      .pluck('distinct(nationality)')
      .compact
      .select { |c| c == Country.new(c).name }
      .map { |c| [SwbImport::Parser.new(nil, nil).send(:parse_country, c), c] }
  end
end
