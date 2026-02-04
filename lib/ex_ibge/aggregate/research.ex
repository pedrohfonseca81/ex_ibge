defmodule ExIbge.Aggregate.Research do
  defstruct [:id, :name, :aggregates]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      aggregates: Enum.map(data["agregados"] || [], &ExIbge.Aggregate.Aggregate.from_map/1)
    }
  end
end
