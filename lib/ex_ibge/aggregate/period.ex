defmodule ExIbge.Aggregate.Period do
  defstruct [:id, :literals, :modification]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      literals: data["literals"],
      modification: data["modificacao"]
    }
  end

  def param_mappings do
    %{
      literals: :literals,
      modification: :modificacao
    }
  end
end
