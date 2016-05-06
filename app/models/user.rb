class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :identities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

   has_attached_file :profile_pic, styles: { medium: "300x300>", thumb: "100x100>" }

   validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\Z/
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

#   def self.from_omniauth(auth)
# 	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
# 	    user.email = auth.info.email
# 	    user.password = Devise.friendly_token[0,20]
# 	    user.name = auth.info.name   # assuming the user model has a name
# 	    user.profile_pic = auth.info.image # assuming the user model has an image
# 	  end
# 	end


# def self.find_for_google_oauth2(access_token)
#   data = access_token.info
#     user = User.where(:email => data["email"]).first

#     # Uncomment the section below if you want users to be created if they don't exist
#     unless user
#         user = User.create(name: data["name"],
#            email: data["email"],
#            password: Devise.friendly_token[0,20]
#         )
#     end
#     user
#    #  data = access_token.info
#    #  user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
#    #  puts "google user: #{user.status}"
#    #  if user
#    #    return user
#    #  else
#    #    registered_user = User.where(:email => access_token.info.email).first
#    #    if registered_user
#    #      return registered_user
#    #    else
#    #      user = User.create(name: data["name"],
#    #        provider:access_token.provider,
#    #        email: data["email"],
#    #        uid: access_token.uid ,
#    #        password: Devise.friendly_token[0,20],
#    #      )
#    #    end
#    # end
# end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup

      puts "email:: #{auth.info.email}"
      
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      puts "email_is_verified:: #{email_is_verified}"
      email = auth.info.email 
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email,
          #email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end


	# def self.new_with_session(params, session)
 #    super.tap do |user|
 #      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
 #        user.email = data["email"] if user.email.blank?
 #      end
 #    end
 #  end
end
