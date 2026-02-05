defmodule ExIbge.Geography.Country do
  defstruct [:id, :iso_alpha_2, :iso_alpha_3, :name, :intermediate_region]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: get_in(data, ["id", "M49"]),
      iso_alpha_2: get_in(data, ["id", "ISO-ALPHA-2"]),
      iso_alpha_3: get_in(data, ["id", "ISO-ALPHA-3"]),
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
