class RemindersController < ApplicationController
  before_action :set_current_user
  before_action :set_reminder, except: [:new, :create]

  def new
    @reminder = Reminder.new(user: current_user, visit_id: params[:visit_id])
    @visit = Visit.find(params[:visit_id])
  end

  def create
    @reminder = current_user.reminders.new(reminder_params.merge(show_date: Visit.find(reminder_params[:visit_id].to_i).date - reminder_params[:days_to_show].to_i))

    if @reminder.save
      flash[:success] = "New Reminder successfully created!"
      redirect_to visit_path(@reminder.visit)
    else
      render :new
    end
  end

  def update
    if @reminder.update(reminder_params)
      flash[:success] = "Reminder updated!"
      redirect_to visit_path(@reminder.visit)
    else
      flash.now[:danger] = @reminder.errors.full_messages.to_sentence
      render action: :edit
    end
  end

  def done
    if @reminder.done
      flash[:success] = "Reminder done!"
    else
      flash[:danger] = 'Something went wrong!'
    end
    #redirect_to visit_path(@reminder.visit)
    redirect_back(fallback_location: root_path)
  end

  def actual
    if @reminder.actual
      flash[:success] = "Reminder back to actual!"
    else
      flash[:danger] = 'Something went wrong!'
    end
    #redirect_to visit_path(@reminder.visit)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @reminder.destroy
      flash[:success] = "Reminder was successfully deleted!"
    else
      flash[:danger] = 'Ooops! Something went wrong!'
    end
    redirect_back(fallback_location: root_path)
  end


  private

  def set_current_user
    @user = current_user
  end

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:label, :description, :days_to_show, :visit_id)
  end

end