class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :text
      t.string :slug, index: true
      t.belongs_to :user, index: true
      t.references :notable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
