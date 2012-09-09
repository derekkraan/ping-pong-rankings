class PlayersController < ApplicationController
  def show
    @player = Player.includes([:games, :teams, :rating_histories]).find(params[:id])
  end

  def new
    @player = Player.new
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      redirect_to @player
    else
      render 'save_fail'
    end
  end

  def create
    player = Player.new(params['player'])
    player.reset_rating

    if player.save
      redirect_to new_player_path
    else
      render 'save_fail'
    end
  end

  def destroy
    Player.delete(params['id'])
    redirect_to new_player_path
  end

  def rankings
    render 'rankings'
  end
end
