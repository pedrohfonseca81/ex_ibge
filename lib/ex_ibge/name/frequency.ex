defmodule ExIbge.Name.Frequency do
  @moduledoc """
  Struct representing the frequency of a name by decade.
  """

  defstruct [:name, :locality, :sex, :results]

  @type t :: %__MODULE__{
          name: String.t() | nil,
          locality: String.t() | nil,
          sex: String.t() | nil,
          results: list(map())
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      name: data["nome"],
      locality: data["localidade"],
      sex: data["sexo"],
      results: translate_results(data["res"] || [])
    }
  end

  defp translate_results(results) do
    Enum.map(results, fn item ->
      %{
        period: item["periodo"],
        frequency: item["frequencia"]
      }
    end)
  end
end
