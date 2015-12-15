class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :organizations, through: :memberships

  validates_presence_of :first_name, :last_name

  # TODO Replace using Naught
  def self.null
    @null ||= new(email: "<Null User>")
  end

  def avatar
    user = %w(mark lena lindsay molly eve).sample
    "http://semantic-ui.com/images/avatar2/small/#{user}.png"
  end

end
