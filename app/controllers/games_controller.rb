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
      Game.recalculate_all
      redirect_to '/ranking'
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
        game.tweet_result
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
    game = Game.find(params['id'])
    if game.created_at > 5.minutes.ago
      game.destroy()
      Game.recalculate_all
    end
    redirect_to '/ranking'
  end

  def recalculate
    Game.recalculate_all
    redirect_to '/ranking'
  end

end

