FactoryGirl.define do
  factory :proposition do
    sequence(:id)
    year 2013
    sequence(:number) { |n| 600+n }
    amendment "Essa proposição é sobre X"
    explanation "Um pouco mais de detalhes"
    proposition_types "PL"
    presentation_date "Tue, 13 Apr 2013"
    situation "MESA - Arquivada"
    sequence(:content_link) { |n| "http://www.camara.gov.br/proposicoesWeb/prop_mostrarintegra?codteor=#{n}"}
    sequence(:parliamentarian_id)
  end
end