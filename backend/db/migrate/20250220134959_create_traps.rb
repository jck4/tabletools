class CreateTraps < ActiveRecord::Migration[8.0]
  def change
    create_table :traps do |t|
      t.string :name
      t.text :location
      t.string :trap_type
      t.text :trigger
      t.text :mechanism
      t.jsonb :effects
      t.string :disarm_check
      t.integer :disarm_difficulty

      t.timestamps
    end
  end
end
