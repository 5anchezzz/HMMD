class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :client

  has_many :slots, dependent: :destroy
  has_many :reminders, dependent: :destroy

  accepts_nested_attributes_for :reminders, reject_if: :all_blank
  validates_associated :reminders

  after_update :change_reminders_show_date

  state_machine :state, initial: :waiting do

    state :waiting
    state :done
    state :canceled

    event :done do
      transition waiting: :done
    end

    event :cancel do
      transition waiting: :canceled
    end

    event :revival do
      transition [:canceled, :done] => :waiting
    end

  end



  private

  def change_reminders_show_date
    if saved_changes['date'].present?
      reminders.each do |r|
        r.update(show_date: date - r.days_to_show)
      end
    end
  end


end
