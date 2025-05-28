# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

InvoiceConfig.seed(:group_id,
  group_id: Group.root.id,
  iban: "CH93 0076 2011 6238 5295 7",
  payee: <<~TEXT
    Swiss Badminton
    Talgut-Zentrum 27
    3063 Ittigen - CH
  TEXT
)

BillingPeriod.seed_once(:name,
  name: "Saison 25/26",
  active: true,
)
