defmodule Budget.Finances.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID
  alias Budget.Finances.Subcategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields [:value, :subcategory_id, :description, :due_by]
  @fields [:credit_card, :status | @required_fields]

  @type t :: %__MODULE__{
          id: UUID.t(),
          description: String.t(),
          due_by: Date.t(),
          status: atom(),
          value: Decimal.t(),
          subcategory_id: UUID.t(),
          credit_card: boolean()
        }

  schema "transactions" do
    field :description, :string
    field :due_by, :date, autogenerate: &Date.utc_today/0
    field :credit_card, :boolean, default: false

    field :status, Ecto.Enum,
      values: [:pending, :scheduled, :completed, :late],
      default: :completed

    field :value, :decimal

    belongs_to :subcategory, Subcategory
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:subcategory_id)
  end
end
