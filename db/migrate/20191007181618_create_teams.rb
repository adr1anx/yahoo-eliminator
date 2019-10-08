class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :team_id
      t.string :team_key

      t.timestamps
    end
  end
end
