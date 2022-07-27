class AddProcessIdToCatalogLoaderSchedulers < ActiveRecord::Migration[7.0]
  def change
    add_column :catalog_loader_schedulers, :process_id, :string
  end
end
