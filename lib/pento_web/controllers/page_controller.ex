defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  def home(conn, _params) do
    # redirect to /guess if current_user is logged in
    if conn.assigns[:current_user] do
      redirect(conn, to: ~p"/guess")
    else
      render(conn, :home)
    end
  end
end
