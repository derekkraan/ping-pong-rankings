class SessionsController < ApplicationController
  def create
    if player = Player.where(google_uid: auth_hash['uid']).first
      player.update_attributes(google_image_url: auth_hash['info']['image'])
      session[:player_id] = player.id
    else
      player = Player.create(
        name:       auth_hash['info']['name'],
        google_uid: auth_hash['uid'],
        google_image_url: auth_hash['info']['image'],
        rating: EloRanking::DEFAULT_PLAYER_RATING
      )
      session[:player_id] = player.id
    end
    redirect_to ranking_players_path
  end

  def destroy
    reset_session
    redirect_to :root
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
