class TeamsController < ApplicationController
  def index
    # base_url = "https://fantasysports.yahooapis.com/fantasy/v2/team/390.l.277245.t.#{team}/stats;type=week;week=#{week}?format=json"
    base_url = "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl?format=json"
    # response = HTTParty.get(base_url, {
    #   headers: {"Authorization" => "Bearer #{session['auth_hash']['credentials']['token']}"}
    # })

    yid = "dj0yJmk9ZGdpRUlZYXJPR3E0JmQ9WVdrOVJXVjJXVkI2Tm5NbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PThj"
    ys = "6d7837d0e0bf38aad9a92fb903a56331d71c5042"
    auth = "Basic #{Base64.strict_encode64("#{yid}:#{ys}")}"

    response = HTTParty.get(base_url, {
      headers: {"Authorization" => auth}
    })
    logger.info response
  end

  def show
    @team = Team.find(params[:id])
    respond_to do |format|
      format.json { @team.to_json }
    end
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
          auth = "Basic #{Base64.strict_encode64("dj0yJmk9dldWSjdpR0x2aTRVJmQ9WVdrOWFHeEdZVEpwTjJFbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTY1:651cc57fa57dae2ed91a39949df36753ffbf85f8")}"
          response = HTTParty.post("https://api.login.yahoo.com/oauth2/get_token",
            {
              headers: {
                "Content-Type" => "application/x-www-form-urlencoded",
                "Authorization" => auth
              },
              body: {
                redirect_uri: "http://localhost:5000",
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
