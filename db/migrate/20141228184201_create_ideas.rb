class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.text :description
      t.text :benifits
      t.text :problem_solves
      t.string :slug, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
