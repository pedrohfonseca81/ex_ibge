defmodule ExIbge.Bngb.Category do
  @moduledoc """
  Struct representing a BNGB category (EDGV 3.0).
  """

  defstruct [:name]

  @type t :: %__MODULE__{name: String.t() | nil}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil
  def from_map(data), do: %__MODULE__{name: data["categoria"]}
end
