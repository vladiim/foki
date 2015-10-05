FactoryGirl.define do
  factory :program do
    title 'PROGRAM_TITLE'
    user_id 1
    after(:create) do |program|
      metric = create(:metric, program_id: program.id)
      program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-04"}]
    end

    trait :no_metric_data do
      after(:create) do |program|
        metric = create(:metric, :no_data, program_id: program.id)
        program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"2015-10-04"}]
      end
    end

    trait :focus_metric_different_dates do
      after(:create) do |program|
        metric = create(:metric, program_id: program.id)
        program.focus_metric = [{"focus_metric"=>metric.id, "date"=>"DIFFERENT"}]
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
  end
end
