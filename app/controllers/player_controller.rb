class PlayerController < ApplicationController
  def new
  end

  def save
    new_player = Player.new(params['player'])
    new_player.reset_rating

    view = new_player.save ? 'new' : 'save_fail'

    render view
  end

  def rankings
    render 'rankings'
  end
end
