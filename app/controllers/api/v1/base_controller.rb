class Api::V1::BaseController < ApplicationController

  private

  def render_data data, message
		render json: { success: true, message: message, data: data }, status: 200
	end

	def error_data message
		render json: { success: false, message: message, data: {} }, status: 404
	end

	def error_valid_data message
		render json: { success: false, message: message, data: {} }, status: 400
	end

	protected
	def login_required
		token = params[:access_token]
    token ||= request.headers["Access-Token"]
    decode_token = JsonWebToken.decode(token)

    error_valid_data(decode_token[:error]) and return if decode_token[:error].present?
    error_valid_data(decode_token[:error]) and return if decode_token.blank?

    @current_user = decode_token["user_id"].present? ? decode_token["user_id"] : nil
  end
end
