class CreateFeedentries < ActiveRecord::Migration
  def change
    create_table :feedentries do |t|
      t.string :title
      t.string :link

      t.timestamps null: false
    end
  end
end
