class WeeksController < ApplicationController
  def show
    @team = Team.find(params[:team_id])
    @week = @team.weeks.where(week_num: params[:id])
    
    respond_to do |format|
      format.json {render json: @week[0].raw_week_data.to_json}
    end
  end
end
