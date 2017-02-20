class CreateSpreeferencePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :spreeference_preferences do |t|
      t.string    :key
      t.text      :value
      t.timestamps
    end
    add_index :spreeference_preferences, :key, unique: true
  end
end
