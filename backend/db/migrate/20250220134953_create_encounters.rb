class CreateEncounters < ActiveRecord::Migration[8.0]
  def change
    create_table :encounters do |t|
      t.string :title
      t.text :setting
      t.jsonb :factions
      t.jsonb :clues
      t.jsonb :objectives
      t.jsonb :environmental_hazards
      t.jsonb :reactive_elements
      t.jsonb :outcomes

      t.timestamps
    end
  end
end
