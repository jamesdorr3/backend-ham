class Goal < ApplicationRecord
  belongs_to :user
  has_many :days, dependent: :destroy

  def change_days_goals
    self.days.each do |day|
      day.goal = self.user.goals.filter{|goal| goal.id != self.id}[0]
      day.save
    end
  end

end
