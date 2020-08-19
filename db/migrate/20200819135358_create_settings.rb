class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :name
      t.string :value
      t.string :klass

      t.timestamps
    end
  end
end
