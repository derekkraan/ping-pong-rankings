class ApplicationController < ActionController::Base
  protect_from_forgery

  # TODO: remove placeholder
  def current_player
    Player.first
  end
end
