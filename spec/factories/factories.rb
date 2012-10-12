require 'factory_girl'

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "category_#{n}" }
  end
end