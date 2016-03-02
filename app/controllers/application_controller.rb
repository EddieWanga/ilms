class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

protected
  
  def upload_to_google_drive(attachment)
    if attachment.current_path != nil
      cert_path = Gem.loaded_specs['google-api-client'].full_gem_path+'/lib/cacerts.pem'
      ENV['SSL_CERT_FILE'] = cert_path
      
      folder_name = "sprout"
      attachment_path = attachment.current_path
      file_name = attachment_path.split("/")[-4..-1].join("/")
      
      session = GoogleDrive.saved_session("config.json")
      folder = session.collection_by_title(folder_name)
      file = session.upload_from_file(attachment_path, file_name, convert: false)

      folder.add(file)
      session.root_collection.remove(file)
      @homework.download_link = "https://drive.google.com/file/d/" + file.id + "/view?usp=sharing"
      @homework.save
      attachment.remove!
	else
      return 0	
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end

  def is_valid_user?
    if current_user.role == 2
      redirect_to welcome_path
    end
  end
end
