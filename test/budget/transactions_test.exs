defmodule Budget.FinancesTest do
  use Budget.DataCase

  import Budget.Factory

  alias Budget.Finances

  alias Budget.Finances.{Category, Subcategory}

  describe "list_categories/0" do
    test "returns all categories" do
      category = insert(:category)
      assert Finances.list_categories() == [category]
    end
  end

  describe "get_category!/1" do
    test "returns the category with given id" do
      category = insert(:category)
      assert Finances.get_category!(category.id) == category
    end
  end

  describe "create_category/1" do
    test "with valid data creates a category" do
      attrs = params_with_assocs(:category)
      assert {:ok, %Category{} = category} = Finances.create_category(attrs)
      assert category.name == attrs[:name]
    end

    test "with invalid data returns error changeset" do
      attrs = params_with_assocs(:category) |> Map.put(:name, nil)
      assert {:error, %Ecto.Changeset{} = changeset} = Finances.create_category(attrs)
      assert "can't be blank" in errors_on(changeset).name
    end
  end

  describe "update_category/2" do
    test "with valid data updates the category" do
      category = insert(:category)

      assert {:ok, %Category{} = category} =
               Finances.update_category(category, %{name: "some updated name"})

      assert category.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      category = insert(:category)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Finances.update_category(category, %{name: nil})

      assert "can't be blank" in errors_on(changeset).name
      assert category == Finances.get_category!(category.id)
    end
  end

  describe "delete_category/1" do
    test "deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = Finances.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_category!(category.id) end
    end
  end

  describe "change_category/1" do
    test "returns a category changeset" do
      category = build(:category)
      assert %Ecto.Changeset{} = Finances.change_category(category)
    end
  end

  describe "list_subcategories/0" do
    test "list_subcategories/0 returns all subcategories" do
      subcategory = insert(:subcategory)
      assert Finances.list_subcategories([:category]) == [subcategory]
    end
  end

  describe "get_subcategory!/1" do
    test "get_subcategory!/1 returns the subcategory with given id" do
      subcategory = insert(:subcategory)
      assert Finances.get_subcategory!(subcategory.id, [:category]) == subcategory
    end
  end

  describe "create_subcategory/1" do
    test "create_subcategory/1 with valid data creates a subcategory" do
      attrs = params_with_assocs(:subcategory)
      assert {:ok, %Subcategory{} = subcategory} = Finances.create_subcategory(attrs)
      assert subcategory.name == attrs[:name]
    end

    test "create_subcategory/1 with invalid data returns error changeset" do
      attrs = params_with_assocs(:subcategory, %{name: nil})
      assert {:error, %Ecto.Changeset{}} = Finances.create_subcategory(attrs)
    end
  end

  describe "update_subcategory/2" do
    test "update_subcategory/2 with valid data updates the subcategory" do
      subcategory = insert(:subcategory)

      assert {:ok, %Subcategory{} = subcategory} =
               Finances.update_subcategory(subcategory, %{name: "some updated name"})

      assert subcategory.name == "some updated name"
    end

    test "update_subcategory/2 with invalid data returns error changeset" do
      subcategory = insert(:subcategory)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Finances.update_subcategory(subcategory, %{name: nil})

      assert errors_on(changeset) == %{name: ["can't be blank"]}
      assert subcategory == Finances.get_subcategory!(subcategory.id, [:category])
    end
  end

  describe "delete_subcategory/1" do
    test "delete_subcategory/1 deletes the subcategory" do
      subcategory = insert(:subcategory)
      assert {:ok, %Subcategory{}} = Finances.delete_subcategory(subcategory)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_subcategory!(subcategory.id) end
    end
  end

  describe "change_subcategory/1" do
    test "change_subcategory/1 returns a subcategory changeset" do
      subcategory = insert(:subcategory)
      assert %Ecto.Changeset{valid?: true} = Finances.change_subcategory(subcategory)
    end
  end
end
