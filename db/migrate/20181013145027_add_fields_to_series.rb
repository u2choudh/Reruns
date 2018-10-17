class AddFieldsToSeries < ActiveRecord::Migration[5.2]
  def change
    add_column :series, :url, :string
    add_column :series, :rating, :string
    add_column :series, :year, :string
  end
end
