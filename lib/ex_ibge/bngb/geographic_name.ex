defmodule ExIbge.Bngb.GeographicName do
  @moduledoc """
  Struct representing a geographic name from the BNGB (Banco de Nomes Geográficos do Brasil).
  """

  defstruct [
    :id,
    :name,
    :geocode,
    :generic_term,
    :specific_term,
    :connective,
    :category,
    :class,
    :scale_occurrence,
    :validation_status,
    :validation_level,
    :latitude,
    :longitude,
    :latitude_gms,
    :longitude_gms,
    :validation_date,
    :publication_date,
    :geometry_origin_scale,
    :validation_support,
    :geometry_type,
    :geometry
  ]

  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t() | nil,
          geocode: String.t() | nil,
          generic_term: String.t() | nil,
          specific_term: String.t() | nil,
          connective: String.t() | nil,
          category: String.t() | nil,
          class: String.t() | nil,
          scale_occurrence: String.t() | nil,
          validation_status: String.t() | nil,
          validation_level: String.t() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          latitude_gms: String.t() | nil,
          longitude_gms: String.t() | nil,
          validation_date: String.t() | nil,
          publication_date: String.t() | nil,
          geometry_origin_scale: String.t() | nil,
          validation_support: String.t() | nil,
          geometry_type: String.t() | nil,
          geometry: map() | nil
        }

  @spec from_feature(map() | nil) :: t() | nil
  def from_feature(nil), do: nil

  def from_feature(%{"properties" => props} = feature) do
    %__MODULE__{
      id: props["idNomebngb"],
      name: props["nomeGeografico"],
      geocode: props["geocodigo"],
      generic_term: props["termoGenerico"],
      specific_term: props["termoEspecifico"],
      connective: props["conectivo"],
      category: props["categoria"],
      class: props["classe"],
      scale_occurrence: props["escalaOcorrencia"],
      validation_status: props["statusValidacao"],
      validation_level: props["nivelValidacao"],
      latitude: props["latitude"],
      longitude: props["longitude"],
      latitude_gms: props["latitudeGMS"],
      longitude_gms: props["longitudeGMS"],
      validation_date: props["dataValidacao"],
      publication_date: props["dataPublicacao"],
      geometry_origin_scale: props["escalaOrigemGeometria"],
      validation_support: props["sustentacaoValidacao"],
      geometry_type: props["geometrytype"],
      geometry: feature["geometry"]
    }
  end
end
