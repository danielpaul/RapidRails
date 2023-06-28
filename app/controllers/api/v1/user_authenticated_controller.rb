class Api::V1::UserAuthenticatedController < Api::V1::BaseController
  before_action :set_user!, except: :extend_token
  before_action :set_user_from_token!, only: %i[extend_token user update_user]
  before_action :set_paper_trail_whodunnit
  before_action :set_sentry_user, if: -> { ENABLE_SENTRY && current_user }
end
