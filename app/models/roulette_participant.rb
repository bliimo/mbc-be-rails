class RouletteParticipant < ApplicationRecord
  belongs_to :roulette
  belongs_to :user

  scope :spinner, -> { where.not(spin_at: nil)}
  scope :wins, -> { where(winner: true)}
  
  def status
    return "Did not spin" if spin_at.blank?
    return "Late spin (#{spin_at.strftime("%I:%M:%S %p")})" if spin_at > ((roulette.end_time || DateTime.new))
    return "Spin Successful (#{spin_at.strftime("%I:%M:%S %p")})"
  end

  def win_status
    return "Pending" if winner.nil? && roulette.status != "done"
    return "WIN" if winner
    return "LOSE"
  end
end
