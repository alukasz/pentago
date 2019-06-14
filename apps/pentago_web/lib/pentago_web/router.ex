defmodule Pentago.Web.Router do
  use Pentago.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pentago.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/game", GameController, :index
    get "/live", GameController, :live
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pentago.Web do
  #   pipe_through :api
  # end
end
