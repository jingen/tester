class CreateCategoriesProductsJoin < ActiveRecord::Migration
  def change
    create_table :categories_products_joins, {:id => false} do |t|
      t.integer :category_id
      t.integer :product_id
    end
  end
end
