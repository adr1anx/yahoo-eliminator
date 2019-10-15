class TeamsController < ApplicationController
  def index
  end

  def show
  end

  def update_data
    (1..12).each do |team|
      (1..16).each do |week|
        base_url = "https://fantasysports.yahooapis.com/fantasy/v2/team/390.l.277245.t.#{team}/stats;type=week;week=#{week}?format=json"
        response = HTTParty.get(base_url, {
          headers: {"Authorization" => "Bearer #{Token.first.access_token}"}
        })

        resp = JSON.parse(response.body)

        if resp.has_key?('error') # need to refresh token
          auth = "Basic #{Base64.strict_encode64("#{ENV['YAHOO_CLIENT_ID']}:#{ENV['YAHOO_CLIENT_SECRET']}")}"
          logger.info auth.to_yaml
          response = HTTParty.post("https://api.login.yahoo.com/oauth2/get_token",
            {
              headers: {
                "Content-Type" => "application/x-www-form-urlencoded",
                "Authorization" => auth
              },
              body: {
                redirect_uri: "http://idp-eliminator.com",
                refresh_token: Token.first.refresh_token,
                grant_type: 'refresh_token'
              }
            }
          )
          resp = JSON.parse(response.body)
          Token.first.update(access_token: resp['access_token'], refresh_token: resp['refresh_token'])
          response = HTTParty.get(base_url, {
            headers: {"Authorization" => "Bearer #{Token.first.access_token}"}
          })
          resp = JSON.parse(response.body)
          logger.info resp
        end
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
