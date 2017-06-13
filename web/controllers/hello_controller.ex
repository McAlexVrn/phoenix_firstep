defmodule Firstep.HelloController do
  use Firstep.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def message(conn, params) do
  IO.puts(params["pidor"])
      render conn, "message.html", myparams: params
    end

end
