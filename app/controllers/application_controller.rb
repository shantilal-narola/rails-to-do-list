class ApplicationController < ActionController::API

	# Call this to make acts_as_api work
	include ActsAsApi::Rendering

	before_action :set_locale
  before_action :set_headers

  ##------------------------ Exception Handling --------------------------- ##

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { success: false, message: e, data: {} }, status: 404
  end

  rescue_from I18n::InvalidLocale, :with => :locale_not_valid

  rescue_from ActiveModel::StrictValidationFailed do |e|
    render json: { success: false, message: e, data: {} }, status: 404
  end

  # Handle required missing params error with custom method
  # rescue_from CustomErrors::MissingParams do |e| render_missing_params_error(names: e.names) end

  ##---------------------------------- end ---------------------------------##


  private
  def record_not_found
    render json: { success: false, message: I18n.t('record_not_found'), data: {} }, status: 404
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def locale_not_valid
  	render json: { success: false, message: "locale not valid only en or ar is allowed.", data: {} }, status: 404
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # This method will check required_params list to be included in params
  def check_required_params(params, required_params)
    missing_params = []
    required_params.each { |p| missing_params << p if params[p].blank? }
    raise CustomErrors::MissingParams.new(missing_params) if missing_params.any?
  end

end
