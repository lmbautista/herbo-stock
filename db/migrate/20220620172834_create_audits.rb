class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits, primary_key: :id do |t|
      t.string :operation_id, null: false
      t.text :raw_params, null: false
      t.string :status, null: false
      t.datetime :started_at
      t.datetime :succeeded_at
      t.datetime :failed_at

      t.timestamps
    end
  end
end
