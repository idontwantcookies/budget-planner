defmodule Budget.Reports do
  alias Budget.Finances

  def get_monthly_report(year, month) do
    start = %Date{year: year, month: month, day: 1}
    stop = %Date{year: year, month: month, day: Date.days_in_month(start)}

    Finances.list_transactions(start, stop, subcategory: :category)
    |> Enum.group_by(& &1.subcategory.category)
    |> Enum.map(fn {category, transactions} -> {category, sum_transactions(transactions)} end)
    |> Map.new()
  end

  def get_yearly_report(year) do
    start = %Date{year: year, month: 1, day: 1}
    stop = %Date{year: year, month: 12, day: 31}

    Finances.list_transactions(start, stop, subcategory: :category)
    |> Enum.map(&[&1.subcategory.category, &1.subcategory, &1.due_by.month, &1])
    |> nested_groupby(&sum_transactions/1, 3)
  end

  defp nested_groupby(list, agg_fun, 0), do: list |> List.flatten() |> agg_fun.()

  defp nested_groupby(list, agg_fun, nest_count) when nest_count > 0 do
    list
    |> Enum.group_by(&Enum.fetch!(&1, 0), &(List.pop_at(&1, 0) |> elem(1)))
    |> Enum.map(fn {k, v} -> {k, nested_groupby(v, agg_fun, nest_count - 1)} end)
    |> Map.new()
  end

  defp sum_transactions(enumerable),
    do: enumerable |> Enum.map(& &1.value) |> Enum.reduce(&Decimal.add/2)
end
