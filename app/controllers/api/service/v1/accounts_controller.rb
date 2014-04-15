class Api::Service::V1::AccountsController < ApplicationController

  before_action :authenticate_user!, except: :create
  before_action :set_account, only: [:show, :update, :destroy]
  after_action :verify_authorized, only: [:update, :destroy]

  skip_before_action :current_tenant, only: [:current]

  def index
    @accounts = Account.all
  end

  def show
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      sign_in @account.user
      render action: :show, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end

  end

  def update
    authorize @account

    if @account.update(account_params)
      render action: :show, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @account

    if @account.destroy
      head :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def current
    @account = Account.find_by_user_id current_user.id
    render action: :show, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account)
    .permit(:username, :bio, :avatar, :role, user_attributes:
        [:first_name, :last_name, :email, :password, :password_confirmation])
  end

end
