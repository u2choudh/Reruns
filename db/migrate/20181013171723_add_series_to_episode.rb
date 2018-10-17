class AddSeriesToEpisode < ActiveRecord::Migration[5.2]
  def change
    add_reference :episodes, :series, foreign_key: true
  end
end
