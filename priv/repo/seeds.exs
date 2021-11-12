defmodule Seeds do
  @moduledoc """
  Used to quickly get the application running with some commonly used categories.
  """

  alias Budget.Finances.{Category, Subcategory}
  alias Budget.Repo

  @expenses %{
    "children" => ~w"activities allowance medical childcare clothing school toys other",
    "debt" => ~w"credit cards student_loans other_loans taxes(federal) taxes(state) other",
    "education" => ~w"tuition books music_lessons other",
    "entertainment" =>
      ~w"books concerts/shows games hobbies movies music outdoor_activities photography sports theater/plays tv drinks other",
    "everyday" =>
      ~w"groceries restaurants personal supplies clothes laundry hair/beauty subscriptions other",
    "gifts" => ~w"gifts donations other",
    "health/medical" =>
      ~w"doctors/dental/vision therapy speciality_care pharmacy emergency other",
    "home" =>
      ~w"rent/mortgage property_taxes furnishings condominium lawn/garden supplies maintainance improvements moving other",
    "insurance" => ~w"car health home life other",
    "investments" => ~w"fixed_income treasuries funds stocks savings other",
    "pets" => ~w"food vet/medical toys supplies other",
    "technology" => ~w"domains_&_hosting online services hardware software other",
    "transportation" =>
      ~w"fuel car payments repairs registration/license supplies public transit other",
    "travel" => ~w"airfare hotels food transportation entertainment other",
    "utilities" => ~w"phone tv internet electricity heat/gas water trash other"
  }

  @incomes %{
    "wages" => ~w"paycheck tips bonus comission other",
    "other" => ~w"transfer_from_savings interest_income dividends gifts refunds other"
  }

  def seed_categories! do
    expenses = Enum.map(@expenses, &seed_category(&1, :expense))
    incomes = Enum.map(@incomes, &seed_category(&1, :income))
    Enum.each(expenses ++ incomes, &seed_subcategories/1)

    :ok
  end

  defp seed_category({name, subcategories}, type) do
    with name <- parse_name(name),
         category <- %Category{name: name, type: type},
         %Category{id: id} <- Repo.insert!(category) do
      {id, subcategories}
    end
  end

  defp seed_subcategories({category_id, subcategories}) do
    Enum.each(subcategories, fn name ->
      :ok = create_subcategory(category_id, parse_name(name))
    end)

    :ok
  end

  defp create_subcategory(category_id, name) do
    with name <- parse_name(name),
         subcategory <- %Subcategory{name: name, category_id: category_id},
         %Subcategory{} <- Repo.insert!(subcategory) do
      :ok
    end
  end

  defp parse_name(name) do
    name
    |> String.replace("_", " ")
    |> String.replace("tv", "TV")
    |> String.capitalize()
  end
end

Seeds.seed_categories!()
