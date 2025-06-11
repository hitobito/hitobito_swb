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

YES_NO = {
  de: "Ja, Nein",
  fr: "Oui, Non",
  it: "Si, No",
  en: "Yes, No"
}

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
  multiple_choices: true,
  admin: false,
  disclosure: :required,
  translation_attributes: [
    {locale: "de", question: "In welchen Disziplinen tritts du an?", choices: TOURNAMENT_CHOICES},
    {locale: "fr", question: "Dans quelles disciplines concourrez-vous?", choices: TOURNAMENT_CHOICES},
    {locale: "it", question: "In quali discipline gareggia?", choices: TOURNAMENT_CHOICES},
    {locale: "en", question: "In which disciplines do you compete?", choices: TOURNAMENT_CHOICES}
  ]
})

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
  multiple_choices: false,
  admin: false,
  disclosure: :optional,
  translation_attributes: [
    {locale: "de", question: "Ich suche eine/n Doppelpartner:in", choices: YES_NO[:de]},
    {locale: "fr", question: "Je cherche un.e partenaire de double", choices: YES_NO[:fr]},
    {locale: "it", question: "Cerco un partner per il doppio", choices: YES_NO[:it]},
    {locale: "en", question: "I am looking for a double partner", choices: YES_NO[:en]}
  ]
})

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
  multiple_choices: false,
  admin: false,
  disclosure: :optional,
  translation_attributes: [
    {locale: "de", question: "Ich suche eine/n Mixed-Partner:in", choices: YES_NO[:de]},
    {locale: "fr", question: "Je cherche un.e partenaire de mixte", choices: YES_NO[:fr]},
    {locale: "it", question: "Cerco un partner per il doppio misto", choices: YES_NO[:it]},
    {locale: "en", question: "I am looking for a mixed-double partner", choices: YES_NO[:en]}
  ]
})

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
  multiple_choices: false,
  admin: false,
  disclosure: :optional,
  translation_attributes: [
    {locale: "de", question: "Mein/e Doppelpartner:in ist (Name, Vorname, Nationalität)"},
    {locale: "fr", question: "Mon/Ma partenaire de double est (Nom, Prénom, Nationalité)"},
    {locale: "it", question: "Il mio partner di doppio è (Cognome, Nome, Nazionalità)"},
    {locale: "en", question: "My double parter is (Surname, Firstname, Nationality)"}
  ]
})

Event::Question.seed_global({
  event_type: "Event::Tournament", # Is derived for every event
  multiple_choices: false,
  admin: false,
  disclosure: :optional,
  translation_attributes: [
    {locale: "de", question: "Mein/e Mixedpartner:in ist (Name, Vorname, Nationalität)"},
    {locale: "fr", question: "Mon/Ma partenaire de mixte est (Nom, Prénom, Nationalité)"},
    {locale: "it", question: "Il mio partner di doppio misto è (Cognome, Nome, Nazionalità)"},
    {locale: "en", question: "My mixed-double parter is (Surname, Firstname, Nationality)"}
  ]
})
