class SessionsController < ApplicationController
  def create
    if player = Player.where(google_uid: auth_hash['info']['uid']).first
      session[:player_id] = player.id
    else
      player = Player.create(
        name:       auth_hash['info']['name'],
        google_uid: auth_hash['info']['uid'],
        google_image_url: auth_hash['info']['image']
      )
      session[:player_id] = player.id
    end
    redirect_to player_ranking_path(player)
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
