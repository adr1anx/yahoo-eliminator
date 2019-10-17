class HomeController < ApplicationController
  def index
    @league = League.first
    @teams = Team.all
  end
end
