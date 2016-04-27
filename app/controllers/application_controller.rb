class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def facebook_logout
    #session[:fb_token] = omniauth["credentials"]["token"] if omniauth['provider'] == 'facebook'

    omniauth = session[:omniauth]
    

    access_token = omniauth["credentials"]["token"]
    split_token = omniauth["credentials"]["token"].split("|")
    fb_api_key = split_token[0]
    fb_session_key = split_token[1]
    redirect_to "http://www.facebook.com/logout.php?next=#{omniauth_destroy_user_session_url}&access_token=#{access_token}&confirm=1"; 
  
    #omniauth = request.env["omniauth.auth"]
    #omniauth =  Devise.omniauth_configs[:facebook].args[0]
    #puts "omniauth: #{omniauth}"
    #access_token = omniauth["credentials"]["token"]
    #puts "at: #{access_token}"
    #redirect_to "http://www.facebook.com/logout.php?access_token=#{access_token}&confirm=1&next=#{destroy_user_session_url}";
  end

 #  def after_sign_out_path_for(User)

    
	#   "https://www.facebook.com/logout.php?next=#{new_user_session_url}&access_token=#{USER_ACCESS_TOKEN}"
	# end

end
