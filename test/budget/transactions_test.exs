defmodule Budget.TransactionsTest do
  use Budget.DataCase

  import Budget.Factory

  alias Budget.Transactions

  describe "categories" do
    alias Budget.Transactions.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Transactions.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Transactions.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Transactions.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Transactions.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_category(category, @invalid_attrs)
      assert category == Transactions.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Transactions.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Transactions.change_category(category)
    end
  end

  describe "subcategories" do
    alias Budget.Transactions.Subcategory

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def subcategory_fixture(attrs \\ %{}) do
      {:ok, subcategory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_subcategory()

      subcategory
    end

    test "list_subcategories/0 returns all subcategories" do
      subcategory = insert(:subcategory, @valid_attrs)
      assert Transactions.list_subcategories() == [subcategory]
    end

    test "get_subcategory!/1 returns the subcategory with given id" do
      subcategory = insert(:subcategory, @valid_attrs)
      assert Transactions.get_subcategory!(subcategory.id) == subcategory
    end

    test "create_subcategory/1 with valid data creates a subcategory" do
      assert {:ok, %Subcategory{} = subcategory} = Transactions.create_subcategory(@valid_attrs)
      assert subcategory.name == "some name"
    end

    test "create_subcategory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_subcategory(@invalid_attrs)
    end

    test "update_subcategory/2 with valid data updates the subcategory" do
      subcategory = insert(:subcategory, @valid_attrs)

      assert {:ok, %Subcategory{} = subcategory} =
               Transactions.update_subcategory(subcategory, @update_attrs)

      assert subcategory.name == "some updated name"
    end

    test "update_subcategory/2 with invalid data returns error changeset" do
      subcategory = insert(:subcategory, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_subcategory(subcategory, @invalid_attrs)

      assert subcategory == Transactions.get_subcategory!(subcategory.id)
    end

    test "delete_subcategory/1 deletes the subcategory" do
      subcategory = insert(:subcategory, @valid_attrs)
      assert {:ok, %Subcategory{}} = Transactions.delete_subcategory(subcategory)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_subcategory!(subcategory.id) end
    end

    test "change_subcategory/1 returns a subcategory changeset" do
      subcategory = insert(:subcategory, @valid_attrs)
      assert %Ecto.Changeset{} = Transactions.change_subcategory(subcategory)
    end
  end
end
