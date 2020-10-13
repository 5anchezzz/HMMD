class HomeController < ApplicationController

  def index
    @user = current_user
    date_to_show = params[:date_for_schedule] || Date.today
    if current_user && current_user.state == 'completed'
      @index_hash = Day.build_schedule_for_one_day(current_user, date_to_show)
      @reminders = current_user.reminders.home_list
    end
  end

  def week
    @user = current_user

    if params[:date_for_schedule]
      date_to_show = params[:date_for_schedule].to_date
    else
      date_to_show = Date.today
    end

    @week_number = date_to_show.strftime("%W").to_i + 1
    day_number = date_to_show.strftime("%u").to_i
    date_of_week_start = date_to_show - (day_number - 1)
    @date_of_week_start = date_of_week_start

    @hash_to_show = {}

    7.times do
      workload = Day.workload(@user, date_of_week_start)
      longest_available_period = Day.longest_available_period(@user, date_of_week_start)
      @hash_to_show[date_of_week_start.strftime("%u").to_i] = {date: date_of_week_start,
                                                               workload: workload,
                                                               longest_available_period: longest_available_period,
                                                               visits: Visit.where(user: @user, date: date_of_week_start).count}
      date_of_week_start += 1
    end

  end

  def month
    @user = current_user

    if params[:date_for_schedule]
      date_to_show = params[:date_for_schedule].to_date
    else
      date_to_show = Date.today
    end

    beginning_of_month = date_to_show.at_beginning_of_month
    first_week = beginning_of_month.strftime("%W").to_i + 1
    end_of_month = date_to_show.end_of_month
    days_in_month = Time.days_in_month(date_to_show.month, date_to_show.year)

    weeks_in_month = end_of_month.strftime("%W").to_i + 1 - first_week + 1

    @begin_of_month = beginning_of_month
    @month_to_show = {}

    weeks_in_month.times do
      @month_to_show[first_week] = {}
      first_week += 1
    end

    days_in_month.times do
      @month_to_show[beginning_of_month.strftime("%W").to_i + 1][beginning_of_month.strftime("%A")] =
          {date: beginning_of_month,
           workload: Day.workload(@user, beginning_of_month),
           period: Day.longest_available_period(@user, beginning_of_month),
           visits: Visit.where(user: @user, date: beginning_of_month).count}
      beginning_of_month += 1
    end


  end

end
