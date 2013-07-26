class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, :timeoutable and :omniauthable, :recoverable,
  # :validatable
  devise :database_authenticatable, :rememberable,
         :trackable

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { :value => username.downcase }]).first
    else
      where(conditions).first
    end
  end
end
