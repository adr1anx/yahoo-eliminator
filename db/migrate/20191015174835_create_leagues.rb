class CreateLeagues < ActiveRecord::Migration[6.0]
  def change
    create_table :leagues do |t|
      t.date :current_year
      t.string :name

      t.timestamps
    end
  end
end
