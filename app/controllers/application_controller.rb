class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :null_session

  helper_method :current_tenant

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from NoMethodError, with: :pundit_not_logged_in

  respond_to :json

  before_action :check_tenant_permissions

  around_action :scope_current_tenant

  def pundit_user
    Account.find_by_user_id current_user.id
  end

  private

  def permission_denied
    head :forbidden
  end

  def pundit_not_logged_in
    head :unauthorized
  end

  def record_not_found(error)
    render json: error.message, status: :bad_request
  end

  def current_tenant
    subdomain = request.subdomain.downcase
    Group.find_by_code subdomain unless subdomain.eql? 'www' || subdomin.nil?
  end

  def check_tenant_permissions
    unless current_tenant.nil?
      if current_user.nil?
        return
      else
        account = Account.find_by_user_id current_user
        unless current_tenant.accounts.include? account || account.super?
          redirect_to "http://#{request.domain}/#/"
        end
      end
    end
  end

  def scope_current_tenant
    Group.current_id = current_tenant.nil? ? nil : current_tenant.id
    yield
  ensure
    Group.current_id = nil
  end

end
