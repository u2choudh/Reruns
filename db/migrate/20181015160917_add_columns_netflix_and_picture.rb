class AddColumnsNetflixAndPicture < ActiveRecord::Migration[5.2]
  def change
    add_column :series, :image, :string
    add_column :episodes, :netflix_id, :string
  end
end
