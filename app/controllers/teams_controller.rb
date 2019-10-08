class TeamsController < ApplicationController
  def index
  end

  def update_data
    (1..12).each do |team|
      (1..16).each do |week|
        base_url = "https://fantasysports.yahooapis.com/fantasy/v2/team/390.l.277245.t.#{team}/stats;type=week;week=#{week}?format=json"
        response = HTTParty.get(base_url, {
          headers: {"Authorization" => "Bearer #{session['auth_hash']['credentials']['token']}"}
        })
        resp = JSON.parse(response.body)
        t = Team.where(team_id: team).first_or_create
        t.update(name: resp['fantasy_content']['team'][0][2]['name'], team_key: resp['fantasy_content']['team'][0][0]['team_key'])
        w = t.weeks.where(week_num: week).first_or_create
        w.update(points: resp['fantasy_content']['team'][1]['team_points']['total'], raw_week_data: resp)
      end
      #teams << {"name": resp['fantasy_content']['team'][0][2]['name'], "points": resp['fantasy_content']['team'][1]['team_points']['total']}
    end

    render json: {result: 'ok'}
  end
end
