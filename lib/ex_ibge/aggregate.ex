defmodule ExIbge.Aggregate do
  alias ExIbge.Api
  alias ExIbge.Utils

  alias ExIbge.Aggregate.{
    Research,
    Metadata,
    Period,
    Variable
  }

  @moduledoc """
  Module for handling IBGE Aggregates API (v3).

  Allows accessing aggregated data from surveys and censuses (SIDRA).
  """

  @doc """
  Get all aggregates grouped by research.

  ## Parameters

    * `query` - Optional parameters:
      * `periodo`: Filter by period (e.g. "P5[202001]")
      * `assunto`: Filter by subject ID (e.g. 70)
      * `classificacao`: Filter by classification ID (e.g. 12896)
      * `periodicidade`: Filter by periodicity (e.g. "P5")
      * `nivel`: Filter by geographical level (e.g. "N6")

  ## Examples

      iex> ExIbge.Aggregate.all()
      {:ok, [%ExIbge.Aggregate.Research{...}, ...]}

  ## See Also

  [IBGE API: Agregados](https://servicodados.ibge.gov.br/api/docs/agregados#api-Agregados-agregadosGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(Research.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v3),
      url: "/agregados",
      params: Utils.to_camel_case(query)
    )
    |> handle_response(Research)
  end

  @doc """
  Same as `all/1`, but raises an error on failure.
  """
  @spec all!(Keyword.t()) :: list(Research.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get metadata for a specific aggregate.

  ## Parameters

    * `aggregate_id` - ID of the aggregate (e.g. 1705)

  ## Examples

      iex> ExIbge.Aggregate.get_metadata(1705)
      {:ok, %ExIbge.Aggregate.Metadata{...}}

  ## See Also

  [IBGE API: Metadados](https://servicodados.ibge.gov.br/api/docs/agregados#api-Metadados-agregadosAgregadoMetadadosGet)
  """
  @spec get_metadata(integer() | String.t()) :: {:ok, Metadata.t()} | {:error, any()}
  def get_metadata(aggregate_id) do
    Req.get(Api.new!(:v3),
      url: "/agregados/#{aggregate_id}/metadados"
    )
    |> handle_response(Metadata)
  end

  @spec get_metadata!(integer() | String.t()) :: Metadata.t()
  def get_metadata!(aggregate_id) do
    Api.bangify(get_metadata(aggregate_id))
  end

  @doc """
  Get periods for a specific aggregate.

  ## Parameters

    * `aggregate_id` - ID of the aggregate (e.g. 1705)

  ## Examples

      iex> ExIbge.Aggregate.get_periods(1705)
      {:ok, [%ExIbge.Aggregate.Period{...}, ...]}

  ## See Also

  [IBGE API: Períodos](https://servicodados.ibge.gov.br/api/docs/agregados#api-Periodos-agregadosAgregadoPeriodosGet)
  """
  @spec get_periods(integer() | String.t()) :: {:ok, list(Period.t())} | {:error, any()}
  def get_periods(aggregate_id) do
    Req.get(Api.new!(:v3),
      url: "/agregados/#{aggregate_id}/periodos"
    )
    |> handle_response(Period)
  end

  @spec get_periods!(integer() | String.t()) :: list(Period.t())
  def get_periods!(aggregate_id) do
    Api.bangify(get_periods(aggregate_id))
  end

  @doc """
  Get locations associated with an aggregate for specific geographical level(s).

  ## Parameters

    * `aggregate_id` - ID of the aggregate (e.g. 1705)
    * `level` - Geographical level ID(s), pipe-separated (e.g. "N6" or "N7|N6")

  ## Examples

      iex> ExIbge.Aggregate.get_locations(1705, "N6")
      {:ok, [%{id: "3304557", nome: "Rio de Janeiro", ...}, ...]}

      iex> ExIbge.Aggregate.get_locations(1705, "N7|N6")
      {:ok, [%{id: "3301", ...}, ...]}

  ## See Also

  [IBGE API: Localidades por agregado](https://servicodados.ibge.gov.br/api/docs/agregados#api-Localidades-agregadosAgregadoLocalidadesNivelGet)
  """
  @spec get_locations(integer() | String.t(), String.t()) :: {:ok, list(map())} | {:error, any()}
  def get_locations(aggregate_id, level) do
    Req.get(Api.new!(:v3),
      url: "/agregados/#{aggregate_id}/localidades/#{level}"
    )
    |> handle_raw_response()
  end

  @spec get_locations!(integer() | String.t(), String.t()) :: list(map())
  def get_locations!(aggregate_id, level) do
    Api.bangify(get_locations(aggregate_id, level))
  end

  @doc """
  Get variables data for an aggregate.

  This function allows querying the data for specific variables, periods, and locations/classifications.

  ## Parameters

    * `aggregate_id` - ID of the aggregate (e.g. 1712)
    * `periods` - Period identifier(s) (e.g. "-6", "201701", "201701-201706")
    * `variables` - Variable identifier(s) (e.g. "214", "all", "allxp"). Defaults to "allxp" if nil.
    * `query` - Additional query parameters:
      * `localidades`: Required. Location filter (e.g. "BR", "N6[3304557]")
      * `classificacao`: Optional. Classification filter (e.g. "226[4844]")
      * `view`: Optional. "OLAP" or "flat".

  ## Examples

      iex> ExIbge.Aggregate.get_variables(1712, "-6", "214", localidades: "BR")
      {:ok, [%ExIbge.Aggregate.Variable{...}, ...]}

  ## See Also

  [IBGE API: Variáveis](https://servicodados.ibge.gov.br/api/docs/agregados#api-Variaveis-agregadosAgregadoPeriodosPeriodosVariaveisVariavelGet)
  """
  @spec get_variables(
          integer() | String.t(),
          String.t(),
          String.t() | nil,
          Keyword.t()
        ) :: {:ok, list(Variable.t())} | {:error, any()}
  def get_variables(aggregate_id, periods, variables, query) do
    variables = variables || "allxp"

    Req.get(Api.new!(:v3),
      url: "/agregados/#{aggregate_id}/periodos/#{periods}/variaveis/#{variables}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response(Variable)
  end

  @spec get_variables!(
          integer() | String.t(),
          String.t(),
          String.t() | nil,
          Keyword.t()
        ) :: list(Variable.t())
  def get_variables!(aggregate_id, periods, variables, query) do
    Api.bangify(get_variables(aggregate_id, periods, variables, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}, schema) when is_list(data) do
    {:ok, Enum.map(data, &schema.from_map/1)}
  end

  defp handle_response({:ok, %{status: 200, body: data}}, schema) when is_map(data) do
    {:ok, schema.from_map(data)}
  end

  defp handle_response({:ok, %{status: status}}, _schema) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}, _schema) do
    {:error, error}
  end

  defp handle_raw_response({:ok, %{status: 200, body: data}}) do
    {:ok, data}
  end

  defp handle_raw_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_raw_response({:error, error}) do
    {:error, error}
  end
end
