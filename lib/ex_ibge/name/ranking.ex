defmodule ExIbge.Name.Ranking do
  @moduledoc """
  Struct representing a name ranking response.
  """

  defstruct [:locality, :sex, :results]

  @type t :: %__MODULE__{
          locality: String.t() | nil,
          sex: String.t() | nil,
          results: list(map())
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      locality: data["localidade"],
      sex: data["sexo"],
      results: translate_results(data["res"] || [])
    }
  end

  defp translate_results(results) do
    Enum.map(results, fn item ->
      %{
        name: item["nome"],
        frequency: item["frequencia"],
        ranking: item["ranking"]
      }
    end)
  end
end
