# frozen_string_literal: true

class UsersController < ApplicationController
  before_action -> { doorkeeper_authorize! :read }, only: %i[index show]
  def index
    @users = User.all
    render json: @user
  end
  
end
