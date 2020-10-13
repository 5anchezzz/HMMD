class VisitsController < ApplicationController
  before_action :set_current_user
  before_action :set_visit, except: [:index, :new, :create]

  def index
    #@visits = current_user.visits
    @q = Visit.where(user:current_user).ransack(params[:q])
    @visits = @q.result.includes(:user).page(params[:page]).per(10)
  end

  def new
    @visit = Visit.new(user: current_user)
    @clients = current_user.clients.actual
    @visit.reminders.new
  end

  def create
    date = parse_date(params)
    time = parse_time(params)

    @visit = Visit.new(visit_params.merge(user: current_user))
    if @visit.reminders.any?
      @visit.reminders.first.user_id = current_user.id
      @visit.reminders.first.show_date = @visit.date - visit_params[:reminders_attributes]['0'][:days_to_show].to_i
    end
    @clients = current_user.clients.actual


    unless CheckAvailableSlotsService.call(current_user, date, time, params[:visit][:duration].to_i, nil)
      #@clients = current_user.clients.actual
      @visit.reminders.new unless @visit.reminders.any?
      flash.now[:danger] = 'Ooops! This time is already booked!'
      render :new
      return
    end

    if @visit.save
      #@visit.need_to_prepare if params[:preparing]
      CreateSlotsService.call(@visit)
      flash[:success] = "New Visit successfully created!"
      redirect_to visit_path(@visit)
    else
      flash.now[:danger] = @visit.errors.full_messages.to_sentence
      render :new
    end
  end

  def show; end

  def destroy
    date = @visit.date
    if @visit.destroy
      flash[:success] = "Visit was successfully deleted!"
      redirect_to root_path(date_for_schedule: date)
    else
      flash[:danger] = 'Ooops! Something went wrong!'
      render action: :show
    end
  end

  def edit
    @clients = current_user.clients.actual
  end

  def update

    if params[:done_action]
      if @visit.update(visit_params)
        @visit.done
        @visit.reminders.update_all(state: 'done')
        flash[:success] = "Visit done!"
        redirect_to visit_path(@visit)
      else
        flash.now[:danger] = "Ooops! Something went wrong!"
        redirect_to visit_path(@visit)
      end
      return
    end

    date = parse_date(params)
    time = parse_time(params)

    change_slot_marker = nil

    if date != @visit.date || time != @visit.start || params[:visit][:duration].to_i != @visit.duration
      change_slot_marker = true
      unless CheckAvailableSlotsService.call(current_user, date, time, params[:visit][:duration].to_i, @visit)
        @clients = current_user.clients.actual
        flash.now[:danger] = 'Ooops! This time is already booked!'
        render action: :edit
        return
      end
    end

    if @visit.update(visit_params)
      if change_slot_marker
        @visit.slots.destroy_all
        CreateSlotsService.call(@visit)
      end
      flash[:success] = "Visit updated!"
      redirect_to visit_path(@visit)
    else
      flash.now[:danger] = @visit.errors.full_messages.to_sentence
      render action: :edit
    end
  end

  def revival

    if @visit.canceled?
      if CheckAvailableSlotsService.call(current_user, @visit.date, @visit.start, @visit.duration, nil)
        if @visit.revival
          CreateSlotsService.call(@visit)
          @visit.update(state: 'actual')
          @visit.update(late: false, negative: false, interval: false)
          flash[:success] = "Cool! This Visit was revived!"
          redirect_to visit_path(@visit)
        else
          flash[:danger] = 'Ooops! Something went wrong!'
          redirect_to visit_path(@visit)
        end
      else
        flash.now[:danger] = 'Ooops! This time is already booked!'
        redirect_to visit_path(@visit)
      end
    elsif @visit.done?
      if CheckAvailableSlotsService.call(current_user, @visit.date, @visit.start, @visit.duration, @visit)
        if @visit.revival
          #CreateSlotsService.call(@visit)
          @visit.reminders.update_all(state: 'actual')
          @visit.update(late: false, negative: false, interval: false)
          flash[:success] = "Cool! This Visit was revived!"
          redirect_to visit_path(@visit)
        else
          flash[:danger] = 'Ooops! Something went wrong!'
          redirect_to visit_path(@visit)
        end

      else
        flash.now[:danger] = 'Ooops! This time is already booked!'
        redirect_to visit_path(@visit)
      end

    end



    #if CheckAvailableSlotsService.call(current_user, @visit.date, @visit.start, @visit.duration, nil)
    #  if @visit.revival
    #    CreateSlotsService.call(@visit)
    #    @visit.reminders.update_all(state: 'actual')
    #    flash[:success] = "Cool! This Visit was revived!"
    #  else
    #    flash[:danger] = 'Ooops! Something went wrong!'
    #  end
    #else
    #  flash.now[:danger] = 'Ooops! This time is already booked!'
    #end
    #redirect_to visit_path(@visit)


  end

  #def ready
  #  if @visit.ready_to_start
  #    flash[:success] = "Cool! Now you're ready to start!"
  #  else
  #    flash[:danger] = 'Ooops! Something went wrong!'
  #  end
  #  redirect_to visit_path(@visit)
  #end

  def done
    if @visit.done
      @visit.reminders.update_all(state: 'done')
      flash[:success] = "Cool! This Visit is done!"
    else
      flash[:danger] = 'Ooops! Something went wrong!'
    end
    redirect_to visit_path(@visit)
  end

  def cancel
    if @visit.cancel
      @visit.slots.destroy_all
      @visit.reminders.update_all(state: 'done')
      flash[:success] = "Hmmm... This Visit has been canceled!"
    else
      flash[:danger] = 'Ooops! Something went wrong!'
    end
    redirect_to visit_path(@visit)
  end

  private

  def set_current_user
    @user = current_user
  end

  def set_visit
    @visit = Visit.find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(:client_id, :label, :description, :date, :start, :duration, :value,
                                  :late, :negative, :interval,
                                  reminders_attributes: [:label, :description, :days_to_show])
  end

  def parse_date(params)
    Date.new(params[:visit]["date(1i)"].to_i, params[:visit]["date(2i)"].to_i, params[:visit]["date(3i)"].to_i)
  end

  def parse_time(params)
    Time.new(params[:visit]["start(1i)"].to_i, params[:visit]["start(2i)"].to_i, params[:visit]["start(3i)"].to_i,
             params[:visit]["start(4i)"].to_i, params[:visit]["start(5i)"].to_i)
  end

end