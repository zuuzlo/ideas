class CreateJots < ActiveRecord::Migration
  def change
    create_table :jots do |t|
      t.text :context
      t.belongs_to :user, index: true
      t.integer :position, index: true
      t.string :status
      t.timestamps null: false
    end
  end
end
