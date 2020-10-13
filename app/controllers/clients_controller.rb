class ClientsController < ApplicationController
  before_action :set_current_user
  before_action :set_client, except: [:index, :archived, :new, :create]

  def index
    #@clients = current_user.clients.actual
    @q = Client.actual.where(user:current_user).ransack(params[:q])
    @clients = @q.result.includes(:user).page(params[:page]).per(10)
  end

  def archived
    #@qclients = current_user.clients.archive
    @q = Client.archive.where(user:current_user).ransack(params[:q])
    @clients = @q.result.includes(:user).page(params[:page]).per(10)
  end

  def show; end

  def edit; end

  def new
    @client = Client.new(user: current_user)
  end

  def create
    @client = Client.new(client_params.merge(user: current_user))

    if @client.save
      flash[:success] = "New Client successfully created!"
      redirect_to client_path(@client)
    else
      render :new
    end
  end

  def update
    if @client.update(client_params)
      flash[:success] = "Client updated!"
      redirect_to client_path(@client)
    else
      flash.now[:danger] = @client.errors.full_messages.to_sentence
      render action: :edit
    end
  end

  def block
    if @client.update!(blocked: true)
      flash[:success] = "Client was blocked!"
    else
      flash[:danger] = 'Something went wrong!'
    end
    redirect_to client_path(@client)
  end

  def unblock
    if @client.update!(blocked: false)
      flash[:success] = "Client was unblocked!"
    else
      flash[:danger] = 'Something went wrong!'
    end
    redirect_to client_path(@client)
  end


  private

  def set_current_user
    @user = current_user
  end

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :surname, :birthday, :sex, :phone, :email, :description, :user)
  end

end