# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

Group::Dachverband.seed_once(:parent_id, name: "Swiss Badminton", street: "Talgut-Zentrum", housenumber: 27, zip_code: 3063, town: "Ittigen", country: "CH", email: "info@swiss-badminton.ch", ts_code: "B8EA3AEF-07B0-4981-90F3-2E6A62AF9823") 
PhoneNumber.seed_once(:contactable_id, :contactable_type, :number, contactable_id: Group.root.id, contactable_type: "Group", number: "+41 31 359 72 55", label: :landline)
PhoneNumber.seed_once(:contactable_id, :contactable_type, :number, contactable_id: Group.root.id, contactable_type: "Group", number: "+41 31 359 72 59", label: :fax)
SocialAccount.seed_once(:contactable_id, :contactable_type, :name, contactable_id: Group.root.id, contactable_type: "Group", name: "http://www.swiss-badminton.ch", label: :website)
