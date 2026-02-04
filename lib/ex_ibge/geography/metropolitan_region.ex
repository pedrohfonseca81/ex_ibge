defmodule ExIbge.Geography.MetropolitanRegion do
  defstruct [:id, :name, :state, :municipalities]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      state: ExIbge.Geography.State.from_map(data["UF"]),
      municipalities:
        Enum.map(data["municipios"] || [], &ExIbge.Geography.Municipality.from_map/1)
    }
  end
end
