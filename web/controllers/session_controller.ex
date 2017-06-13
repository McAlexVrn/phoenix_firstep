defmodule Firstep.SessionController do
  use Firstep.Web, :controller
  alias Firstep.User
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    render conn, "new.html"
  end
  def create(conn, %{"session" => %{"username" => username,
                                    "password" => password}}) do
    #  try to get user by unique email from DB
        user = Repo.get_by(User, username: username)
        # examine the result
        case Firstep.Auth.login_by_username_and_pass(conn, username, password) do
          {:ok, conn} ->
            conn
            |> put_flash(:info, "You’re now logged in!")
            |> redirect(to: page_path(conn, :index))
          {:error, _reason, conn} ->
            conn
            |> put_flash(:error, "Invalid email/password combination")
            |> render("new.html")
        end
  end

  def delete(conn, _) do
    conn
    |> Firstep.Auth.logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

end
