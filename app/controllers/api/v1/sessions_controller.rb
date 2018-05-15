class Api::V1::SessionsController < Api::V1::BaseController
	before_action :check_null_password, :only => :create

	# POST /v1/login
	def create
		if @user && @user.valid_password?(params[:password])
			auth_token = JsonWebToken.encode({user_id: @user.id})
			render_data( { auth_token: auth_token, users: @user.as_api_response(:user) }, 'Login success..!!!' )
		else
			error_data( "Login errors...!!!" )
		end
	end

	# POST /v1/signup
	def signup
		user = User.new(user_params)

		if user.save!
			#user.refreshed_token
			auth_token = JsonWebToken.encode({user_id: user.id})
			render_data( { auth_token: auth_token, users: user.as_api_response(:user) }, 'Signup success..!!!!' )
		end
	rescue ActiveModel::StrictValidationFailed => e
		error_valid_data(e)
	rescue ActiveRecord::RecordNotUnique => e
		error_valid_data(e)
	rescue StandardError => e
		err = user.errors.full_messages.try(:first).present? ? user.errors.full_messages.try(:first) : e
		error_valid_data(err)
	end


	private
	def user_params
		params.permit(:email, :password, :password_confirmation)
	end

	def check_null_password
		@user = User.find_by(email: params[:email].downcase)

		if @user.present?
			# error_valid_data(I18n.t('user.wrong_signin_way'))	if @user.password_digest.nil?
		end
	end

end
