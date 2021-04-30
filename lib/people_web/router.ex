defmodule PeopleWeb.Router do
  use PeopleWeb, :router

  alias PeopleWeb.Salesloft.PeopleController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    scope "/services" do
      scope "/salesloft" do
        scope "/people" do
          get "/", PeopleController, :index
        end
      end
    end
  end
end
