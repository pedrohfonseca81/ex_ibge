defmodule ExIbge.Aggregate.Variable do
  defstruct [:id, :name, :unit, :results]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      # 'variavel' in results, 'nome' in metadata
      name: data["variavel"] || data["nome"],
      unit: data["unidade"],
      # Raw list of maps for now
      results: data["resultados"]
    }
  end
end
