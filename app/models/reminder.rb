class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :visit

  validates :label, presence: true
  validates :days_to_show, presence: true

  after_update :change_show_date

  scope :attention, -> { where(state: 'actual').order(created_at: :desc) }
  scope :home_list, -> { where('show_date <= ? AND state == ?', Date.today, 'actual').order(created_at: :desc) }


  state_machine :state, initial: :actual do
    state :actual
    state :done

    event :done do
      transition actual: :done
    end

    event :actual do
      transition done: :actual
    end
  end

  private

  def change_show_date
    update(show_date: visit.date - days_to_show) if saved_changes['days_to_show'].present?
  end


end
