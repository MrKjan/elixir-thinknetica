defmodule ListerBehaviour do
  @moduledoc """
  Makes lists out of terms.
  """

  @callback to_list(any()) :: List
end

defmodule SenselessStruct do
  @behaviour ListerBehaviour

  defstruct data: [],
            state: "",
            err_code: :no_error

  @impl ListerBehaviour
  def to_list(%__MODULE__{data: data, state: state, err_code: err_code}) do
    [data, state, err_code]
  end
end
