defmodule ExIbge.Geography.Microregion do
  defstruct [:id, :name, :mesoregion]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      mesoregion: ExIbge.Geography.Mesoregion.from_map(data["mesorregiao"])
    }
  end
end
