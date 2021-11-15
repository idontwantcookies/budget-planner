defmodule Budget.Reports do
  import Ecto.Query
  alias Budget.Finances.Category
  alias Budget.Finances.Subcategory
  alias Budget.Finances.Transaction
  alias Budget.Repo

  def get_totals_by_category(start, stop) do
    query =
      from t in Transaction,
        where: t.due_by >= ^start and t.due_by <= ^stop,
        join: sc in Subcategory,
        on: t.subcategory_id == sc.id,
        join: c in Category,
        on: sc.category_id == c.id,
        group_by: c.name,
        select: {c.name, sum(t.value)}

    query
    |> Repo.all()
    |> Map.new()
  end
end
