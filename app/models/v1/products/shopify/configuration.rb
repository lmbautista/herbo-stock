# frozen_string_literal: true

module V1
  module Products
    module Shopify
      class Configuration
        def initialize
          @title_rules = TITLE_RULES
          @categories_rules = CATEGORIES_RULES
          @tags_rules = TAGS_RULES
        end

        attr_reader :title_rules, :categories_rules, :tags_rules

        CATEGORIES = [
          BULK = "GRANEL",
          CHILD = "ALIMENTACIÓN INFANTIL",
          CHOCOLATE = "CHOCOLATES",
          CHRISTMAS = "PRODUCTOS NAVIDEÑOS",
          BREAKFAST = "DESAYUNO Y ENTRE HORAS",
          DIETARY_SUPPLEMENT = "COMPLEMENTOS ALIMENTICIOS",
          ESSENTIAL_OILS = "ACEITES ESENCIALES",
          FOOD_AND_SPORT = "ALIMENTACIÓN DEPORTIVA",
          SPORT = "DEPORTE",
          HOME = "HOGAR",
          INFUSIONS_TEAS_AND_PLANTS = "INFUSIONES, TÉS Y PLANTAS",
          MILK_PRODUCTS = "LÁCTEOS",
          NATURAL_COSMETICS = "COSMÉTICA NATURAL",
          NUTRITION = "ALIMENTACIÓN",
          PASTA_CEREALS_AND_LEGUMES = "PASTAS, CEREALES Y LEGUMBRES",
          PETS = "MASCOTAS",
          SANITATION = "HIGIENE",
          SALT_AND_CONDIMENTS = "ACEITES Y CONDIMENTOS",
          SEX = "SEXUALIDAD",
          SUPERFOODS = "SUPERALIMENTOS",
          SWEETENERS = "EDULCORANTES",
          VEGAN = "ALIMENTACIÓN VEGANA"
        ].freeze

        TITLE_RULES = [
          { regexp: /ˆCONG/, normalized_value: "congelado" },
          { regexp: /^REFRIG\s/, normalized_value: "" },
          { regexp: /SPIRULINA\s/, normalized_value: "espirulina" },
          { regexp: /\sTEA\s/, normalized_value: "té" }
        ].freeze

        CATEGORIES_RULES = [
          { regexp: /.*#{CHOCOLATE}.*/, normalized_value: CHOCOLATE },
          { regexp: /.*#{BREAKFAST}.*/, normalized_value: BREAKFAST },
          { regexp: /.*ALIMENTACIÓN, BARRITAS.*/, normalized_value: BREAKFAST },
          { regexp: /.*#{DIETARY_SUPPLEMENT}.*/, normalized_value: DIETARY_SUPPLEMENT },
          { regexp: /.*#{ESSENTIAL_OILS}.*/, normalized_value: ESSENTIAL_OILS },
          { regexp: /.*ALIMENTACIÓN, DEPORTE.*/, normalized_value: FOOD_AND_SPORT },
          { regexp: /.*INFUSIONES TÉS Y PLANTAS.*/, normalized_value: INFUSIONS_TEAS_AND_PLANTS },
          { regexp: /.*#{MILK_PRODUCTS}.*/, normalized_value: MILK_PRODUCTS },
          { regexp: /.*#{NATURAL_COSMETICS}.*/, normalized_value: NATURAL_COSMETICS },
          { regexp: /.*#{PETS}.*/, normalized_value: PETS },
          { regexp: /.*#{SANITATION}.*/, normalized_value: SANITATION },
          { regexp: /.*ACEITES SAL Y CONDIMENTOS.*/, normalized_value: SALT_AND_CONDIMENTS },
          { regexp: /.*VEGETALES.*/, normalized_value: VEGAN },
          { regexp: /.*SUSTITUTOS LÁCTEOS.*/, normalized_value: VEGAN },
          { regexp: /.*SUSTITUTOS CARNE Y PESCADO.*/, normalized_value: VEGAN },
          { regexp: /.*HOGAR.*/, normalized_value: HOME },
          { regexp: /.*BOTELLAS REUTILIZABLES.*/, normalized_value: HOME },
          { regexp: /.*DEPORTE, GRANEL.*/, normalized_value: FOOD_AND_SPORT },
          { regexp: /.*DEPORTE, OFERTAS.*/, normalized_value: FOOD_AND_SPORT },
          { regexp: /.*DEPORTE.*/, normalized_value: SPORT },
          { regexp: /.*#{SUPERFOODS}.*/, normalized_value: SUPERFOODS },
          { regexp: /.*ALGAS.*/, normalized_value: SUPERFOODS },
          { regexp: /.*#{SWEETENERS}.*/, normalized_value: SWEETENERS },
          { regexp: /.*ENDULZANTES.*/, normalized_value: SWEETENERS },
          { regexp: /.*#{CHRISTMAS}.*/, normalized_value: CHRISTMAS },
          { regexp: /.*#{CHILD}.*/, normalized_value: CHILD },
          { regexp: /.*HARINAS.*/, normalized_value: PASTA_CEREALS_AND_LEGUMES },
          { regexp: /.*PASTAS Y ARROZ.*/, normalized_value: PASTA_CEREALS_AND_LEGUMES },
          { regexp: /.*CEREALES LEGUMBRES.*/, normalized_value: PASTA_CEREALS_AND_LEGUMES },
          { regexp: /.*ALIMENTACIÓN, GALLETAS.*/, normalized_value: BREAKFAST },
          { regexp: /.*#{BULK}.*/, normalized_value: BULK },
          { regexp: /.*#{SEX}.*/, normalized_value: SEX },
          { regexp: /.*COCINA CREATIVA.*/, normalized_value: NUTRITION },
          { regexp: /.*ALIMENTACIÓN.*/, normalized_value: NUTRITION }
        ].freeze

        TAGS_RULES = [
          { regexp: /.*CREMA.*/, normalized_value: "CREMAS" },
          { regexp: /.*LECHE.*/, normalized_value: "LECHE" },
          { regexp: /.*(\sTE\s|\sTEA\s).*/, normalized_value: "TÉ" },
          { regexp: /.*QUESO.*/, normalized_value: "QUESOS" },
          { regexp: /.*PAT(É|E).*/, normalized_value: "PATÉS" },
          { regexp: /.*JAM(Ó|O)N.*/, normalized_value: "JAMÓN" },
          { regexp: /.*QUESO*.LONCHAS.*/, normalized_value: "QUESOS LONCHAS" },
          { regexp: /.*QUESO*.RALLADO.*/, normalized_value: "QUESOS RALLADOS" },
          { regexp: /.*QUESO*.UNTAR.*/, normalized_value: "QUESOS UNTAR" },
          { regexp: /.*LONCHAS.*/, normalized_value: "LONCHAS" },
          { regexp: /.*MANTEQUILLA.*/, normalized_value: "MANTEQUILLAS" },
          { regexp: /.*(?<!SIN\s)AZUCAR.*/, normalized_value: "AZÚCARES" },
          { regexp: /.*STEVIA.*/, normalized_value: "STEVIA" },
          { regexp: /.*GRANOLA.*/, normalized_value: "GRANOLA" },
          { regexp: /.*MUESLI.*/, normalized_value: "MUESLIS" },
          { regexp: /.*GINSENG.*/, normalized_value: "GINSENG" },
          { regexp: /.*PASIFLORA.*/, normalized_value: "PASIFLORA" },
          { regexp: /.*LEVADURA.*/, normalized_value: "LEVADURA" },
          { regexp: /.*L(U|Ú)PULO.*/, normalized_value: "LÚPULO" },
          { regexp: /.*AVENA.*/, normalized_value: "AVENA" },
          { regexp: /.*TRIGO.*/, normalized_value: "TRIGO" },
          { regexp: /.*SEMOLA.*/, normalized_value: "SEMOLA" },
          { regexp: /.*SARRACENO.*/, normalized_value: "SARRACENO" },
          { regexp: /.*CENTENO.*/, normalized_value: "CENTENO" },
          { regexp: /.*QUINOA.*/, normalized_value: "QUINOA" },
          { regexp: /.*S(E|É)SAMO.*/, normalized_value: "SÉSAMO" },
          { regexp: /.*SOPA.*/, normalized_value: "SOPAS" },
          { regexp: /.*ANIS.*/, normalized_value: "ANIS" },
          { regexp: /.*MANZANILLA.*/, normalized_value: "MANZANILLA" },
          { regexp: /.*\sMACA\s.*/, normalized_value: "MACA" },
          { regexp: /.*MATCHA.*/, normalized_value: "MATCHA" },
          { regexp: /.*MERMELADA.*/, normalized_value: "MERMELADAS" },
          { regexp: /.*MIEL.*/, normalized_value: "MIELES" },
          { regexp: /.*ESPELTA.*/, normalized_value: "ESPELTA" },
          { regexp: /.*ESPAGUETI.*/, normalized_value: "ESPAGUETIS" },
          { regexp: /.*MACARRONES.*/, normalized_value: "MACARRONES" },
          { regexp: /.*(ESPIRALES|FUSILLI).*/, normalized_value: "ESPIRALES/FUSILLI" },
          { regexp: /.*(ESPIRULINA|SPIRULINA).*/, normalized_value: "ESPIRULINA" },
          { regexp: /.*EXTRACTO.*/, normalized_value: "EXTRACTOS" },
          { regexp: /.*COUS.*/, normalized_value: "COUS COUS" },
          { regexp: /.*CURCUMA.*/, normalized_value: "CURCUMA" },
          { regexp: /.*CURRY.*/, normalized_value: "CURRY" },
          { regexp: /.*ARROZ.*/, normalized_value: "ARROZ" },
          { regexp: /.*SEIT(A|Á)N.*/, normalized_value: "SEITÁN" },
          { regexp: /.*GARBANZO.*/, normalized_value: "GARBANZOS" },
          { regexp: /.*LENTEJ.*/, normalized_value: "LENTEJAS" },
          { regexp: /.*JUD(I|Í)A.*/, normalized_value: "JUDÍAS" },
          { regexp: /.*ALOE VERA.*/, normalized_value: "ALOE VERA" },
          { regexp: /.*JENGIBRE.*/, normalized_value: "JENGIBRE" },
          { regexp: /.*HELADO.*/, normalized_value: "HELADOS" },
          { regexp: /.*BACON.*/, normalized_value: "BACON" },
          { regexp: /.*COSTILLA.*/, normalized_value: "COSTILLAS" },
          { regexp: /.*ENTRECOT.*/, normalized_value: "ENTRECOTS" },
          { regexp: /.*KEBAP.*/, normalized_value: "KEBAP" },
          { regexp: /.*(BURGER|HAMBURGUESA).*/, normalized_value: "HAMBURGUESAS" },
          { regexp: /.*(ESCALOPE|MILANESA|FILETE|BISTEC).*/, normalized_value: "FILETE" },
          { regexp: /.*PICADA.*/, normalized_value: "PICADA" },
          { regexp: /.*(BOLOGNESA|BOLOÑESA).*/, normalized_value: "BOLOÑESA" },
          { regexp: /.*(PERRITO|HOTDOG).*/, normalized_value: "HOTDOG" },
          { regexp: /.*CHORIZO.*/, normalized_value: "CHORIZO" },
          { regexp: /.*MORCILLA.*/, normalized_value: "MORCILLA" },
          { regexp: /.*MORTADELA.*/, normalized_value: "MORTADELA" },
          { regexp: /.*POLLO.*/, normalized_value: "POLLO" },
          { regexp: /.*PAVO.*/, normalized_value: "PAVO" },
          { regexp: /.*PIZZA.*/, normalized_value: "PIZZA" },
          { regexp: /.*TOFU.*/, normalized_value: "TOFU" },
          { regexp: /.*ALB(O|Ó)NDIGAS.*/, normalized_value: "ALBÓNDIGAS" },
          { regexp: /.*NUGGET.*/, normalized_value: "NUGGETS" },
          { regexp: /.*(SALCHICHA|FRANKFURT).*/, normalized_value: "SALCHICHAS" },
          { regexp: /.*CALAMAR.*/, normalized_value: "CALAMARES" },
          { regexp: /.*PULPO.*/, normalized_value: "PULPO" },
          { regexp: /.*GAMBA.*/, normalized_value: "GAMBAS" },
          { regexp: /.*AT(U|Ú)N.*/, normalized_value: "ATÚN" },
          { regexp: /.*SALM(O|Ó).*/, normalized_value: "SALMÓN" },
          { regexp: /.*EMPANA.*/, normalized_value: "EMPANADILLAS" },
          { regexp: /.*ARROZ.*/, normalized_value: "ARROZ" },
          { regexp: /.*GALLETA.*/, normalized_value: "GALLETAS" },
          { regexp: /.*MAGDALENA.*/, normalized_value: "MAGDALENAS" },
          { regexp: /.*SEMILLA.*/, normalized_value: "SEMILLAS" },
          { regexp: /.*(SNACK|CHIP(S)?).*/, normalized_value: "SNACKS" },
          { regexp: /.*(CAPS|C(A|Á)PSULA(S)?).*/, normalized_value: "CÁPSULAS" },
          { regexp: /.*CHAMP(U|Ú).*/, normalized_value: "CHAMPÚ" },
          { regexp: /.*DESODORANTE.*/, normalized_value: "DESODORANTES" },
          { regexp: /.*DETERGENTE.*/, normalized_value: "DETERGENTES" },
          { regexp: /.*LIMPIADOR.*/, normalized_value: "LIMPIADOR" },
          { regexp: /.*LAVAVAJILLAS.*/, normalized_value: "LAVAVAJILLAS" },
          { regexp: /.*JAB(Ó|O)N.*/, normalized_value: "JABÓN" },
          { regexp: /.*DUCHA.*/, normalized_value: "DUCHA" },
          { regexp: /.*FACIAL.*/, normalized_value: "FACIAL" },
          { regexp: /.*LECHE CORPORAL.*/, normalized_value: "LECHE CORPORAL" },
          { regexp: /.*CREMA SOLAR.*/, normalized_value: "PROTECTORES SOLARES" },
          { regexp: /.*(ANTIARRUGAS|REGENERATIVA(S)?).*/, normalized_value: "REGENERATIVA" },
          { regexp: /.*PELO.*/, normalized_value: "PELO" },
          { regexp: /.*MANOS.*/, normalized_value: "MANOS" },
          { regexp: /.*HIDRATANTE.*/, normalized_value: "HIDRATANTE" },
          { regexp: /.*CREMA.*/, normalized_value: "CREMAS" },
          { regexp: /.*BARRITA.*PROTEIN.*/, normalized_value: "BARRITAS PROTEICAS" },
          { regexp: /.*BARRITA.*ENERG(E|É)TICA.*/, normalized_value: "BARRITAS ENERGÉTICAS" },
          { regexp: /.*BARRITAS.*/, normalized_value: "BARRITAS" },
          { regexp: /.*BARQUILLO.*/, normalized_value: "BARQUILLOS" },
          { regexp: /.*BALSAMO.*/, normalized_value: "BALSAMOS" },
          { regexp: /.*HARINA.*PROTEIN.*/, normalized_value: "HARINAS PROTEICAS" },
          { regexp: /.*BATIDO.*/, normalized_value: "BATIDOS" },
          { regexp: /.*CALDO.*/, normalized_value: "CALDOS" },
          { regexp: /.*(PROTEINA HIDROLIZADA|PROTEINA|CASEIN PROTEIN).*/,
            normalized_value: "PROTEINAS" },
          { regexp: /.*(REFRIG|CONG|CONGELADO).*/, normalized_value: "CONGELADOS" },
          { regexp: /.*YOGUR.*/, normalized_value: "YOGURES" },
          { regexp: /.*BIOGURT.*/, normalized_value: "YOGURES" },
          { regexp: /.*POTITO.*/, normalized_value: "POTITOS" },
          { regexp: /.*HARINA.*/, normalized_value: "HARINAS" },
          { regexp: /.*CAPSULAS.*/, normalized_value: "CAPSULAS" },
          { regexp: /.*TORTITAS.*/, normalized_value: "TORTITAS" },
          { regexp: /.*SEMILLAS.*/, normalized_value: "SEMILLAS" },
          { regexp: /.*VITAMINA.*/, normalized_value: "VITAMINAS" },
          { regexp: /.*HOJA(S)?.*/, normalized_value: "HOJAS" },
          { regexp: /.*ACEITE CORPORAL.*/, normalized_value: "ACEITES CORPORALES" },
          { regexp: /.*ACEITE.*/, normalized_value: "ACEITES" },
          { regexp: /.*ROSA MOSQUETA.*/, normalized_value: "ROSA MOSQUETA" },
          { regexp: /.*PARA GATOS*./, tag: "GATOS" },
          { regexp: /.*PARA PERROS*./, tag: "PERROS" },
          { regexp: /.*COMEDERO.*/, normalized_value: "COMEDEROS" },
          { regexp: /^PLATO .*/, normalized_value: "COMEDEROS" },
          { regexp: /.*FUNDA.*/, normalized_value: "FUNDAS" },
          { regexp: /.*GAFA.*/, normalized_value: "GAFAS" },
          { regexp: /.*CORREA.*/, normalized_value: "CORREA" },
          { regexp: /.*ALIMENTACIÓN*./, tag: "" },
          { regexp: /.*VARIOS*./, tag: "" },
          { regexp: /.*OTROS*./, tag: "" }
        ].freeze

        private_constant :CATEGORIES
        private_constant :TITLE_RULES
        private_constant :CATEGORIES_RULES
        private_constant :TAGS_RULES
      end
    end
  end
end
