# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    callback_for(:google)
  end

  def line
    callback_for(:line)
  end

  def spotify
    callback_for(:spotify)
  end

  def callback_for(provider)
    @omniauth = request.env['omniauth.auth']
    info = User.find_oauth(@omniauth)
    @user = info[:user]
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      session[:provider] = @user[:provider]
      session[:uid] = @user[:uid]
      render template: "devise/registrations/new"
    end
  end

  def failure
    redirect_to login_url and return
  end
end
