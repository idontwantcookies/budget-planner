defmodule Budget.Reports do
  alias Budget.Finances.Category
  alias Budget.Finances.Subcategory
  alias Budget.Finances.Transaction

  @spec simple_report([Transaction.t()]) :: %{Category.t() => Decimal.t()}
  def simple_report(transactions) do
    transactions
    |> Enum.group_by(& &1.subcategory.category)
    |> Enum.map(fn {category, transactions} -> {category, sum_transactions(transactions)} end)
    |> Map.new()
  end

  @spec detailed_report([Transaction.t()]) :: %{
          Category.t() => %{Subcategory.t() => %{integer() => Decimal.t()}}
        }
  def detailed_report(transactions) do
    transactions
    |> Enum.map(&[&1.subcategory.category, &1.subcategory, &1.due_by.month, &1])
    |> nested_groupby(&sum_transactions/1, 3)
  end

  @spec per_credit_card([Transaction.t()]) :: %{boolean() => Decimal.t()}
  def per_credit_card(transactions) do
    Enum.group_by(transactions, & &1.credit_card, &sum_transactions/1)
  end

  defp nested_groupby(list, agg_fun, 0), do: list |> agg_fun.()

  defp nested_groupby(list, agg_fun, nest_count) when nest_count > 0 do
    list
    |> Enum.group_by(
      &Enum.fetch!(&1, 0),
      fn list -> List.pop_at(list, 0) |> elem(1) |> pop_if_size_1() end
    )
    |> Enum.map(fn {k, v} -> {k, nested_groupby(v, agg_fun, nest_count - 1)} end)
    |> Map.new()
  end

  defp pop_if_size_1([elem]), do: elem
  defp pop_if_size_1(list), do: list

  defp sum_transactions(enumerable) do
    enumerable |> Enum.map(& &1.value) |> Enum.reduce(&Decimal.add/2)
  end
end
