class GamesController < ApplicationController
  def show
  end

  def new
    @game = Game.new
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to '/ranking'
    else
      render 'save_fail'
    end
  end

  def create
    game = Game.new(params['game'])
    (team1 = Team.new(params['team1'])).save
    team1.players << Player.find(params['team1_player1']['id']) if params['team1_player1']['id'].present?
    team1.players << Player.find(params['team1_player2']['id']) if params['team1_player2']['id'].present?

    (team2 = Team.new(params['team2'])).save
    team2.players << Player.find(params['team2_player1']['id']) if params['team2_player1']['id'].present?
    team2.players << Player.find(params['team2_player2']['id']) if params['team2_player2']['id'].present?

    game.teams << team1 << team2

    if game.save
      winners = game.winners.map { |p| p.twitter.present? ? "@#{p.twitter}" : p.name }
      losers = game.losers.map { |p| p.twitter.present? ? "@#{p.twitter}" : p.name }
      begin
        Twitter.update("#{winners.to_sentence} beat #{losers.to_sentence} #{game.winning_score} - #{game.losing_score}")
      rescue
        logger.debug "Twitter post failed for Game id: #{game.id}"
      end

      redirect_to '/ranking'
    else
      render 'save_fail'
    end
  end

  def del
    Game.delete(params['game_id'])
    recalculate
  end

  def recalculate
    players = Player.all
    players.each &:reset_rating
    players.each &:save

    Game.order('created_at asc').each &:calculate_player_rankings
    redirect_to '/ranking'
  end

end

