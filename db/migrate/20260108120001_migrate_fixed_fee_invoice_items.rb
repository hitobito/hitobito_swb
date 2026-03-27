#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class MigrateFixedFeeInvoiceItems < ActiveRecord::Migration[8.0]
  # Class stub used because BillingPeriod has been removed from the codebase in the meantime
  class BillingPeriod < ActiveRecord::Base
  end

  TRANSLATIONS = {
    de: {
      "fixed_fees.regions.fee": "Grundbeitrag Region",
      "fixed_fees.teams.grundbeitrag_elite": "Grundbeitrag",
      "fixed_fees.teams.grundbeitrag_andere": "Grundbeitrag",
      "fixed_fees.teams.team_nla": "NLA",
      "fixed_fees.teams.team_nlb": "NLB",
      "fixed_fees.teams.team_liga_1": "1. Liga",
      "fixed_fees.teams.team_liga_2": "2. Liga",
      "fixed_fees.teams.team_liga_3": "3. Liga",
      "fixed_fees.teams.team_liga_4": "4. Liga",
      "fixed_fees.teams.team_andere": "Junioren, Senioren und 5. Liga Teams",
      "fixed_fees.teams.team_vereinigung": "Vereinigung",
      "fixed_fees.roles.aktiv": "Aktivmitglieder",
      "fixed_fees.roles.passiv": "Passivmitglieder",
      "fixed_fees.roles.junior_u15": "Junior:innen (bis U15)",
      "fixed_fees.roles.junior_u19": "Junior:innen (U17-U19)",
      "fixed_fees.roles.lizenz": "Lizenzen",
      "fixed_fees.roles.lizenz_plus": "Lizenzen Plus",
      "fixed_fees.roles.lizenz_no_raking": "Lizenzen NO ranking",
      "fixed_fees.roles.lizenz_plus_junior": "Lizenzen Plus Junior:innen (U19)",
      "fixed_fees.roles.vereinigung": "Vereinigungsspieler:innen",
    },
    fr: {
      "fixed_fees.regions.fee": "Cotisation de club",
      "fixed_fees.teams.grundbeitrag_elite": "Cotisation réduite de club",
      "fixed_fees.teams.grundbeitrag_andere": "Grundbeitrag",
      "fixed_fees.teams.team_nla": "LNA",
      "fixed_fees.teams.team_nlb": "LNB",
      "fixed_fees.teams.team_liga_1": "1ère ligue",
      "fixed_fees.teams.team_liga_2": "2e ligue",
      "fixed_fees.teams.team_liga_3": "3e ligue",
      "fixed_fees.teams.team_liga_4": "4e ligue",
      "fixed_fees.teams.team_andere": "Equipes juniores, séniores et 5e ligue",
      "fixed_fees.teams.team_vereinigung": "Union",
      "fixed_fees.roles.aktiv": "Membres actifs",
      "fixed_fees.roles.passiv": "Membres passif",
      "fixed_fees.roles.junior_u15": "Junior.e.s (jusqu'à U15)",
      "fixed_fees.roles.junior_u19": "Junior.e.s (U17-U19)",
      "fixed_fees.roles.lizenz": "Licences",
      "fixed_fees.roles.lizenz_plus": "Licences Plus",
      "fixed_fees.roles.lizenz_no_raking": "Licences NO ranking",
      "fixed_fees.roles.lizenz_plus_junior": "Licences plus junior.e.s (U19)",
      "fixed_fees.roles.vereinigung": "Joueur.se.s d'une union",
    },
  }

  def up
    say_with_time "migrating region items" do
      in_each_billing_period do |base_scope, year|
        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%regions%'").tap do |scope|
          ids = scope.pluck(:id)
          scope.update_all(
            type: "InvoiceItem",
            dynamic_cost_parameters: {
              calculated_like: "InvoiceItem::RegionItem",
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
          update_item_translations(ids, "fixed_fees.regions.fee")
        end
      end
    end
    
    say_with_time "migrating verein items" do
      in_each_billing_period do |base_scope, year|
        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%teams%'")
          .where(name: "grundbeitrag_elite").tap do |scope|
          ids = scope.pluck(:id)
          scope.update_all(
            type: "InvoiceItem",
            dynamic_cost_parameters: {
              calculated_like: "InvoiceItem::VereinItem",
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
          update_item_translations(ids, "fixed_fees.teams.grundbeitrag_elite")
        end


        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%teams%'")
          .where(name: "grundbeitrag_andere").tap do |scope|
          ids = scope.pluck(:id)
          scope.update_all(
            type: "InvoiceItem",
            dynamic_cost_parameters: {
              calculated_like: "InvoiceItem::VereinReducedItem",
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
          update_item_translations(ids, "fixed_fees.teams.grundbeitrag_andere")
        end
      end
    end
    
    say_with_time "migrating team items" do
      league_mapping = {
        team_nla: ["NLA"],
        team_nlb: ["NLB"],
        team_liga_1: ["1. Liga"],
        team_liga_2: ["2. Liga"],
        team_liga_3: ["3. Liga"],
        team_liga_4: ["4. Liga"],
        team_andere: ["Junioren", "Senioren", "NL - 5. Liga"],
        team_vereinigung: ["Vereinigung"]
      }

      league_mapping.each do |league_name, leagues|
        in_each_billing_period do |base_scope, year|
          base_scope.where(type: "InvoiceItem::FixedFee")
            .where("dynamic_cost_parameters like '%teams%'")
            .where(name: league_name).tap do |scope|
            ids = scope.pluck(:id)
            scope.update_all(
              type: "InvoiceItem",
              dynamic_cost_parameters: {
                calculated_like: "InvoiceItem::TeamItem",
                leagues:,
                period_start_on: Date.new(year, 1, 1),
                period_end_on: Date.new(year, 12, 31)
              }
            )
            update_item_translations(ids, "fixed_fees.teams.#{league_name}")
          end
        end
      end
    end

    say_with_time "migrating role items" do
      role_type_mapping = {
        aktiv: "Group::VereinSpieler::Aktivmitglied",
        passiv: "Group::VereinSpieler::Passivmitglied",
        junior_u15: "Group::VereinSpieler::JuniorU15",
        junior_u19: "Group::VereinSpieler::JuniorU19",
        lizenz: "Group::VereinSpieler::Lizenz",
        lizenz_plus: "Group::VereinSpieler::LizenzPlus",
        lizenz_no_raking: "Group::VereinSpieler::LizenzNoRanking",
        lizenz_plus_junior: "Group::VereinSpieler::LizenzPlusJunior",
        vereinigung: "Group::VereinSpieler::Vereinigungsspieler",
      }
      role_type_mapping.keys.each do |role_item_type|
        in_each_billing_period do |base_scope, year|
          base_scope.where(type: "InvoiceItem::Roles").joins(:translations)
            .where(invoice_item_translations: { name: role_item_type })
            .tap do |scope|
            ids = scope.pluck(:id)
            scope.update_all(
              type: "InvoiceItem",
              dynamic_cost_parameters: {
                calculated_like: "InvoiceItem::RoleCountItem",
                role_types: [role_type_mapping[role_item_type]],
                period_start_on: Date.new(year, 1, 1),
                period_end_on: Date.new(year, 12, 31)
              }
            )
            update_item_translations(ids, "fixed_fees.roles.#{role_item_type}")
          end
        end
      end
    end
  end

  def in_each_billing_period
    BillingPeriod.order(:created_at).all.each do |billing_period|
      year = billing_period.name.include?('25') ? 2025 : 2026

      invoice_item_join_sql = ApplicationRecord.sanitize_sql(
        ["LEFT JOIN billed_models ON billed_models.invoice_item_id = invoice_items.id " \
         "AND billed_models.billing_period_id = (?)", billing_period.id]
      )

      yield(InvoiceItem.where(id: InvoiceItem.joins(:invoice)
        # Use a left join instead of inner join, to ensure all invoice items
        # are migrated at least once, even when they mistakenly have no billed_model
        # associated with them
        .joins(invoice_item_join_sql)
        .distinct.select(:id)),
        year)
    end
  end

  def update_item_translations(ids, key)
    InvoiceItem::Translation.where(invoice_item_id: ids, locale: :de).update_all(name:
      TRANSLATIONS[:de][key.to_sym]
    )
    InvoiceItem::Translation.create_with(locale: :fr, name: TRANSLATIONS[:fr][key.to_sym]).insert_all(
      InvoiceItem::Translation.where(invoice_item_id: ids, locale: :de)
        .pluck(:invoice_item_id).map{|invoice_item_id| { invoice_item_id: }}
    )
  end
end
