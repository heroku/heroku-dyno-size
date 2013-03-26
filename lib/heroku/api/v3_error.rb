# Enhance error handler to support v3 errors

module Heroku
  module Command
    def self.parse_error_json(body)
      json = json_decode(body.to_s) rescue false
      case json
      when Array
        json.first.join(' ') # message like [['base', 'message']]
      when Hash
        # v2 errors are like { error: ... }
        # v3 errors are like { id: ... message: ...}
        json['error'] || json['message']
      else
        nil
      end
    end
  end
end
