defmodule BudgetWeb.Router do
  use BudgetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BudgetWeb do
    pipe_through :api
  end
end
