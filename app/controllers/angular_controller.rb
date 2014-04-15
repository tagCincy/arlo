class AngularController < ApplicationController
  def index

  end
  def show
    render "angular/#{params[:path]}", layout: nil
  end
end
