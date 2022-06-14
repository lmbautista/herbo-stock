class CreateV1Products < ActiveRecord::Migration[7.0]
  def change
    create_table :v1_products, primary_key: :id do |t|
      t.string :sku, null: false
      t.string :definicion, null: false
      t.text :ampliacion, null: false
      t.integer :disponible, null: false
      t.float :iva, null: false
      t.float :req_eq, null: false
      t.float :pvd, null: false
      t.float :pvd_iva, null: false
      t.float :pvd_iva_rec, null: false
      t.float :pvp, null: false
      t.float :peso, null: false
      t.string :ean, null: false
      t.boolean :hay_foto, null: false
      t.string :imagen, null: false
      t.datetime :fecha_imagen, null: false
      t.string :cat, null: false
      t.string :marca, null: false
      t.boolean :frio, null: false
      t.boolean :congelado, null: false
      t.boolean :bio, null: false
      t.boolean :apto_diabetico, null: false
      t.boolean :gluten, null: false
      t.boolean :huevo, null: false
      t.boolean :lactosa, null: false
      t.boolean :apto_vegano, null: false
      t.string :unidad_medida, null: false
      t.float :cantidad_medida, null: false

      t.timestamps
    end
  end
end
