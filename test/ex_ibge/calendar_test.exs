defmodule ExIbge.CalendarTest do
  use ExUnit.Case, async: true
  alias ExIbge.Calendar

  @release_fixture %{
    "id" => 1234,
    "titulo" => "IPCA - Índice Nacional de Preços ao Consumidor Amplo",
    "tipo_release" => %{"id" => 1, "nome" => "Índice"},
    "situacao_release" => "Normal",
    "data_divulgacao" => "2024-01-10T09:00:00",
    "pesquisa" => %{
      "id" => 9173,
      "nome" => "Índice Nacional de Preços ao Consumidor Amplo - IPCA",
      "url" => "https://www.ibge.gov.br/estatisticas/economicas/precos-e-custos/9256-ipca.html"
    },
    "editoria" => "Estatísticas Econômicas",
    "produto" => "IPCA",
    "produto_url" => "https://www.ibge.gov.br/estatisticas/ipca"
  }

  @paginated_fixture %{
    "count" => 50,
    "page" => 1,
    "totalPages" => 5,
    "items" => [@release_fixture]
  }

  describe "all/1" do
    test "returns paginated releases" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/calendario/"
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert {:ok, result} = Calendar.all()
      assert result.count == 50
      assert result.page == 1
      assert result.total_pages == 5
      assert [release] = result.items
      assert release.id == 1234
      assert release.title == "IPCA - Índice Nacional de Preços ao Consumidor Amplo"
      assert release.release_type_id == 1
      assert release.release_type_name == "Índice"
      assert release.release_situation == "Normal"
      assert release.release_date == "2024-01-10T09:00:00"
      assert release.research_id == 9173
      assert release.research_name == "Índice Nacional de Preços ao Consumidor Amplo - IPCA"
      assert release.editorial == "Estatísticas Econômicas"
      assert release.product == "IPCA"
    end

    test "passes query parameters" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        params = URI.decode_query(conn.query_string)
        assert params["qtd"] == "5"
        assert params["de"] == "01012024"
        assert params["ate"] == "31122024"
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert {:ok, _} = Calendar.all(quantity: 5, from: "01012024", to: "31122024")
    end

    test "handles list response" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@release_fixture])
      end)

      assert {:ok, result} = Calendar.all()
      assert result.count == 1
      assert [%ExIbge.Calendar.Release{}] = result.items
    end
  end

  describe "by_research/2" do
    test "returns paginated releases for a research" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/calendario/9173"
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert {:ok, result} = Calendar.by_research(9173)
      assert result.count == 50
      assert [release] = result.items
      assert release.research_id == 9173
    end

    test "passes query parameters" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/calendario/9173"
        params = URI.decode_query(conn.query_string)
        assert params["qtd"] == "3"
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert {:ok, _} = Calendar.by_research(9173, quantity: 3)
    end
  end

  describe "bang functions" do
    test "all!/1 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert %{items: [%ExIbge.Calendar.Release{}]} = Calendar.all!()
    end

    test "by_research!/2 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @paginated_fixture)
      end)

      assert %{items: [%ExIbge.Calendar.Release{}]} = Calendar.by_research!(9173)
    end
  end

  describe "error handling" do
    test "returns error tuple on HTTP error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Plug.Conn.send_resp(conn, 500, "")
      end)

      assert {:error, {:http_error, 500}} = Calendar.all()
    end
  end
end
