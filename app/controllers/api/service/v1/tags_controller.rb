class Api::Service::V1::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:update, :destroy]

  def index
    query = params[:q]
    @tags = Tag.where('name LIKE ?', "%#{query.nil? ? '' : query.downcase}%")
  end

  def create

  end

  def update

  end

  def destroy

  end

  def autocomplete
    query = params[:q]
    @tags = Tag.where('name LIKE ?', "%#{query.nil? ? '' : query.downcase}%")
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
