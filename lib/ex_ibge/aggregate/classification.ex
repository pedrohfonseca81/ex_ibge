defmodule ExIbge.Aggregate.Classification do
  @moduledoc """
  Struct representing a classification from the Aggregates API.
  """

  defstruct [:id, :name, :categories]

  @type t :: %__MODULE__{
          id: integer() | String.t() | nil,
          name: String.t() | nil,
          categories: list(map())
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      categories: translate_categories(data["categorias"] || [])
    }
  end

  defp translate_categories(categories) when is_list(categories) do
    Enum.map(categories, fn cat ->
      %{
        id: cat["id"],
        level: cat["nivel"],
        name: cat["nome"],
        unit: cat["unidade"]
      }
    end)
  end

  defp translate_categories(_), do: []
end
