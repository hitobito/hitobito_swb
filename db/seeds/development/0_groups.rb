# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require Wagons.all.first.root.join("db", "seeds", "development", "support", "verein_seeder")

root = Group.roots.first

# Regionen mit ein paar Vereinen
#
result = Group::Region.seed_once(:name,
  parent_id: root.id,
  name: "Badminton Regionalverband Bern",
  short_name: "BRB")
brb = result.first

[
  "BC Thun",
  "BC Köniz",
  "BC STB-Worb",
  "BC Zollikofen",
  "BC Uni Bern"
].each do |name|
  VereinSeeder.new(parent_id: brb.id, name:).seed
end

result = Group::Region.seed_once(:name,
  parent_id: root.id,
  name: "Badminton Verband Nordwestschweiz",
  short_name: "BVN")
bvn = result.first

[
  "BC Olten",
  "BC Pratteln",
  "SC Uni Basel",
  "BC Kaiseraugst",
  "BC Liestal",
  "BC Oensingen"
].each do |name|
  VereinSeeder.new(parent_id: bvn.id, name:).seed
end

# Center

Group::Center.seed_once(:name, parent_id: root.id, name: "1001 Freizeit AG")
Group::Center.seed_once(:name, parent_id: root.id, name: "Aarsports GmbH")
Group::Center.seed_once(:name, parent_id: root.id, name: "Tivoli Sportcenter Worblaufen")

Group::CenterUnaffilliated.seed_once(:name, parent_id: root.id, name: "CIS Sportcenter")
Group::CenterUnaffilliated.seed_once(:name, parent_id: root.id, name: "Gesundheitspark Thalwil")

Group.rebuild!
