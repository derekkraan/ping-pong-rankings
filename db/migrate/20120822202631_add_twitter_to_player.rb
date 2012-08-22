class AddTwitterToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :twitter, :string
  end
end
