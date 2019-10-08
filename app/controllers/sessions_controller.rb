class SessionsController < ApplicationController
  def create
    session[:auth_hash] = request.env['omniauth.auth']

    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
