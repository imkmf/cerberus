defmodule Cerberus.Router do
  use Cerberus.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Cerberus do
    pipe_through :api
  end
end
