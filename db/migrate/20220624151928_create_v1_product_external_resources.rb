class CreateV1ProductExternalResources < ActiveRecord::Migration[7.0]
  def change
    create_table :v1_product_external_resources do |t|
      t.references :v1_product, null: false, foreign_key: true
      t.integer :external_id, not_null: true
      t.string :kind, not_null: true

      t.timestamps
    end
  end
end
