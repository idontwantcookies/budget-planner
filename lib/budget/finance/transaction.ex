defmodule Budget.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Finance.Account

  @required_fields [:amount, :description]
  @fields [:generated_at, :due_by, :completed_at | @required_fields]

  schema "transactions" do
    field :generated_at, :date, default: Date.utc_today()
    field :due_by, :date
    field :completed_at, :date
    field :amount, :decimal
    field :description, :string

    # belongs_to :from, Finance.Account
    # belongs_to :to, Finance.Account
    # has_many :items, Finance.Item
    timestamps()
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
