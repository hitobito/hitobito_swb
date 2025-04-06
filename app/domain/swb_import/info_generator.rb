module SwbImport
  Mitglied = Data.define(:role, :type_name, :groupname)

  class InfoGenerator
    def initialize(key = "mitglieder-short")
      @csv = SwbImport::Csv.new(key).csv
      @mitglieder = read_mitglieder
    end

    def write
      File.write("ts_hitobito_roles.csv", generate)
    end

    def generate
      by_role = @mitglieder.group_by(&:role).sort_by { |k, v| v.size }.reverse
      others = @mitglieder.map(&:groupname).uniq.select { |name| !name.starts_with?("BC ") }.sort
      @headers = ["TS Rolle", "TS Typ", "Total", "Rolle Hitobito", "Total Gruppen", "BC ..", *others]
      CSV.generate do |csv|
        csv << @headers
        by_role.each do |role, mitglieder|
          if mitglieder.map(&:type_name).empty?
            csv << add_row(role, mitglieder, ROLE_MAPPING[role])
          else
            mitglieder.group_by(&:type_name).each do |type_name, mitglieder|
              csv << add_row(role, mitglieder, type_name:)
            end
          end
        end
      end
    end

    def add_row(role, mitglieder, type_name: nil)
      hitobito_role = type_name.present? ? SPIELER_LIZENZ_MAPPING[type_name] : ROLE_TYPE_MAPPING[role]
      group_names = mitglieder.map(&:groupname)
      bcs_count = mitglieder.map(&:groupname).count { |name| name.starts_with?("BC ") }

      [role, type_name, mitglieder.size, hitobito_role, group_names.uniq.count].tap do |row|
        group_names.tally.each do |group_name, count|
          group_name = group_name.starts_with?("BC ") ? "BC .." : group_name
          count = group_name.starts_with?("BC ") ? bcs_count : count
          pos = @headers.index(group_name)
          row[pos] = count
        end
      end
    end

    def read_mitglieder
      @csv.map do |r|
        attrs = r.to_h.transform_keys { |k| k.underscore.to_sym }.slice(*Mitglied.members)
        Mitglied.new(**attrs)
      end
    end
  end
end
