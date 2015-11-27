class Flag < ActiveRecord::Base
  belongs_to :flagger, class_name: :User
  belongs_to :development
end
