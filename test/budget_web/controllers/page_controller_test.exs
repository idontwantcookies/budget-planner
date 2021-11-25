defmodule BudgetWeb.PageControllerTest do
  use BudgetWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) =~ Routes.transaction_index_path(conn, :index)
  end
end
