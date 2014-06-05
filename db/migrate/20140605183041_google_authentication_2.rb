class GoogleAuthentication2 < ActiveRecord::Migration
  def change
    rename_column :players, :google_picture_url, :google_image_url
  end
end
