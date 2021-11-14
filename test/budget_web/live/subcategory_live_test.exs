defmodule BudgetWeb.SubcategoryLiveTest do
  use BudgetWeb.ConnCase

  import Phoenix.LiveViewTest
  import Budget.Factory

  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_subcategory(_) do
    %{subcategory: insert(:subcategory)}
  end

  describe "Index" do
    setup [:create_subcategory]

    test "lists all subcategories", %{conn: conn, subcategory: subcategory} do
      {:ok, _index_live, html} = live(conn, Routes.subcategory_index_path(conn, :index))

      assert html =~ "Listing Subcategories"
      assert html =~ subcategory.name
    end

    test "saves new subcategory", %{conn: conn, subcategory: %{category_id: category_id}} do
      {:ok, index_live, _html} = live(conn, Routes.subcategory_index_path(conn, :index))
      attrs = params_for(:subcategory, category_id: category_id)

      assert index_live |> element("a", "New Subcategory") |> render_click() =~
               "New Subcategory"

      assert_patch(index_live, Routes.subcategory_index_path(conn, :new))

      assert index_live
             |> form("#subcategory-form", subcategory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#subcategory-form", subcategory: attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.subcategory_index_path(conn, :index))

      assert html =~ "Subcategory created successfully"
      assert html =~ attrs[:name]
    end

    test "updates subcategory in listing", %{conn: conn, subcategory: subcategory} do
      {:ok, index_live, _html} = live(conn, Routes.subcategory_index_path(conn, :index))

      assert index_live
             |> element("#subcategory-#{subcategory.id} a", subcategory.name)
             |> render_click() =~
               "Edit Subcategory"

      assert_patch(index_live, Routes.subcategory_index_path(conn, :edit, subcategory))

      assert index_live
             |> form("#subcategory-form", subcategory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#subcategory-form", subcategory: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.subcategory_index_path(conn, :index))

      assert html =~ "Subcategory updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes subcategory in listing", %{conn: conn, subcategory: subcategory} do
      {:ok, index_live, _html} = live(conn, Routes.subcategory_index_path(conn, :index))

      assert index_live |> element("#subcategory-#{subcategory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#subcategory-#{subcategory.id}")
    end
  end
end
