defmodule ExIbge.Geography.Region do
  defstruct [:id, :name, :acronym]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil
  def from_map(data), do: %__MODULE__{id: data["id"], name: data["nome"], acronym: data["sigla"]}
end
