defmodule ExIbge.Locality.District do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.District

  @moduledoc """
  Module for handling District (Distrito) queries from IBGE.

  Districts are administrative subdivisions of municipalities.
  This module allows fetching districts by various geographical hierarchies (State, Mesoregion, Municipality, etc.).
  """

  @doc """
  Get all districts.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`).

  ## Examples

      iex> ExIbge.Locality.District.all()
      {:ok, [%ExIbge.Geography.District{id: 520005005, name: "Abadia de Goiás", ...}, ...]}

  ## See Also

  [IBGE API: Distritos](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-distritosGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(District.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1), url: "/localidades/distritos", params: Utils.to_camel_case(query))
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.all!()
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec all!(Keyword.t()) :: list(District.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get district(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.District.find(160030312)
      {:ok, [%ExIbge.Geography.District{id: 160030312, name: "Fazendinha", ...}]}

  ## See Also

  [IBGE API: Distrito por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-distritosIdGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(District.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/distritos/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.find!(160030312)
      [%ExIbge.Geography.District{id: 160030312, name: "Fazendinha", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(District.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  @doc """
  Get districts by state identifier(s).

  ## Parameters

    * `uf_ids` - A single identifier or list of identifiers (Integer ID or Atom UFs).
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.District.get_by_state(33)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

      iex> ExIbge.Locality.District.get_by_state(:rj)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  ## See Also

  [IBGE API: Distritos por Estado](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-estadosUFDistritosGet)
  """
  @spec get_by_state(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_state(uf_ids, query \\ []) do
    ids = Utils.join_ids(uf_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/estados/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_state/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_state!(33)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_state!(
          integer() | atom() | String.t() | list(integer() | atom() | String.t()),
          Keyword.t()
        ) ::
          list(District.t())
  def get_by_state!(uf_ids, query \\ []) do
    Api.bangify(get_by_state(uf_ids, query))
  end

  @doc """
  Get districts by mesoregion identifier(s).

  ## Parameters

    * `mesoregion_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.District.get_by_mesoregion(1602)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  ## See Also

  [IBGE API: Distritos por Mesorregião](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-mesorregioesMesorregiaoDistritosGet)
  """
  @spec get_by_mesoregion(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_mesoregion(mesoregion_ids, query \\ []) do
    ids = Utils.join_ids(mesoregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/mesorregioes/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_mesoregion/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_mesoregion!(1602)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_mesoregion!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(District.t())
  def get_by_mesoregion!(mesoregion_ids, query \\ []) do
    Api.bangify(get_by_mesoregion(mesoregion_ids, query))
  end

  @doc """
  Get districts by microregion identifier(s).

  ## Parameters

    * `microregion_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.District.get_by_microregion(16003)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  ## See Also

  [IBGE API: Distritos por Microrregião](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-microrregioesMicrorregiaoDistritosGet)
  """
  @spec get_by_microregion(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_microregion(microregion_ids, query \\ []) do
    ids = Utils.join_ids(microregion_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/microrregioes/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_microregion/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_microregion!(16003)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_microregion!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(District.t())
  def get_by_microregion!(microregion_ids, query \\ []) do
    Api.bangify(get_by_microregion(microregion_ids, query))
  end

  @doc """
  Get districts by municipality identifier(s).

  ## Parameters

    * `municipality_ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.District.get_by_municipality(3550308)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  ## See Also

  [IBGE API: Distritos por Município](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-municipiosMunicipioDistritosGet)
  """
  @spec get_by_municipality(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_municipality(municipality_ids, query \\ []) do
    ids = Utils.join_ids(municipality_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/municipios/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_municipality/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_municipality!(3550308)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_municipality!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(District.t())
  def get_by_municipality!(municipality_ids, query \\ []) do
    Api.bangify(get_by_municipality(municipality_ids, query))
  end

  @doc """
  Get districts by immediate region identifier(s).

  Example:

      iex> ExIbge.Locality.District.get_by_immediate_region(310037)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-regioes-imediatasRegiaoImediataDistritosGet).
  """
  @spec get_by_immediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_immediate_region(immediate_region_ids, query \\ []) do
    ids = Utils.join_ids(immediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-imediatas/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_immediate_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_immediate_region!(310037)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_immediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(District.t())
  def get_by_immediate_region!(immediate_region_ids, query \\ []) do
    Api.bangify(get_by_immediate_region(immediate_region_ids, query))
  end

  @doc """
  Get districts by intermediate region identifier(s).

  Example:

      iex> ExIbge.Locality.District.get_by_intermediate_region(2603)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-regioes-intermediariasRegiaoIntermediariaDistritosGet).
  """
  @spec get_by_intermediate_region(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: {:ok, list(District.t())} | {:error, any()}
  def get_by_intermediate_region(intermediate_region_ids, query \\ []) do
    ids = Utils.join_ids(intermediate_region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes-intermediarias/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_intermediate_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_intermediate_region!(2603)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_intermediate_region!(
          integer() | String.t() | list(integer() | String.t()),
          Keyword.t()
        ) :: list(District.t())
  def get_by_intermediate_region!(intermediate_region_ids, query \\ []) do
    Api.bangify(get_by_intermediate_region(intermediate_region_ids, query))
  end

  @doc """
  Get districts by region identifier(s).

  Example:

      iex> ExIbge.Locality.District.get_by_region(3)
      {:ok, [%ExIbge.Geography.District{...}, ...]}

  For more information, see the [IBGE API documentation](https://servicodados.ibge.gov.br/api/docs/localidades#api-Distritos-regioesMacrorregiaoDistritosGet).
  """
  @spec get_by_region(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(District.t())} | {:error, any()}
  def get_by_region(region_ids, query \\ []) do
    ids = Utils.join_ids(region_ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/regioes/#{ids}/distritos",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `get_by_region/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.District.get_by_region!(3)
      [%ExIbge.Geography.District{...}, ...]
  """
  @spec get_by_region!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(District.t())
  def get_by_region!(region_ids, query \\ []) do
    Api.bangify(get_by_region(region_ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    districts = Enum.map(data, &District.from_map/1)
    {:ok, districts}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [District.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
