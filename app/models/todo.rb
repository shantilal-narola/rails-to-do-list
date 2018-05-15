class Todo < ApplicationRecord
  has_one :user

  acts_as_api

  api_accessible :todo_list do |t|
    t.add :id
    t.add :data
    t.add :due_date
    t.add :priority
    t.add :user_id
  end
end
