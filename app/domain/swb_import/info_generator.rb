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
      layers = ["Group::Verein", "Group::Center", "Group::Region", "Group::Dachverband"]
      others = @mitglieder.map(&:groupname).uniq.select { |name| !name.starts_with?("BC ") }.sort
      @headers = ["TS Rolle", "TS Typ", "Total", "Rolle Hitobito", "Total Gruppen", *layers, *others]
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

    def layer_types = @layer_types ||= Group.where("layer_group_id = id").pluck(:name, :type).to_h

    def add_row(role, mitglieder, type_name: nil)
      hitobito_role = type_name.present? ? SPIELER_LIZENZ_MAPPING[type_name] : ROLE_TYPE_MAPPING[role]
      group_names = mitglieder.map(&:groupname)
      layer_type_count = group_names.map { |name| layer_types[name] }.tally
      bcs_count = mitglieder.map(&:groupname).count { |name| name.starts_with?("BC ") }

      [role, type_name, mitglieder.size, hitobito_role, group_names.uniq.count].tap do |row|
        add_layer_count(layer_type_count, row)
        add_group_names_count(group_names, bcs_count, row)
      end
    end

    def add_group_names_count(group_names, bcs_count, row)
      group_names.tally.each do |group_name, count|
        group_name = group_name.starts_with?("BC ") ? "BC .." : group_name
        count = group_name.starts_with?("BC ") ? bcs_count : count
        add_count(group_name, count, row)
      end
    end

    def add_count(header_name, count, row)
      row[pos] = @headers.index(header_name)
    end

    def add_layer_count(layer_type_count, row)
      layer_type_count.each do |layer, count|
        add_count(layer, count, row)
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
