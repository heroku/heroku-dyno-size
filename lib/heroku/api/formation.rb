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

    # # POST /apps/:app/ps
    # def post_ps(app, command, options={})
    #   options = { 'command' => command }.merge(options)
    #   request(
    #     :expects  => 200,
    #     :method   => :post,
    #     :path     => "/apps/#{app}/ps",
    #     :query    => ps_options(options)
    #   )
    # end
  end
end
