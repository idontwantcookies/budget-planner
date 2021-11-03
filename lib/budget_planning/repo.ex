defmodule BudgetPlanning.Repo do
  use Ecto.Repo,
    otp_app: :budget_planning,
    adapter: Ecto.Adapters.Postgres
end
