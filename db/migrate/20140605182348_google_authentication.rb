class GoogleAuthentication < ActiveRecord::Migration
  def change
    remove_column :players, :twitter
    add_column :players, :google_uid, :string
    add_column :players, :google_picture_url, :string
  end
end
