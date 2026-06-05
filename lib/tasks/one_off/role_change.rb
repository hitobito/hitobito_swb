module RoleChange
  class RoleChangeJob < BaseJob
    self.parameters = [:role_id]

    def initialize(role_id)
      super()
      @role_id = role_id
    end

    def perform
      return unless old_role
      Role.transaction do
        migrate
      end
    end

    def migrate
      old_role.destroy!
      new_role.save!
      ts_schedule_new_role_create
      ts_schedule_old_role_destroy if old_role.ts_code
      HitobitoLogEntry.create!(
        category: :cleanup,
        level: :info,
        subject: old_role.person,
        message: "Junioren Rolle migriert"
      )
    end

    def ts_schedule_new_role_create
      Ts::WriteJob.new(new_role.to_global_id, :post).enqueue!
    end

    def ts_schedule_old_role_destroy
      Ts::RoleDestroyJob.new(old_role.ts_destroy_values).enqueue!
    end

    def old_role
      @old_role ||= Role.find_by(id: @role_id)
    end

    def new_role
      @new_role ||= old_role.group.roles.build(
        person_id: old_role.person_id,
        type: old_role.type.gsub("Junior", "Aktivmitglied")
      )
    end
  end

  class Runner
    def run(people_ids = nil)
      roles(people_ids).each do |role|
        RoleChangeJob.new(role.id).enqueue!
      end
    end

    def roles(people_ids = nil)
      Role
        .where(person_id: people_ids || csv.by_col["person_id"])
        .where("type ~ 'JuniorU15|JuniorU19'")
    end

    private

    def csv
      CSV.read(File.expand_path("../role_change.csv", __FILE__), headers: true)
    end
  end
end
