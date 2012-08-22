class PlayerController < ApplicationController
  def new
  end

  def save
    new_player = Player.new(params['player'])
    new_player.reset_score

    view = new_player.save ? 'save' : 'save_fail'

    render view
  end
end
