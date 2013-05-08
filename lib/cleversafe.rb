require 'cleversafe/errors'
require 'cleversafe/vault'
require 'cleversafe/object'
require 'cleversafe/connection'

require 'rest-client'

# Monkeypatch RestClient to prevent it from closing IO objects after they're
# uploaded, which it really shouldn't do.
class RestClient::Payload::Streamed
  def close
  end
end
