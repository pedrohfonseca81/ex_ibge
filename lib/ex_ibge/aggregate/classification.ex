defmodule ExIbge.Aggregate.Classification do
  defstruct [:id, :name, :categories]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      # Raw list or specialized struct if needed
      categories: data["categorias"]
    }
  end
end
