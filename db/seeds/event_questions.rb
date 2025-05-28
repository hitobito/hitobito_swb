# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
TOURNAMENT_CHOICES = [
  "HE / SM",
  "DE / SD",
  "HD / DM",
  "DD / DD",
  "MX / DX"
].join(", ")

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
    multiple_choices: true,
    admin: false,
    disclosure: :required,
    translation_attributes: [
      { locale: "de", question: "In welchen Disziplinen tritts du an?", choices: TOURNAMENT_CHOICES },
      { locale: "fr", question: "Dans quelles disciplines concourrez-vous?", choices: TOURNAMENT_CHOICES },
      { locale: "it", question: "In quali discipline gareggia?", choices: TOURNAMENT_CHOICES },
      { locale: "en", question: "In which disciplines do you compete?", choices: TOURNAMENT_CHOICES },
    ]
  })
