class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.belongs_to :user
      t.timestamps
    end
  end
end
