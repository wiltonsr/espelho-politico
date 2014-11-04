FactoryGirl.define do
  factory :parliamentarian do
    sequence(:id)
    sequence(:registry) { |n| "#{n}#{n}#{n}"}
    condition "Titular"
    sequence(:name) { |n| "Parlamentar #{n}"}
    sequence(:url_photo) { |n| "http://www.camara.gov.br/internet/deputado/bandep/#{n}#{n}#{n}.jpg"}
    state "DF"
    party "PT"
    sequence(:phone) { |n| "3#{n}#{n+1}2-5#{n-1}#{n+3}9"}
    sequence(:email) { |n| "dep#{n}@camara.gov.br"}
    cabinet 400
  end
end