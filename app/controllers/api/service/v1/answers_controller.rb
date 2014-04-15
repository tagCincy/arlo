class Api::Service::V1::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy]
  after_action :verify_authorized
  
  before_filter :load_question, only: [:create]

  def show

  end

  def create
    @answer = Answer.new(answer_params)
    @account = Account.find_by_user_id current_user
    @answer.account_id = @account.id
    authorize @answer
    
    if @question.answers << @answer
      render action: :show, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end  
    
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end

  end

  def destroy
    authorize @answer

    if @answer.destroy
      head :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end
  
  private 
  
  def set_answer
    @answer = Answer.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:content)
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
end
