class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :assigned_by
      t.integer :assigned_to
      t.belongs_to :user, index: true
      t.integer :percent_complete
      t.date :start_date
      t.date :finish_date
      t.date :completion_date
      t.string :status
      t.string :slug, index: true
      t.references :taskable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
