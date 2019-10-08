class CreateWeeks < ActiveRecord::Migration[6.0]
  def change
    create_table :weeks do |t|
      t.decimal :points
      t.integer :team_id
      t.boolean :eliminated
      t.integer :week_num
      t.jsonb :raw_week_data

      t.timestamps
    end
  end
end
