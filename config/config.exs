import Config

config :ex_ibge, req_options: []

import_config "#{config_env()}.exs"
