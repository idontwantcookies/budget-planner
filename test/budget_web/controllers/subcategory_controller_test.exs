defmodule BudgetWeb.SubcategoryControllerTest do
  use BudgetWeb.ConnCase

  import Budget.Factory

  describe "index" do
    test "lists all subcategories", %{conn: conn} do
      conn = get(conn, Routes.subcategory_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Subcategories"
    end
  end

  describe "new subcategory" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.subcategory_path(conn, :new))
      assert html_response(conn, 200) =~ "New Subcategory"
    end
  end

  describe "create subcategory" do
    test "redirects to show when data is valid", %{conn: conn} do
      attrs = params_with_assocs(:subcategory)

      conn = post(conn, Routes.subcategory_path(conn, :create), subcategory: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.subcategory_path(conn, :show, id)

      conn = get(conn, Routes.subcategory_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Subcategory"
    end

    test "renders errors when name is nil", %{conn: conn} do
      conn = post(conn, Routes.subcategory_path(conn, :create), subcategory: %{name: nil})
      assert html_response(conn, 200) =~ "New Subcategory"
    end
  end

  describe "edit subcategory" do
    setup [:create_subcategory]

    test "renders form for editing chosen subcategory", %{conn: conn, subcategory: subcategory} do
      conn = get(conn, Routes.subcategory_path(conn, :edit, subcategory))
      assert html_response(conn, 200) =~ "Edit Subcategory"
    end
  end

  describe "update subcategory" do
    setup [:create_subcategory]

    test "redirects when data is valid", %{conn: conn, subcategory: subcategory} do
      new_name = "some other name"

      conn =
        put(conn, Routes.subcategory_path(conn, :update, subcategory),
          subcategory: %{name: new_name}
        )

      assert redirected_to(conn) == Routes.subcategory_path(conn, :show, subcategory)

      conn = get(conn, Routes.subcategory_path(conn, :show, subcategory))
      assert html_response(conn, 200) =~ new_name
    end

    test "renders errors when name is nil", %{conn: conn, subcategory: subcategory} do
      conn =
        put(conn, Routes.subcategory_path(conn, :update, subcategory), subcategory: %{name: nil})

      assert html_response(conn, 200) =~ "Edit Subcategory"
    end
  end

  describe "delete subcategory" do
    setup [:create_subcategory]

    test "deletes chosen subcategory", %{conn: conn, subcategory: subcategory} do
      conn = delete(conn, Routes.subcategory_path(conn, :delete, subcategory))
      assert redirected_to(conn) == Routes.subcategory_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.subcategory_path(conn, :show, subcategory))
      end
    end
  end

  defp create_subcategory(_) do
    %{subcategory: insert(:subcategory)}
  end
end
