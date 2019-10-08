class Team < ApplicationRecord
  self.implicit_order_column = "team_id DESC"
  has_many :weeks, -> { order('week_num ASC') }
  scope :alive, -> { where(eliminated_week: nil) }

  def self.eliminate! week
    alive.joins(:weeks).where(weeks: {week_num: week}).order('weeks.points ASC').limit(1).first.update(eliminated_week: week)
  end

  def eliminated?
    !eliminated_week.nil?
  end
end
