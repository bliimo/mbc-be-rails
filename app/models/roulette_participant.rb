class RouletteParticipant < ApplicationRecord
  belongs_to :roulette
  belongs_to :user

  scope :spinner, -> { where.not(spin_at: nil)}

  def status
    return "Did not spin" if spin_at.blank?
    return "Spin Successful"
    return "Late spin"
  end

  def win_status
    return "Pending" if winner.nil?
    return "WIN" if winner
    return "LOSE"
  end
end
