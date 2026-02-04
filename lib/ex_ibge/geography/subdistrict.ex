defmodule ExIbge.Geography.Subdistrict do
  defstruct [:id, :name, :district]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      district: ExIbge.Geography.District.from_map(data["distrito"])
    }
  end
end
