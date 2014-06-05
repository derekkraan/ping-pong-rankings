class PlayersController < ApplicationController
  def show
    @player = Player.includes([:games, :teams, :rating_histories]).find(params[:id])
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(player_params)
      redirect_to @player
    else
      render 'save_fail'
    end
  end

  def destroy
    Player.delete(params['id'])
    redirect_to new_player_path
  end

  def ranking
  end

  private

  def player_params
    params.require(:player).permit(:name, :rating)
  end
end
