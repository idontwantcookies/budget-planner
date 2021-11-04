defmodule BudgetPlanning.Transactions.Subcategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias BudgetPlanning.Transactions.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:name, :category_id]
  @fields @required_fields

  schema "subcategories" do
    field :name, :string

    belongs_to :category, Category
    timestamps()
  end

  @doc false
  def changeset(subcategory, attrs) do
    subcategory
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
