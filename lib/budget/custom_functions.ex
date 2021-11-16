defmodule Budget.CustomFunctions do
  import Ecto.Query, warn: false

  defmacro month(datetime) do
    quote do
      fragment("cast(date_part('month', ?) as integer)", unquote(datetime))
    end
  end
end
