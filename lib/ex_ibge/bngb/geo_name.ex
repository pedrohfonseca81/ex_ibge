defmodule ExIbge.Bngb.GeoName do
  @moduledoc """
  Struct representing a geographic name entry from the BNGB name list.
  """

  defstruct [:term]

  @type t :: %__MODULE__{term: String.t() | nil}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil
  def from_map(data), do: %__MODULE__{term: data["termo"]}
end
