import Config

config :ex_ibge, req_options: [plug: {Req.Test, ExIbge.Api}]
