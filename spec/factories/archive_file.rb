FactoryBot.define do
  factory :archive_file do
    input { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.rar')) }
    state { :pending }

    trait :seeding do
      output { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'archives', 'example.zip')) }
      state { :seeding }
    end

    trait :completed do
      output { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'archives', 'example.zip')) }
      state { :completed }
    end

    trait :failed do
      output { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'archives', 'example.zip')) }
      state { :failed }
    end
  end
end
