defmodule Cerberus.Endpoint do
  use Phoenix.Endpoint, otp_app: :cerberus

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Absinthe.Plug,
    schema: Cerberus.Schema
end
