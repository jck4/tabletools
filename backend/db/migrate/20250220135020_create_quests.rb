class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.string :title
      t.text :setting
      t.text :hook
      t.jsonb :complications
      t.jsonb :potential_outcomes

      t.timestamps
    end
  end
end
