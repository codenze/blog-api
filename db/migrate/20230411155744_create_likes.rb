class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :status
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.timestamps
    end
  end
end
