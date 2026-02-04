defmodule ExIbge.Geography.Municipality do
  defstruct [:id, :name, :microregion, :immediate_region]

  @type t :: %__MODULE__{}

  @doc """
  Convert a map to a municipality.
  """
  @spec from_map(map()) :: t()
  def from_map(nil), do: nil

  @spec from_map(map()) :: ExIbge.Geography.Municipality.t()
  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      microregion: ExIbge.Geography.Microregion.from_map(data["microrregiao"]),
      immediate_region: ExIbge.Geography.ImmediateRegion.from_map(data["regiao-imediata"])
    }
  end
end
