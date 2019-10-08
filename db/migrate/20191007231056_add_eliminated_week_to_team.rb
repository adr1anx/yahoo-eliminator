class AddEliminatedWeekToTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :eliminated_week, :integer
  end
end
