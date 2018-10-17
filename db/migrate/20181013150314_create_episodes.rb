class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :rating
      t.string :description
      t.string :epnum

      t.timestamps
    end
  end
end
