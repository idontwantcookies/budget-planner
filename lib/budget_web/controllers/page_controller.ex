defmodule BudgetWeb.PageController do
  use BudgetWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.transaction_index_path(conn, :index))
  end
end
