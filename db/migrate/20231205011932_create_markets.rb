class CreateMarkets < ActiveRecord::Migration[7.1]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :county
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
