#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class MigrateFixedFeeInvoiceItems < ActiveRecord::Migration[8.0]
  def up
    say_with_time "migrating region items" do
      in_each_language_and_billing_period do |base_scope, year|
        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%regions%'")
          .update_all(
            type: "Invoice::RegionItem",
            name: I18n.t("fixed_fees.regions.fee"),
            dynamic_cost_parameters: {
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
      end
    end
    
    say_with_time "migrating verein items" do
      in_each_language_and_billing_period do |base_scope, year|
        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%teams%'")
          .where(name: "grundbeitrag_elite")
          .update_all(
            type: "Invoice::VereinItem",
            name: I18n.t("fixed_fees.teams.grundbeitrag_elite"),
            dynamic_cost_parameters: {
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
        base_scope
          .where(type: "InvoiceItem::FixedFee")
          .where("dynamic_cost_parameters like '%teams%'")
          .where(name: "grundbeitrag_andere")
          .update_all(
            type: "Invoice::VereinReducedItem",
            name: I18n.t("fixed_fees.teams.grundbeitrag_andere"),
            dynamic_cost_parameters: {
              period_start_on: Date.new(year, 1, 1),
              period_end_on: Date.new(year, 12, 31)
            }
          )
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
        in_each_language_and_billing_period do |base_scope, year|
          base_scope.where(type: "InvoiceItem::FixedFee")
            .where("dynamic_cost_parameters like '%teams%'")
            .where(name: league_name)
            .update_all(
              type: "Invoice::VereinReducedItem",
              name: I18n.t("fixed_fees.teams.#{league_name}"),
              dynamic_cost_parameters: {
                leagues:,
                period_start_on: Date.new(year, 1, 1),
                period_end_on: Date.new(year, 12, 31)
              }
            )
        end
      end
    end

    say_with_time "migrating role items" do
      role_item_types = %W[aktiv passiv junior_u15 junior_u19 lizenz lizenz_plus lizenz_no_raking
        lizenz_plus_junior vereinigung]
      role_item_types.each do |role_item_type|
        in_each_language_and_billing_period do |base_scope, year|
          base_scope.where(type: "InvoiceItem::Roles")
            .where(name: role_item_type)
            .update_all(
              type: "Invoice::RoleCountItem",
              name: I18n.t("fixed_fees.roles.#{role_item_type}"),
              dynamic_cost_parameters: {
                period_start_on: Date.new(year, 1, 1),
                period_end_on: Date.new(year, 12, 31)
              }
            )
        end
      end
    end
  end

  def in_each_language_and_billing_period
    BillingPeriod.order(:created_at).all.each do |billing_period|
      # TODO if SWB adds more billing periods, especially multiple in the same year,
      #   this heuristic will not work correctly. But since billing_period does not
      #   have any semblance of connection to time, we have to do stunts like this.
      year = billing_period.name.include?('25') ? 2025 : 2026

      Person::LANGUAGES.each do |lang, _|
        LocaleSetter.with_locale(locale: lang) do
          invoice_item_join_sql = ApplicationRecord.sanitize_sql(
            ["LEFT JOIN billed_models ON billed_models.invoice_item_id = invoice_items.id " \
             "AND billed_models.billing_period_id = (?)", billing_period.id]
          )

          yield InvoiceItem.from(InvoiceItem.joins(:invoice)
            .joins("LEFT JOIN people ON invoices.recipient_id = people.id AND " \
              "invoices.recipient_type = 'Person'")
            .where(invoices: {recipient_type: "Person"}, people: {language: lang})
            # Use a left join instead of inner join, to ensure all invoice items
            # are migrated at least once, even when they mistakenly have no billed_model
            # associated with them
            .joins(invoice_item_join_sql)
            .distinct.select(:id)),
            year
        end
      end
    end
  end
end
