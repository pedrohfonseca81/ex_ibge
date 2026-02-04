defmodule ExIbge.Aggregate.Variable do
  @moduledoc """
  Struct representing a variable from the Aggregates API.
  """

  defstruct [:id, :name, :unit, :results]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          unit: String.t() | nil,
          results: list(map())
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["variavel"] || data["nome"],
      unit: data["unidade"],
      results: translate_results(data["resultados"] || [])
    }
  end

  defp translate_results(results) when is_list(results) do
    Enum.map(results, &translate_result/1)
  end

  defp translate_results(_), do: []

  defp translate_result(result) do
    %{
      classifications: translate_classifications(result["classificacoes"] || []),
      series: translate_series(result["series"] || [])
    }
  end

  defp translate_classifications(classifications) do
    Enum.map(classifications, fn c ->
      %{
        id: c["id"],
        name: c["nome"],
        category: c["categoria"]
      }
    end)
  end

  defp translate_series(series) do
    Enum.map(series, fn s ->
      %{
        locality: translate_locality(s["localidade"]),
        series: s["serie"]
      }
    end)
  end

  defp translate_locality(nil), do: nil

  defp translate_locality(loc) do
    %{
      id: loc["id"],
      name: loc["nome"],
      level: translate_level(loc["nivel"])
    }
  end

  defp translate_level(nil), do: nil

  defp translate_level(level) do
    %{
      id: level["id"],
      name: level["nome"]
    }
  end
end
