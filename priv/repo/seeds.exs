defmodule Seeds do
  @moduledoc """
  Used to quickly get the application running with some commonly used categories.
  """

  alias Budget.Finances.Category
  alias Budget.Repo

  @expenses ~w"children debt education entertainment everyday gifts health/medical home insurance investments pets technology transportation travel utilities"
  @incomes ~w"savings paycheck bonus interest refunds"

  def seed_categories! do
    Enum.each(@expenses, &seed_category(&1, :expense))
    Enum.each(@incomes, &seed_category(&1, :income))

    :ok
  end

  defp seed_category(name, type) do
    with name <- String.capitalize(name),
         category <- %Category{name: name, type: type},
         %Category{id: id} <- Repo.insert!(category, on_conflict: :nothing) do
      :ok
    end
  end
end

Seeds.seed_categories!()
