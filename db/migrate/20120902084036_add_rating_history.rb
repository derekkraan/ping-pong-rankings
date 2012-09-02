class AddRatingHistory < ActiveRecord::Migration
  def change
    create_table :rating_history do |rh|
      rh.references :game
      rh.references :player
      rh.integer :rating
    end
  end
end
