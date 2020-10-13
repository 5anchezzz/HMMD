# frozen_string_literal: true

module CheckAvailableSlotsService
  module_function

  def call(user, date, start, duration, visit)

    number_of_slots = (duration/0.5).to_i

    array_of_required_slot_numbers = []
    first_slot_number = Slot.get_number_by_time(start)

    number_of_slots.times do
      array_of_required_slot_numbers << first_slot_number
      first_slot_number += 1
    end

    if visit
      true if Slot.where.not(visit: visit).where(user: user, date: date, number: array_of_required_slot_numbers).empty?
    else
      true if Slot.where(user: user, date: date, number: array_of_required_slot_numbers).empty?
    end

  end

end