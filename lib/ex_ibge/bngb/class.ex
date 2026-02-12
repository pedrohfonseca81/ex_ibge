defmodule ExIbge.Bngb.Class do
  @moduledoc """
  Struct representing a BNGB class (EDGV 3.0).
  """

  defstruct [:name, :description, :category]

  @type t :: %__MODULE__{
          name: String.t() | nil,
          description: String.t() | nil,
          category: String.t() | nil
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    %__MODULE__{
      name: data["classe"],
      description: data["descricao_edgv"],
      category: data["categoria"]
    }
  end
end
