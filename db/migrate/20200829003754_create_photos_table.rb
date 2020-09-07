class CreatePhotosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :photos, force: true do |t|
      t.string  "name"
      t.integer "album_id"
    end
  end
end
