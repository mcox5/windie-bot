FactoryBot.define do
  factory :spot do
    name { "MyString" }
    windguru_code { 1 }
    report { "" }
    report_last_update { "2023-12-03" }
  end
end
