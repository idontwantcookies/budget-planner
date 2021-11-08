defmodule Budget.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Budget.Repo

  alias Budget.Finances.{Category, Subcategory, Transaction}

  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id, preloads \\ []), do: Repo.get!(Category, id) |> Repo.preload(preloads)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def list_subcategories(preloads \\ []) do
    Subcategory
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def get_subcategory!(id, preloads \\ []) do
    Subcategory |> Repo.get!(id) |> Repo.preload(preloads)
  end

  def create_subcategory(attrs \\ %{}) do
    %Subcategory{}
    |> Subcategory.changeset(attrs)
    |> Repo.insert()
  end

  def update_subcategory(%Subcategory{} = subcategory, attrs) do
    subcategory
    |> Subcategory.changeset(attrs)
    |> Repo.update()
  end

  def delete_subcategory(%Subcategory{} = subcategory) do
    Repo.delete(subcategory)
  end

  def change_subcategory(%Subcategory{} = subcategory, attrs \\ %{}) do
    Subcategory.changeset(subcategory, attrs)
  end

  def list_transactions(preloads \\ []), do: Transaction |> Repo.all() |> Repo.preload(preloads)

  def get_transaction!(id, preloads \\ []),
    do: Transaction |> Repo.get!(id) |> Repo.preload(preloads)

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
