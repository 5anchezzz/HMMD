# frozen_string_literal: true

class Day < ApplicationRecord

  class << self

    def workload(user, date)
      start_hour = Time.new(2000,01,01,user.start_hour,0)
      start_slot = Slot.get_number_by_time(start_hour)
      end_hour = Time.new(2000,01,01,user.end_hour,0)
      end_slot = Slot.get_number_by_time(end_hour)
      fullday_slots = end_slot - start_slot
      booked_slots = Slot.where(user: user, date: date).count
      ((booked_slots.to_f / fullday_slots.to_f) * 100).round(0)
    end

    def longest_available_period(user, date)
      available_periods = []
      booked_slots = Slot.where(user: user, date: date).map(&:number)
      start_hour = Time.new(2000,01,01,user.start_hour,0)
      start_slot = Slot.get_number_by_time(start_hour)
      end_hour = Time.new(2000,01,01,user.end_hour,0)
      end_slot = Slot.get_number_by_time(end_hour)
      duration = 0

      (start_slot..end_slot-1).each_with_index do |e, i|
        if booked_slots.include? e
          available_periods << duration
          duration = 0
        else
          duration += 1
          available_periods << duration if i == (start_slot..end_slot-2).size
        end
      end
      (available_periods.max * 0.5).round(1)
    end

    def build_schedule_for_one_day(user, date)
      schedule_notice = false
      datetime_to_show = date.to_datetime
      booked_slots_of_this_day = Slot.where(user: user, date: datetime_to_show).order(:number)
      if booked_slots_of_this_day.any?
        start_datetime_from_profile = datetime_to_show.change({ hour: user.start_hour})
        first_slot_number_from_profile = Slot.get_number_by_time(start_datetime_from_profile)
        first_slot_number_by_fact = booked_slots_of_this_day.first.number
        hour_of_start_slot = Slot.get_time_by_number(first_slot_number_by_fact).strftime('%H').to_i
        minute_of_start_slot = Slot.get_time_by_number(first_slot_number_by_fact).strftime('%M').to_i
        start_datetime_by_fact = datetime_to_show.change({ hour: hour_of_start_slot, min: minute_of_start_slot})
        if first_slot_number_from_profile > first_slot_number_by_fact
          first_slot_number = first_slot_number_by_fact
          start_datetime = start_datetime_by_fact
          schedule_notice = true
        else
          first_slot_number = first_slot_number_from_profile
          start_datetime = start_datetime_from_profile
        end
        end_datetime_from_profile = datetime_to_show.change({ hour: user.end_hour})
        end_slot_number_from_profile = Slot.get_number_by_time(end_datetime_from_profile)
        end_slot_number_by_fact = booked_slots_of_this_day.last.number + 1
        if end_slot_number_from_profile > end_slot_number_by_fact
          end_slot_number = end_slot_number_from_profile
        else
          end_slot_number = end_slot_number_by_fact
          schedule_notice = true
        end
      else
        start_datetime = datetime_to_show.change({ hour: user.start_hour})
        first_slot_number = Slot.get_number_by_time(start_datetime)
        end_datetime = datetime_to_show.change({ hour: user.end_hour})
        end_slot_number = Slot.get_number_by_time(end_datetime)
      end
      times_to_repeat = end_slot_number - first_slot_number
      index_hash_to_show = {}
      period_size = 1
      times_to_repeat.times do
        slots = Slot.where(user: user, date: date, number: first_slot_number)
        if slots.any?
          visit = slots.last.visit
          visit_datetime = visit.date.to_datetime.change({ hour: visit.start.strftime('%H').to_i,
                                                           min: visit.start.strftime('%M').to_i})
          if index_hash_to_show[visit.id].present?
            period_size += 1
            index_hash_to_show[visit.id] = {datetime: visit_datetime, state: 'booked', size: period_size}
          else
            period_size = 1
            index_hash_to_show[visit.id] = {datetime: visit_datetime, state: 'booked', size: period_size}
          end
          first_slot_number += 1
          start_datetime += 30.minutes
        else
          index_hash_to_show["slot-#{first_slot_number}"] = {datetime: start_datetime, state: 'available', size: 1}
          first_slot_number += 1
          start_datetime += 30.minutes
        end
      end
      index_hash_to_show[:statistics] = { workload: workload(user, date),
                                          period: longest_available_period(user, date),
                                          visits: Visit.where(user: user, date: date).count }
      index_hash_to_show[:schedule_notice] = schedule_notice
      index_hash_to_show
    end

  end

end