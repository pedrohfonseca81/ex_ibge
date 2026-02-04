defmodule ExIbge.Geography.State do
  defstruct [:id, :name, :acronym, :region]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      acronym: data["sigla"],
      region: ExIbge.Geography.Region.from_map(data["regiao"])
    }
  end
end
