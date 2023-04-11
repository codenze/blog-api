module CurrentUserConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def set_current_user
    if session && session[:user_id]
      begin
        @current_user = User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
  end
end
