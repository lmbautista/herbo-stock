# frozen_string_literal: true

FactoryBot.define do
  factory :v1_product, class: "V1::Product" do
    shop { build(:shop) }
    sku { "MyString" }
    definicion { "MyString" }
    ampliacion { "MyText" }
    disponible { 1 }
    iva { 1.5 }
    req_eq { 1.5 }
    pvd { 1.5 }
    pvd_iva { 1.5 }
    pvd_iva_rec { 1.5 }
    pvp { 1.5 }
    peso { 1.5 }
    ean { "MyString" }
    hay_foto { false }
    imagen { "MyString" }
    fecha_imagen { "2022-06-14 16:15:54" }
    cat { "MyString" }
    marca { "MyString" }
    frio { false }
    congelado { false }
    bio { false }
    apto_diabetico { false }
    gluten { false }
    huevo { false }
    lactosa { false }
    apto_vegano { false }
    unidad_medida { "MyString" }
    cantidad_medida { 1.5 }
  end
end
