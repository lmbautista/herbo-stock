class CreateV1Webhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :v1_webhooks do |t|
      t.string :topic, null: false
      t.references :shop, null: false, foreign_key: true
      t.json :body, null: false
      t.string :status, null: false
      t.string :message
      t.integer :retries, null: false, default: 0
      t.datetime :succeeded_at
      t.datetime :failed_at

      t.timestamps
    end
  end
end
