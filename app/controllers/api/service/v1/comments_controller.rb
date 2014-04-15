class Api::Service::V1::CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_comment, only: [:update, :destroy]
  after_action :verify_authorized, only: [:update, :destroy]

  before_filter :load_commentable, only: [:index, :create]

  def index
    if @commentable.kind_of? Question
      Question.unscoped do
        @comments = @commentable.comments.order(id: :asc)
      end
    else
      @comments = @commentable.comments.order(id: :asc)
    end
  end

  def show

  end

  def create
    @account = Account.find_by_user_id current_user
    @comment = Comment.new(comment_params)
    @comment.account_id = @account.id

    if @commentable.comments << @comment
      render action: :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @comment

    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  def destroy
    authorize @comment

    if @comment.destroy
      head :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    klass = [Question, Answer, Ticket].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end
end
