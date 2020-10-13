class Client < ApplicationRecord
  belongs_to :user

  has_many :visits, dependent: :destroy

  scope :actual, -> { where(blocked: [false, nil]).order(created_at: :desc) }
  scope :archive, -> { where(blocked: true).order(created_at: :desc) }

  def full_name
    [name, surname].map(&:capitalize).join(' ')
  end

  def analytics(type)
    all_visits = visits.where(state: 'done').count.to_f
    rate_visits = visits.where(state: 'done', "#{type}": true).count.to_f
    if rate_visits == 0
      0
    else
      (rate_visits/all_visits * 100.0).round(0)
    end

  end


end
