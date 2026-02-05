defmodule ExIbge.Geography.District do
  defstruct [:id, :name, :municipality]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      municipality: ExIbge.Geography.Municipality.from_map(data["municipio"])
    }
  end

  def param_mappings do
    %{
      name: :nome,
      municipality: :municipio
    }
  end
end
