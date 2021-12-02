defmodule Budget.Finances.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID
  alias Budget.Finances.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields [:value, :category_id, :description, :due_by]
  @fields [:credit_card, :status | @required_fields]

  @type t :: %__MODULE__{
          id: UUID.t(),
          description: String.t(),
          due_by: Date.t(),
          status: atom(),
          value: Decimal.t(),
          category_id: UUID.t(),
          credit_card: boolean()
        }

  schema "transactions" do
    field :description, :string
    field :due_by, :date, autogenerate: &Date.utc_today/0
    field :credit_card, :boolean, default: false
    field :value, :decimal

    field :status, Ecto.Enum,
      values: [:pending, :scheduled, :completed, :late],
      default: :completed

    belongs_to :category, Category
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:category_id)
  end
end
