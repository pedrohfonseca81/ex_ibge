defmodule ExIbge.Geography.ImmediateRegion do
  defstruct [:id, :name, :intermediate_region]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      intermediate_region:
        ExIbge.Geography.IntermediateRegion.from_map(data["regiao-intermediaria"])
    }
  end

  def param_mappings do
    %{
      name: :nome,
      intermediate_region: :"regiao-intermediaria"
    }
  end
end
