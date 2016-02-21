module HomeworksHelper
  def is_admin?(user)
    if !current_user
      return false
    else 
      return user.role == 0
    end
  end
end
