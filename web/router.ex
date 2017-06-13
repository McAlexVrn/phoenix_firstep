defmodule Firstep.Router do
  use Firstep.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Firstep.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

   pipeline :login_required do
      #plug Firstep.CheckAdmin
    end

  pipeline :admin_required do
    plug Firstep.CheckAdmin
  end

  scope "/", Firstep do
    pipe_through [:browser, :with_session] # Use the default browser stack and sessions

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:message", HelloController, :message
    resources "/posts", PostController
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :destroy, :delete]
  end

  scope "/admin", Firstep do
    pipe_through [:browser, :with_session, :admin_required]
  end

  scope "/", Firstep do
    pipe_through [:browser, :with_session]
    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create,
                                                     :delete]
    resources "/users", UserController, only: [:new, :create]
    # registered user zone
    scope "/" do
      pipe_through [:login_required]
      resources "/users", UserController, only: [:show] do
        resources "/posts", PostController
      end
      # admin zone
      scope "/admin", Admin, as: :admin do
        pipe_through [:admin_required]
        resources "/users", UserController, only: [:index, :show] do
          resources "/posts", PostController, only: [:index, :show]
        end
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Firstep do
  #   pipe_through :api
  # end
end
