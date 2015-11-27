class Organization < ActiveRecord::Base
  has_many :members,        class_name: :User
  has_many :administrators, class_name: :User
  belongs_to :creator,      class_name: :User

  def promote_to_admin(member)
    member.add_role(:administrator, self)
  end
end
