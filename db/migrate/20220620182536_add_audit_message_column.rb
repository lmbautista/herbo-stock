class AddAuditMessageColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :audits, :message, :text
  end
end
