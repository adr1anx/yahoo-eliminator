class League < ApplicationRecord
  def current_week
    current_year.step(Date.today, 7).count 
  end
end
