class User < ApplicationRecord

  validate :check_working_hours, on: :update

  has_many :clients, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_many :reminders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  state_machine :state, initial: :new do

    state :new
    state :completed

    event :complete do
      transition new: :completed
    end
  end

  private

  def check_working_hours
    if start_hour > end_hour
      errors.add(:base, 'Start hour should be less than end hour')
      throw(:abort)
    end
  end

end
