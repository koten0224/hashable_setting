module HashableSetting
  module Migration
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
end