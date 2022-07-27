class AddNextScheduledAtToCatalogLoaderScheduler < ActiveRecord::Migration[7.0]
  def change
    add_column :catalog_loader_schedulers, :next_scheduled_at, :datetime
  end
end
