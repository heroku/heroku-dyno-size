module Heroku
  class API
    # V3 API

    # GET /apps/:app/formation
    def get_formation(app)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/apps/#{app}/formation",
        :headers  => {
          "Accept" => "application/vnd.heroku+json; version=3"
        }
      )
    end

    # POST /apps/:app/ps
    def put_formation(app, process, options)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/apps/#{app}/formation/#{process}",
        :query    => options,
        :headers  => {
          "Accept" => "application/vnd.heroku+json; version=3"
        }
      )
    end
  end
end
