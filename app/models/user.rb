class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :messages  
  has_many :answers
  has_many :homeworks
  has_many :homework_users
  has_many :participated_homeworks, through: :homework_users, source: :homework
  has_many :user_attendances
  has_many :attendances, through: :user_attendances
  
  has_many :requests

  def join!(homework)
    participated_homeworks << homework
  end

  def quit!(homework)
    participated_homeworks.delete(homework)
  end

  def is_member_of?(homework)
    return participated_homeworks.include?(homework)
  end
end
