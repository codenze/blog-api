class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :content
      t.string :status
      t.references :parent_post, index: true

      t.timestamps
    end
    add_foreign_key :posts, :posts, column: :parent_post_id
  end
end
