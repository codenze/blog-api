class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.references :parent_comment, index: true
      t.timestamps
    end
    add_foreign_key :comments, :comments, column: :parent_comment_id
  end
end
