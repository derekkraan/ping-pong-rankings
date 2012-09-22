class AddTweetToGames < ActiveRecord::Migration
  def change
    add_column :games, :tweet_id, :string
  end
end
