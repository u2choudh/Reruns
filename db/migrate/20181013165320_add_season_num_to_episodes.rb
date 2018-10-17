class AddSeasonNumToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :season, :string
  end
end
