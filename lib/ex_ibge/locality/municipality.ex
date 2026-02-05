defmodule ExIbge.Locality.Municipality do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Query

  @moduledoc """
  Module for handling Municipality (Município) queries from IBGE.

  This module provides functions to fetch Municipalities by various geographical hierarchies
  (State, Mesoregion, Microregion, Immediate Region, Intermediate Region, Region).
  """

  @doc """
  Get all municipalities.

  Example:

      iex> ExIbge.Locality.Municipality.all()
      {:ok, [%ExIbge.Geography.Municipality{id: 1100015, name: "Alta Floresta D'Oeste", ...}, ...]}

  Example with query:

      iex> ExIbge.Locality.Municipality.all(order_by: :name, view: "nivelado")
      {:ok, [%ExIbge.Geography.Municipality{id: 1100015, name: "Alta Floresta D'Oeste", ...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-municipiosGet).
  """
  @spec all(Keyword.t()) :: {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Municipality.all!()
      [%ExIbge.Geography.Municipality{id: 1100015, name: "Alta Floresta D'Oeste", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(ExIbge.Geography.Municipality.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get municipalities by identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.find(3550308)
      {:ok, [%ExIbge.Geography.Municipality{id: 3550308, name: "São Paulo", ...}]}

  Example with multiple IDs:

      iex> ExIbge.Locality.Municipality.find([3304557, 3550308])
      {:ok, [%ExIbge.Geography.Municipality{id: 3304557, name: "Rio de Janeiro", ...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-municipiosIdGet).
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/municipios/#{ids}",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Municipality.find!(3550308)
      [%ExIbge.Geography.Municipality{id: 3550308, name: "São Paulo", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ExIbge.Geography.Municipality.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get municipalities by state identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_state(33)
      {:ok, [%ExIbge.Geography.Municipality{id: 3300100, name: "Angra dos Reis", ...}, ...]}

  Example with multiple states:

      iex> ExIbge.Locality.Municipality.get_by_state([33, 35])
      {:ok, [%ExIbge.Geography.Municipality{id: 3300100, name: "Angra dos Reis", ...}, ...]}

  Example with state atom:

      iex> ExIbge.Locality.Municipality.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.Municipality{id: 3300100, name: "Angra dos Reis", ...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-estadosUFMunicipiosGet).
  """
  @spec get_by_state(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.Municipality.get_by_state!(33)
      [%ExIbge.Geography.Municipality{id: 3300100, name: "Angra dos Reis", ...}, ...]
  """
  @spec get_by_state!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ExIbge.Geography.Municipality.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get municipalities by mesoregion identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_mesoregion(3301)
      {:ok, [%ExIbge.Geography.Municipality{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-mesorregioesMesorregiaoMunicipiosGet).
  """
  @spec get_by_mesoregion(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_mesoregion(mesoregion_ids, query \\ []) do
    ids = Utils.join_ids(mesoregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/mesorregioes/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Get municipalities by mesoregion identifier(s) or raise an error.
  """
  @spec get_by_mesoregion!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ExIbge.Geography.Municipality.t())
  def get_by_mesoregion!(mesoregion_ids, query \\ []) do
    Api.bangify(get_by_mesoregion(mesoregion_ids, query))
  end

  @doc """
  Get municipalities by microregion identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_microregion(33001)
      {:ok, [%ExIbge.Geography.Municipality{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-microrregioesMicrorregiaoMunicipiosGet).
  """
  @spec get_by_microregion(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_microregion(microregion_ids, query \\ []) do
    ids = Utils.join_ids(microregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/microrregioes/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Get municipalities by microregion identifier(s) or raise an error.
  """
  @spec get_by_microregion!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ExIbge.Geography.Municipality.t())
  def get_by_microregion!(microregion_ids, query \\ []) do
    Api.bangify(get_by_microregion(microregion_ids, query))
  end

  @doc """
  Get municipalities by immediate region identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_immediate_region(310055)
      {:ok, [%ExIbge.Geography.Municipality{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-regioes_imediatasRegiaoImediataMunicipiosGet).
  """
  @spec get_by_immediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_immediate_region(immediate_region_ids, query \\ []) do
    ids = Utils.join_ids(immediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-imediatas/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Get municipalities by immediate region identifier(s) or raise an error.
  """
  @spec get_by_immediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(ExIbge.Geography.Municipality.t())
  def get_by_immediate_region!(immediate_region_ids, query \\ []) do
    Api.bangify(get_by_immediate_region(immediate_region_ids, query))
  end

  @doc """
  Get municipalities by intermediate region identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_intermediate_region(5202)
      {:ok, [%ExIbge.Geography.Municipality{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-regioes_intermediariasRegiaoIntermediariaMunicipiosGet).
  """
  @spec get_by_intermediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_intermediate_region(intermediate_region_ids, query \\ []) do
    ids = Utils.join_ids(intermediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-intermediarias/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Get municipalities by intermediate region identifier(s) or raise an error.
  """
  @spec get_by_intermediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(ExIbge.Geography.Municipality.t())
  def get_by_intermediate_region!(intermediate_region_ids, query \\ []) do
    Api.bangify(get_by_intermediate_region(intermediate_region_ids, query))
  end

  @doc """
  Get municipalities by region identifier(s).

  Example:

      iex> ExIbge.Locality.Municipality.get_by_region(3)
      {:ok, [%ExIbge.Geography.Municipality{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-regioesMacrorregiaoMunicipiosGet).
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(ExIbge.Geography.Municipality.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/municipios",
      params: Query.build(query, ExIbge.Geography.Municipality)
    )
    |> handle_response()
  end

  @doc """
  Get municipalities by region identifier(s) or raise an error.
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(ExIbge.Geography.Municipality.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    municipalities = Enum.map(data, &ExIbge.Geography.Municipality.from_map/1)
    {:ok, municipalities}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [ExIbge.Geography.Municipality.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
