defmodule Budget.Reports do
  alias Budget.Finances.Category
  alias Budget.Finances.Transaction

  @spec simple_report([Transaction.t()]) :: %{Category.t() => Decimal.t()}
  def simple_report(transactions) do
    transactions
    |> Enum.group_by(& &1.category)
    |> Enum.map(fn {category, transactions} -> {category, sum_transactions(transactions)} end)
    |> Map.new()
  end

  @spec detailed_report([Transaction.t()]) :: %{
          Category.t() => %{integer() => Decimal.t()}
        }
  def detailed_report(transactions) do
    transactions
    |> Enum.map(&[&1.category, &1.due_by.month, &1])
    |> nested_groupby(&sum_transactions/1, 2)
  end

  @spec per_credit_card([Transaction.t()]) :: %{boolean() => Decimal.t()}
  def per_credit_card(transactions) do
    transactions
    |> Enum.group_by(& &1.credit_card)
    |> Enum.map(fn {cc, transactions} -> {cc, sum_transactions(transactions)} end)
    |> Map.new()
    |> Map.merge(%{true: 0, false: 0}, fn _key, value1, _value2 -> value1 end)
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
