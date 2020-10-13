# frozen_string_literal: true

module CreateSlotsService
  module_function

  def call(visit)
    number_of_first_slot = Slot.get_number_by_time(visit.start)
    number_of_slots = (visit.duration / 0.5).to_i

    number_of_slots.times do
      Slot.create(user: visit.user, visit: visit, date: visit.date, number: number_of_first_slot)
      number_of_first_slot += 1
    end
  end

end