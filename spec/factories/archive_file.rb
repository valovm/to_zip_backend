FactoryBot.define do
  factory :archive_file do

    trait :completed do
      output { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'archives','extract', 'input', 'Кирилица.rar')) }
      state { :completed }
    end
  end
end
