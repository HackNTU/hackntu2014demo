class LandingsController < ApplicationController
  def index
    if current_user
      redirect_to controller: :projects, action: :new
    else
      redirect_to new_user_session_path
    end
  end
end
