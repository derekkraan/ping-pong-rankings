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
      recalculate
    else
      render 'save_fail'
    end
  end

  def create
    games = (1..7).map{|i| params["game#{i}"]}.select{|game| game['team1']['score'].present? && game['team2']['score'].present? }

    results = games.map do |_game|
      game = Game.new(params['game'])

      team1 = Team.new(params['team1'])
      team1.score = _game['team1']['score']
      team1.players << Player.find(params['team1_player1']['id']) if params['team1_player1']['id'].present?
      team1.players << Player.find(params['team1_player2']['id']) if params['team1_player2']['id'].present?
      team1.save

      team2 = Team.new(params['team2'])
      team2.score = _game['team2']['score']
      team2.players << Player.find(params['team2_player1']['id']) if params['team2_player1']['id'].present?
      team2.players << Player.find(params['team2_player2']['id']) if params['team2_player2']['id'].present?
      team2.save

      game.teams << team1 << team2

      if game.save
        winners = game.winners.map { |p| p.twitter.present? ? "@#{p.twitter}" : p.name }
        losers = game.losers.map { |p| p.twitter.present? ? "@#{p.twitter}" : p.name }
        begin
          Twitter.update("#{winners.to_sentence} beat #{losers.to_sentence} #{game.winning_score} - #{game.losing_score}")
        rescue
          logger.debug "Twitter post failed for Game id: #{game.id}"
        end
        game
      else
        false
      end
    end

    if results.all?
      redirect_to '/ranking'
    else
      render 'save_fail'
    end
  end

  def destroy
    Game.destroy(params['id'])
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

