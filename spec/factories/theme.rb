FactoryGirl.define do
  factory :theme do
    sequence(:id)
    sequence(:description) { |n| "Tema #{n}"}
  end
end
