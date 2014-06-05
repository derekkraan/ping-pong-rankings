class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    redirect_to player_ranking_path(current_player.id) if current_player
  end

  def current_player
    return nil unless session[:player_id]
    @current_player ||= Player.where(id: session[:player_id]).first
  end
end
