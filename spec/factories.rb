FactoryGirl.define do
  factory :user do
    email {"user#{rand(10000000)}@email.com"}
    password 'password'
  end

  factory :program do
    title 'PROGRAM_TITLE'
    user_id 1
    after(:create) do |program|
      metric = create(:metric, program_id: program.id)
      program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-04"}.to_json]
    end

    trait :no_metric_data do
      after(:create) do |program|
        metric = create(:metric, :no_data, program_id: program.id)
        program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-04"}.to_json]
      end
    end

    trait :deleted_focus_metric do
      after(:create) do |program|
        metric = create(:metric, program_id: program.id + 1)
        program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-04"}.to_json]
      end
    end

    trait :multiple_focus_metrics do
      after(:create) do |program|
        second = create(:metric, :second, program_id: program.id)
        program.focus_metric = [{"focus_metric"=>second.id, "date"=>"2015-10-02"}.to_json, {"focus_metric"=>second.id - 1, "date"=>"2015-10-05"}.to_json]
      end
    end

    trait :focus_metrics_older_data do
      after(:create) do |program|
        metric = create(:metric, :older, program_id: program.id)
        program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-20"}.to_json]
      end
    end
  end

  factory :metric do
    title 'METRIC_TITLE'
    data ["{\"date\":\"2015-10-04\",\"value\":\"1\"}", "{\"date\":\"2015-10-05\",\"value\":\"2\"}"]
    association :program

    trait :no_data do
      data nil
    end

    trait :second do
      title 'SECOND_METRIC_TITLE'
      data ["{\"date\":\"2015-10-01\",\"value\":\"1\"}", "{\"date\":\"2015-10-02\",\"value\":\"2\"}", "{\"date\":\"2015-10-03\",\"value\":\"3\"}"]
    end

    trait :older do
      title 'OLDER_METRIC_TITLE'
      data {(1..20).each.inject([]) {|d, i| d << {date: "2015-10-#{i}", value: 1}.to_json}}
    end
  end
end
