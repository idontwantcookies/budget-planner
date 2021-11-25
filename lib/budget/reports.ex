defmodule Budget.Reports do
  import Ecto.Query
  import Budget.CustomFunctions
  alias Budget.Finances.Transaction
  alias Budget.Repo

  def get_monthly_report(year, month) do
    start = %Date{year: year, month: month, day: 1}
    stop = %Date{year: year, month: month, day: Date.days_in_month(start)}

    from([t, _sc, c] in base_query(start, stop),
      select: {c.name, sum(t.value)},
      group_by: [c.name]
    )
    |> Repo.all()
    |> Map.new()
  end

  def get_yearly_report(year) do
    start = %Date{year: year, month: 1, day: 1}
    stop = %Date{year: year, month: 12, day: 31}

    query =
      from [t, sc, c] in base_query(start, stop),
        select: {c.name, sc.name, month(t.due_by), sum(t.value)},
        group_by: [c.name, sc.name, month(t.due_by)]

    Repo.all(query)
  end

  defp base_query(start, stop) do
    from t in Transaction,
      where: t.due_by >= ^start and t.due_by <= ^stop,
      join: sc in assoc(t, :subcategory),
      join: c in assoc(sc, :category)
  end
end
