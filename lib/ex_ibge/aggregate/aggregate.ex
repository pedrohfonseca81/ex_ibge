defmodule ExIbge.Aggregate.Aggregate do
  defstruct [:id, :name]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"]
    }
  end

  def param_mappings do
    %{
      name: :nome
    }
  end
end
