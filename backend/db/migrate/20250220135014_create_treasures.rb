class CreateTreasures < ActiveRecord::Migration[8.0]
  def change
    create_table :treasures do |t|
      t.string :name
      t.string :treasure_type
      t.string :rarity
      t.text :description
      t.jsonb :properties

      t.timestamps
    end
  end
end
