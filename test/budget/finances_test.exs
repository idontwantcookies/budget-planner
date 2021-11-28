defmodule Budget.FinancesTest do
  use Budget.DataCase
  import Budget.Factory
  alias Budget.Finances
  alias Finances.Category
  alias Finances.Subcategory
  alias Finances.Transaction
  alias Ecto.Changeset

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
      assert category.type == attrs[:type]
    end

    test "with invalid data returns error changeset" do
      attrs = params_with_assocs(:category) |> Map.put(:name, nil)
      assert {:error, %Ecto.Changeset{} = changeset} = Finances.create_category(attrs)
      assert "can't be blank" in errors_on(changeset).name
    end
  end

  describe "update_category/2" do
    test "with valid data updates the category" do
      category = insert(:category, type: :expense)

      assert {:ok, %Category{} = category} =
               Finances.update_category(category, %{name: "some updated name", type: :income})

      assert category.name == "some updated name"
      assert category.type == :income
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
    test "returns all subcategories" do
      subcategory = insert(:subcategory)
      assert Finances.list_subcategories([:category]) == [subcategory]
    end
  end

  describe "get_subcategory!/1" do
    test "returns the subcategory with given id" do
      subcategory = insert(:subcategory)
      assert Finances.get_subcategory!(subcategory.id, [:category]) == subcategory
    end
  end

  describe "create_subcategory/1" do
    test "with valid data creates a subcategory" do
      attrs = params_with_assocs(:subcategory)
      assert {:ok, %Subcategory{} = subcategory} = Finances.create_subcategory(attrs)
      assert subcategory.name == attrs[:name]
    end

    test "with invalid data returns error changeset" do
      attrs = params_with_assocs(:subcategory, %{name: nil})
      assert {:error, %Ecto.Changeset{}} = Finances.create_subcategory(attrs)
    end

    test "does not accept subcategory with same name and same category_id" do
      category = insert(:category)
      subcategory = insert(:subcategory, category: category)
      attrs = %{name: subcategory.name, category_id: category.id}
      assert {:error, %Changeset{} = changeset} = Finances.create_subcategory(attrs)
      errors = errors_on(changeset)

      assert "has already been taken" in errors[:name]
    end
  end

  describe "update_subcategory/2" do
    test "with valid data updates the subcategory" do
      subcategory = insert(:subcategory)

      assert {:ok, %Subcategory{} = subcategory} =
               Finances.update_subcategory(subcategory, %{name: "some updated name"})

      assert subcategory.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      subcategory = insert(:subcategory)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Finances.update_subcategory(subcategory, %{name: nil})

      assert errors_on(changeset) == %{name: ["can't be blank"]}
      assert subcategory == Finances.get_subcategory!(subcategory.id, [:category])
    end
  end

  describe "delete_subcategory/1" do
    test "deletes the subcategory" do
      subcategory = insert(:subcategory)
      assert {:ok, %Subcategory{}} = Finances.delete_subcategory(subcategory)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_subcategory!(subcategory.id) end
    end
  end

  describe "change_subcategory/1" do
    test "returns a subcategory changeset" do
      subcategory = insert(:subcategory)
      assert %Ecto.Changeset{valid?: true} = Finances.change_subcategory(subcategory)
    end
  end

  describe "list_transactions/0" do
    test "returns all transactions" do
      transaction = insert(:transaction)
      assert Finances.list_transactions(subcategory: :category) == [transaction]
    end

    test "returns transactions between certain periods" do
      today = Date.utc_today()
      a_week_ago = Date.add(today, -7)
      yesterday = Date.add(today, -1)

      transactions_to_fetch = insert_list(3, :transaction)
      _transactions_to_ignore = insert_list(2, :transaction, due_by: a_week_ago)

      assert ^transactions_to_fetch =
               Finances.list_transactions(yesterday, today, subcategory: :category)
    end
  end

  describe "get_transaction!/1" do
    test "returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Finances.get_transaction!(transaction.id, subcategory: :category) == transaction
    end
  end

  describe "create_transaction/1" do
    test "creates a transaction with valid data" do
      attrs = params_with_assocs(:transaction)
      assert {:ok, %Transaction{} = transaction} = Finances.create_transaction(attrs)
      assert transaction.description == attrs[:description]
      assert transaction.due_by == attrs[:due_by]
      assert transaction.status == attrs[:status]
      assert transaction.value == attrs[:value]
    end

    test "returns error changeset with invalid data" do
      attrs = %{}
      assert {:error, %Ecto.Changeset{}} = Finances.create_transaction(attrs)
    end
  end

  describe "update_transaction/2" do
    test "updates the transaction with valid data" do
      transaction = insert(:transaction)

      attrs = %{
        description: "some updated description",
        due_by: ~D[2011-05-18],
        status: :completed,
        value: "456.7"
      }

      assert {:ok, %Transaction{} = transaction} = Finances.update_transaction(transaction, attrs)

      assert transaction.description == "some updated description"
      assert transaction.due_by == ~D[2011-05-18]
      assert transaction.status == :completed
      assert transaction.value == Decimal.new("456.7")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = insert(:transaction)

      assert {:error, %Ecto.Changeset{}} =
               Finances.update_transaction(transaction, %{due_by: nil})

      assert transaction == Finances.get_transaction!(transaction.id, subcategory: :category)
    end
  end

  describe "delete_transaction/1" do
    test "deletes the transaction" do
      transaction = insert(:transaction)
      assert {:ok, %Transaction{}} = Finances.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_transaction!(transaction.id) end
    end
  end

  describe "change_transaction/1" do
    test "change_transaction/1 returns a transaction changeset" do
      transaction = insert(:transaction)
      assert %Ecto.Changeset{} = Finances.change_transaction(transaction)
    end
  end
end
