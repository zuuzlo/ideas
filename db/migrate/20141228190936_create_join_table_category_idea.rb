class CreateJoinTableCategoryIdea < ActiveRecord::Migration
  def change
    create_join_table :categories, :ideas do |t|
      #t.index [:category_id, :idea_id]
      t.index [:idea_id, :category_id]
    end
  end
end
