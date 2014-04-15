class Api::Service::V1::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :update, :destroy]
  before_action :set_account, only: [:index, :create]
  after_action :verify_authorized, only: [:show, :create, :update, :destroy]
  after_action :check_or_set_admin, only: [:create]

  def index
    @groups = @account.groups
  end

  def show
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    authorize @group

    if @group.valid?
      @account.groups << @group
      render action: :show, status: :created
    else
      render json: @group.errors, status: :unprocessable_entity
    end

  end

  def update
    authorize @group

    if @group.update(group_params)
      render action: :show, status: :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @group

    if @group.destroy
      head :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :code, :description, account_ids: [])
  end

  def set_account
    @account = Account.find_by_user_id current_user
  end

  def check_or_set_admin
    if @account.tech?
      @account.admin!
    end
  end
end
