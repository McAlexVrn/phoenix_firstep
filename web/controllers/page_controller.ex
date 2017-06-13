defmodule Firstep.PageController do
  use Firstep.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def hello(conn, _params) do
  IO.puts(conn)
    render conn, "hello.html"
  end
end
