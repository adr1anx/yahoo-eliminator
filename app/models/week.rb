class Week < ApplicationRecord
  has_one :team

  def eliminated_team week
    Week.where(week_num: week)
  end

  def eliminate_team! week
    Team.alive.each do |team|
      team.weeks.where(week_num: week).order
    end
  end
end
