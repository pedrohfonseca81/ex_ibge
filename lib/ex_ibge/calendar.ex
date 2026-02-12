defmodule ExIbge.Calendar do
  @moduledoc """
  Module for handling the IBGE Calendar API (v3) — Calendário de Divulgações.

  Provides access to the IBGE release calendar, including scheduled and past
  releases of surveys and publications.

  ## Query Parameters

  Both `all/1` and `by_research/2` accept the following options:

    * `:quantity` (`:qtd`) — number of items per page (default: 10).
    * `:from` (`:de`) — start date filter in `ddMMyyyy` format.
    * `:to` (`:ate`) — end date filter in `ddMMyyyy` format.

  ## Examples

      # Get upcoming releases
      ExIbge.Calendar.all()

      # Get releases for a specific research
      ExIbge.Calendar.by_research(9173)

      # With date filters
      ExIbge.Calendar.all(from: "01012024", to: "31122024", quantity: 5)
  """

  alias ExIbge.Api
  alias ExIbge.Query
  alias ExIbge.Calendar.Release

  @doc """
  Get the calendar of releases.

  ## Parameters

    * `query` — optional keyword list of query parameters (see module docs).

  ## Examples

      iex> ExIbge.Calendar.all()
      {:ok, %{count: 100, page: 1, total_pages: 10, items: [%ExIbge.Calendar.Release{}, ...]}}

  ## See Also

  [IBGE API: Calendário](https://servicodados.ibge.gov.br/api/docs/calendario?versao=3#api-Calendario-rootGet)
  """
  @spec all(keyword()) :: {:ok, map()} | {:error, any()}
  def all(query \\ []) do
    Req.get(Api.new!(:v3),
      url: "/calendario/",
      params: Query.build(query, Release)
    )
    |> handle_response()
  end

  @doc """
  Same as `all/1`, but raises on failure.
  """
  @spec all!(keyword()) :: map()
  def all!(query \\ []), do: Api.bangify(all(query))

  @doc """
  Get the calendar of releases for a specific research.

  ## Parameters

    * `research_id` — the research identifier.
    * `query` — optional keyword list of query parameters (see module docs).

  ## Examples

      iex> ExIbge.Calendar.by_research(9173)
      {:ok, %{count: 10, page: 1, total_pages: 1, items: [%ExIbge.Calendar.Release{}, ...]}}

  ## See Also

  [IBGE API: Calendário por pesquisa](https://servicodados.ibge.gov.br/api/docs/calendario?versao=3#api-Calendario-pesquisaGet)
  """
  @spec by_research(integer() | String.t(), keyword()) :: {:ok, map()} | {:error, any()}
  def by_research(research_id, query \\ []) do
    Req.get(Api.new!(:v3),
      url: "/calendario/#{research_id}",
      params: Query.build(query, Release)
    )
    |> handle_response()
  end

  @doc """
  Same as `by_research/2`, but raises on failure.
  """
  @spec by_research!(integer() | String.t(), keyword()) :: map()
  def by_research!(research_id, query \\ []),
    do: Api.bangify(by_research(research_id, query))

  # --- Private ---

  defp handle_response({:ok, %{status: 200, body: body}}) when is_map(body) do
    {:ok, parse_paginated(body)}
  end

  defp handle_response({:ok, %{status: 200, body: body}}) when is_list(body) do
    {:ok,
     %{count: length(body), page: 1, total_pages: 1, items: Enum.map(body, &Release.from_map/1)}}
  end

  defp handle_response({:ok, %{status: status}}) do
    {:error, {:http_error, status}}
  end

  defp handle_response({:error, error}) do
    {:error, error}
  end

  defp parse_paginated(data) do
    items = data["items"] || []

    %{
      count: data["count"],
      page: data["page"],
      total_pages: data["totalPages"],
      items: Enum.map(items, &Release.from_map/1)
    }
  end
end
