# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Event::ExternalTraining < Event
  VALID_STATUS_CODES = (200..399)

  VALID_PROTOLS = %w[http https]

  self.role_types = []
  self.used_attributes = [:name, :description, :external_link]

  validates :external_link, presence: true
  validate :assert_external_link, if: -> { external_link_changed? && external_link.present? }

  private

  def assert_external_link
    if VALID_PROTOLS.exclude?(URI::DEFAULT_PARSER.make_regexp.match(external_link).to_a[1])
      errors.add(:external_link, :invalid_protocol)
    elsif URI.parse(external_link).query.present?
      errors.add(:external_link, :may_not_contain_query)
    elsif VALID_STATUS_CODES.exclude?(RestClient.get(external_link).code)
      errors.add(:external_link, :invalid)
    end
  rescue SocketError
    errors.add(:external_link, :invalid)
  end
end
