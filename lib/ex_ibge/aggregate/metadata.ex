defmodule ExIbge.Aggregate.Metadata do
  defstruct [
    :id,
    :name,
    :url,
    :research,
    :subject,
    :periodicity,
    :territorial_level,
    :variables,
    :classifications
  ]

  alias ExIbge.Aggregate.{Variable, Classification}

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      url: data["URL"],
      research: data["pesquisa"],
      subject: data["assunto"],
      periodicity: data["periodicidade"],
      territorial_level: data["nivelTerritorial"],
      variables: Enum.map(data["variaveis"] || [], &Variable.from_map/1),
      classifications: Enum.map(data["classificacoes"] || [], &Classification.from_map/1)
    }
  end
end
