class SessionsController < ApplicationController
  def create
    session[:auth_hash] = request.env['omniauth.auth']
    t=Token.first_or_create
    t.update(access_token: session['auth_hash']['credentials']['token'], refresh_token: session['auth_hash']['credentials']['refresh_token'])

    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
