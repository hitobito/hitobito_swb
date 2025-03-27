class AddNationalityFieldsToPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :nationality, :string, null: true
    add_column :people, :nationality_badminton, :string, null: true
  end
end
