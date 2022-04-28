defmodule ScmpWeb.PageController do
  use ScmpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
