# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

root = Group.roots.first

# Regionen mit ein paar Vereinen

result = Group::Region.seed_once(:name,
  parent_id: root.id,
  name: "Badminton Regionalverband Bern",
  short_name: "BRB")
brb = result.first
Group::Verein.seed_once(:name, parent_id: brb.id, name: "BC Bern")
Group::Verein.seed_once(:name, parent_id: brb.id, name: "BC Thun")
Group::Verein.seed_once(:name, parent_id: brb.id, name: "BC Köniz")

result = Group::Region.seed_once(:name,
  parent_id: root.id,
  name: "Badminton Verband Nordwestschweiz",
  short_name: "BVN")
bvn = result.first
Group::Verein.seed_once(:name, parent_id: bvn.id, name: "BC Olten")
Group::Verein.seed_once(:name, parent_id: bvn.id, name: "BC Pratteln")
Group::Verein.seed_once(:name, parent_id: bvn.id, name: "SC Uni Basel")

# Center

Group::Center.seed_once(:name, parent_id: root.id, name: "1001 Freizeit AG")
Group::Center.seed_once(:name, parent_id: root.id, name: "Aarsports GmbH")
Group::Center.seed_once(:name, parent_id: root.id, name: "Tivoli Sportcenter Worblaufen")

Group.rebuild!
