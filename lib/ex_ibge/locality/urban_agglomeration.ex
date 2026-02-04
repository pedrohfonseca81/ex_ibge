defmodule ExIbge.Locality.UrbanAgglomeration do
  alias ExIbge.Api
  alias ExIbge.Utils
  alias ExIbge.Geography.UrbanAgglomeration

  @moduledoc """
  Module for handling Urban Agglomeration (Aglomeração Urbana) queries from IBGE.

  This module provides functions to fetch Urban Agglomerations.
  """

  @doc """
  Get all urban agglomerations.

  ## Parameters

    * `query` - Optional parameters supported by the API (e.g., `order_by: "nome"`, `municipio: 2611101`).

  ## Examples

      iex> ExIbge.Locality.UrbanAgglomeration.all()
      {:ok, [%ExIbge.Geography.UrbanAgglomeration{id: "00301", name: "Aglomeração Urbana de Franca", ...}, ...]}

  ## See Also

  [IBGE API: Aglomerações Urbanas](https://servicodados.ibge.gov.br/api/docs/localidades#api-Aglomeracoes_urbanas-aglomeracoes-urbanasGet)
  """
  @spec all(Keyword.t()) :: {:ok, list(UrbanAgglomeration.t())} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v1),
      url: "/localidades/aglomeracoes-urbanas",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.UrbanAgglomeration.all!()
      [%ExIbge.Geography.UrbanAgglomeration{id: "00301", name: "Aglomeração Urbana de Franca", ...}, ...]
  """
  @spec all!(Keyword.t()) :: list(UrbanAgglomeration.t())
  def all!(query \\ []) do
    Api.bangify(all(query))
  end

  @doc """
  Get urban agglomeration(s) by identifier(s).

  ## Parameters

    * `ids` - A single integer ID or a list of integer IDs.
    * `query` - Optional parameters supported by the API.

  ## Examples

      iex> ExIbge.Locality.UrbanAgglomeration.find("00301")
      {:ok, [%ExIbge.Geography.UrbanAgglomeration{id: "00301", name: "Aglomeração Urbana de Franca", ...}]}

  ## See Also

  [IBGE API: Aglomeração Urbana por ID](https://servicodados.ibge.gov.br/api/docs/localidades#api-Aglomeracoes_urbanas-aglomeracoes-urbanasAglomeracaoUrbanaGet)
  """
  @spec find(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          {:ok, list(UrbanAgglomeration.t())} | {:error, any()}
  def find(ids, query \\ []) do
    ids = Utils.join_ids(ids)

    Req.get(Api.new!(:v1),
      url: "/localidades/aglomeracoes-urbanas/#{ids}",
      params: Utils.to_camel_case(query)
    )
    |> handle_response()
  end

  @doc """
  Same as `find/2`, but raises an error on failure.

  ## Examples

      iex> ExIbge.Locality.UrbanAgglomeration.find!("00301")
      [%ExIbge.Geography.UrbanAgglomeration{id: "00301", name: "Aglomeração Urbana de Franca", ...}]
  """
  @spec find!(integer() | String.t() | list(integer() | String.t()), Keyword.t()) ::
          list(UrbanAgglomeration.t())
  def find!(ids, query \\ []) do
    Api.bangify(find(ids, query))
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_list(data) do
    agglomerations = Enum.map(data, &UrbanAgglomeration.from_map/1)
    {:ok, agglomerations}
  end

  defp handle_response({:ok, %{status: 200, body: data}}) when is_map(data) do
    {:ok, [UrbanAgglomeration.from_map(data)]}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end
end
