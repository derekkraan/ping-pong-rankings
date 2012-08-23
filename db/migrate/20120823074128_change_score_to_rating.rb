class ChangeScoreToRating < ActiveRecord::Migration
  def change
    rename_column :players, :score, :rating
  end
end
