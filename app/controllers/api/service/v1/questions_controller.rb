class Api::Service::V1::QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :count]
  before_action :set_question, only: [:show, :update, :destroy]
  after_action :verify_authorized, only: [:update, :destroy]

  def index
    pub = current_tenant.nil? ? true : params[:p]
    Rails.logger.debug pub
    off = params[:o].nil? ? 0 : params[:o]
    @questions = Question.offset(off).limit(10).order(created_at: :desc)
    @questions = @questions.where(public: pub) unless pub.nil?
  end

  def show
    unless @question.public?
      authorize @question
    end
  end

  def create
    @question = Question.new(question_params)
    @account = Account.find_by_user_id current_user
    @question.account_id = @account.id

    @question.group = current_tenant unless current_tenant.nil?

    if @question.save
      render action: :show, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @question

    if @question.update(question_params)
      render action: :show, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    if @question.destroy
      head :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def count
    @count = Question.count
    render json: @count, status: :ok
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, :public, :accepted_answer, tag_ids: [])
  end
end
