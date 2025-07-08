class Api::V1::BaseController < ActionController::Base
  include Pundit::Authorization

  before_action :set_api_key!, :authenticate_api_key!

  rescue_from(StandardError) { |e| handle_api_error(e) }

  private

  def authenticate_api_key!
    authenticate! || render_unauthorized!
  end

  def authenticate!
    @api_key.present?
  end

  def set_api_key!
    api_key_header = request.headers["X-Api-Key"]
    @api_key = ApiKey.active.find_by(api_key: api_key_header)
  end

  def set_user_token!
    # Render a new JWT token
    token = JwtTokenService.generate!({id: current_user.id})
    render_ok!({token:})
  end

  def set_user_from_token!
    # Set user from JWT token
    token = request.headers["Authorization"].split(" ").last
    payload = JwtTokenService.decode!(token)[0]
    @user = User.find(payload["id"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    # If invalid bearer token or user not found
    render_unauthorized!
  end

  def render_unauthorized!(message: "Looks like you don't have the permission to do this.")
    render json: format_error("unauthorized", message), status: :unauthorized and return
  end

  def render_unprocessable_entity!(message: t("errors.general"))
    render json: format_error("unprocessable_entity", message), status: :unprocessable_entity and return
  end

  def render_ok!(content)
    render json: content, status: :ok and return
  end

  def render_internal_server_error!(message: t("errors.general"))
    render json: format_error("internal_server_error", message), status: :internal_server_error and return
  end

  def render_forbidden!(message: t("errors.general"))
    render json: format_error("forbidden", message), status: :forbidden and return
  end

  def paginated_collection(collection, blueprinter, view: :default)
    paginated_records = collection.page(params[:page])
    {
      type: "list",
      pages: {
        type: "pages",
        page: params[:page].to_i,
        per_page: paginated_records.limit_value,
        total_pages: paginated_records.total_pages
      },
      total_count: collection.count,
      data: blueprinter.render_as_hash(paginated_records, current_user:, view:)
    }
  end

  def current_user
    @user
  end

  def handle_api_error(error)
    case error
    when JWT::DecodeError, Pundit::NotAuthorizedError
      # If invalid bearer token or user is not authorized to perform an action
      render_unauthorized!
    when Pundit::NotDefinedError
      render_forbidden!
    else
      render_internal_server_error!
    end
  end

  # Common error format for all status codes
  def format_error(error_code, message)
    {
      type: "error.list",
      errors: [
        {
          code: error_code,
          message: message
        }
      ]
    }
  end
end
