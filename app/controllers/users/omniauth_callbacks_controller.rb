class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
	    # You need to implement the method below in your model (e.g. app/models/user.rb)
	    @user = User.from_omniauth(request.env["omniauth.auth"])
	    session[:omniauth] = request.env["omniauth.auth"]
	    puts session[:omniauth][:credentials][:token]
	    if @user.persisted?
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
	    else
	      session["devise.facebook_data"] = request.env["omniauth.auth"]
	      redirect_to new_user_registration_url
	    end
	  end

#https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=427985975625-2e41196cum6jk1423gffba7t0ao10gqi.apps.googleusercontent.com&redirect_uri=http://localhost:3000/&scope=https://www.googleapis.com/auth/analytics.readonly&access_type=offline
#https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=427985975625-2e41196cum6jk1423gffba7t0ao10gqi.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fauth%2Fgoogle_oauth2%2Fcallback&response_type=code&scope=email+profile&state=67f6aae9474bc63fc6ebbe3f8af2f57204218f8fa6f21bc7
	  def google_oauth2
     
	    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
	 
	    if @user.persisted?
	    	puts "google_oauth2 in persisted?? "
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	    	puts "google_oauth2 in persisted? else ...  "
	      session["devise.google_data"] = request.env["omniauth.auth"]
	      redirect_to new_user_registration_url
	    end
	  end

	  
	  def failure
	  	puts "omniauth failure"
	    redirect_to root_path
	  end
end


