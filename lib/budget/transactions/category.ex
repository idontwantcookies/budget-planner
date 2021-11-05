defmodule Budget.Transactions.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Budget.Transactions.Subcategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:name]
  @fields @required_fields

  schema "categories" do
    field :name, :string

    has_many :subcategories, Subcategory
    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
