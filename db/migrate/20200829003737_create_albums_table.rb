class CreateAlbumsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :albums, force: true do |t|
      t.string "name"
    end
  end
end
