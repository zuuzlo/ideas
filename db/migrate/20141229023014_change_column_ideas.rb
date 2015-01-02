class ChangeColumnIdeas < ActiveRecord::Migration
  def change
    change_table :ideas do |t|
      t.rename :benifits, :benefits
    end
  end
end
