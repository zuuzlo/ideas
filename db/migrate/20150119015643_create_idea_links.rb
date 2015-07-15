class CreateIdeaLinks < ActiveRecord::Migration
  def change
    create_table :idea_links do |t|
      t.string :name
      t.string :link_url
      t.belongs_to :user, index: true
      t.string :slug, index: true
      t.references :idea_linkable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
