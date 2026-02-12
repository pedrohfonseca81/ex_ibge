defmodule ExIbge.Calendar.Release do
  @moduledoc """
  Struct representing a release (divulgação) from the IBGE Calendar API.
  """

  defstruct [
    :id,
    :title,
    :release_type_id,
    :release_type_name,
    :release_situation,
    :release_date,
    :research_id,
    :research_name,
    :research_url,
    :editorial,
    :product,
    :product_url
  ]

  @type t :: %__MODULE__{
          id: integer() | nil,
          title: String.t() | nil,
          release_type_id: integer() | nil,
          release_type_name: String.t() | nil,
          release_situation: String.t() | nil,
          release_date: String.t() | nil,
          research_id: integer() | nil,
          research_name: String.t() | nil,
          research_url: String.t() | nil,
          editorial: String.t() | nil,
          product: String.t() | nil,
          product_url: String.t() | nil
        }

  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil

  def from_map(data) do
    release_type = data["tipo_release"] || %{}
    research = data["pesquisa"] || %{}

    %__MODULE__{
      id: data["id"],
      title: data["titulo"],
      release_type_id: release_type["id"],
      release_type_name: release_type["nome"],
      release_situation: data["situacao_release"],
      release_date: data["data_divulgacao"],
      research_id: research["id"],
      research_name: research["nome"],
      research_url: research["url"],
      editorial: data["editoria"],
      product: data["produto"],
      product_url: data["produto_url"]
    }
  end

  def param_mappings do
    %{
      quantity: :qtd,
      from: :de,
      to: :ate
    }
  end
end
