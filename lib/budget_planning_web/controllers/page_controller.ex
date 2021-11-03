defmodule BudgetPlanningWeb.PageController do
  use BudgetPlanningWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
