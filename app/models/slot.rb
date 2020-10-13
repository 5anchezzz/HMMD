class Slot < ApplicationRecord
  belongs_to :user
  belongs_to :visit

  def self.get_number_by_time(time)
    hour = time.strftime('%H').to_i
    minute = time.strftime('%M').to_i
    number = (hour * 2) + 1
    number = number + 1 if minute == 30
    number
  end

  def self.get_time_by_number(number)
    if (1..48).include? number
      if number.even?
        hour = ((number.to_f / 2.0) - 1.0).to_i
        minute = 30
      else
        hour = ((number.to_f / 2.0) - 0.5).to_i
        minute = 0
      end
    else
      hour = 0
      minute = 0
    end
    Time.new(2000, 1, 1, hour, minute, 0)
  end

end
