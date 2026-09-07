# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#

def seed_contact_account(contact_account_type, key, **attrs)
  contact_account_type.seed_once(:contactable_id, :contactable_type, attrs.keys.first, { contactable_id: Group.root.id, contactable_type: "Group" }.merge(attrs))
end

Group::Dachverband.seed_once(:parent_id, name: "Swiss Badminton", street: "Talgut-Zentrum", housenumber: 27, zip_code: 3063, town: "Ittigen", country: "CH", email: "info@swiss-badminton.ch", ts_code: "B8EA3AEF-07B0-4981-90F3-2E6A62AF9823")

seed_contact_account(PhoneNumber, :office, number: "+41 31 359 72 55")
seed_contact_account(PhoneNumber, :other, number: "+41 31 359 72 59", label: "Fax")
seed_contact_account(SocialAccount, :website, name: "http://www.swiss-badminton.ch")
