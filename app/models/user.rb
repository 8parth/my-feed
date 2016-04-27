class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

   has_attached_file :profile_pic, styles: { medium: "300x300>", thumb: "100x100>" }

   validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    user.profile_pic = auth.info.image # assuming the user model has an image
	  end
	end


def self.find_for_google_oauth2(access_token)
  data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(name: data["name"],
           email: data["email"],
           password: Devise.friendly_token[0,20]
        )
    end
    user
   #  data = access_token.info
   #  user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
   #  puts "google user: #{user.status}"
   #  if user
   #    return user
   #  else
   #    registered_user = User.where(:email => access_token.info.email).first
   #    if registered_user
   #      return registered_user
   #    else
   #      user = User.create(name: data["name"],
   #        provider:access_token.provider,
   #        email: data["email"],
   #        uid: access_token.uid ,
   #        password: Devise.friendly_token[0,20],
   #      )
   #    end
   # end
end

	# def self.new_with_session(params, session)
 #    super.tap do |user|
 #      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
 #        user.email = data["email"] if user.email.blank?
 #      end
 #    end
 #  end
end
