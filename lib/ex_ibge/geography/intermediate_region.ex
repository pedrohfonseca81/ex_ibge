defmodule ExIbge.Geography.IntermediateRegion do
  defstruct [:id, :name, :state]

  @type t :: %__MODULE__{}

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      id: data["id"],
      name: data["nome"],
      state: ExIbge.Geography.State.from_map(data["UF"])
    }
  end
end
