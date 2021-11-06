defmodule Budget.Finances.CategorySeeds do
  @moduledoc """
  Used to quickly get the application running with some commonly used categories.
  """

  alias Budget.Finances

  def seed! do
    [
      "Children",
      "Debt",
      "Education",
      "Entertainment",
      "Everyday",
      "Gifts",
      "Health/medical",
      "Home",
      "Insurance",
      "Investments",
      "Pets",
      "Technology",
      "Transportation",
      "Travel",
      "Utilities"
    ]
    |> Enum.each(fn name -> {:ok, _category} = Finances.create_category(%{name: name}) end)

    :ok
  end
end
