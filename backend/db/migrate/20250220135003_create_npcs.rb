class CreateNpcs < ActiveRecord::Migration[8.0]
  def change
    create_table :npcs do |t|
      t.string :name
      t.string :race
      t.string :occupation
      t.text :background
      t.jsonb :personality_traits
      t.jsonb :quirks

      t.timestamps
    end
  end
end
