class CreateCatalogLoaderSchedulers < ActiveRecord::Migration[7.0]
  def change
    create_table :catalog_loader_schedulers, primary_key: :id do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :time_unit, null: false
      t.integer :time_amount, null: false

      t.timestamps
    end
  end
end
