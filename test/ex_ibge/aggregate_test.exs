defmodule ExIbge.AggregateTest do
  use ExUnit.Case, async: true
  alias ExIbge.Aggregate

  @research_fixture %{
    "id" => "P1",
    "nome" => "Pesquisa 1",
    "agregados" => [
      %{"id" => "1705", "nome" => "Agregado 1"}
    ]
  }

  @metadata_fixture %{
    "id" => 1705,
    "nome" => "Metadados Teste",
    "URL" => "http://sidra.ibge.gov.br",
    "pesquisa" => "Pesquisa Teste",
    "assunto" => "Assunto Teste",
    "periodicidade" => %{"frequencia" => "mensal"},
    "nivelTerritorial" => [],
    "variaveis" => [],
    "classificacoes" => []
  }

  @period_fixture %{
    "id" => "202001",
    "literals" => ["Janeiro 2020"],
    "modificacao" => "2020-02-01"
  }

  @variable_fixture %{
    "id" => "214",
    "variavel" => "Quantidade produzida",
    "unidade" => "Toneladas",
    "resultados" => []
  }

  setup do
    :ok
  end

  describe "all/1" do
    test "returns all aggregates grouped by research" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/agregados"
        Req.Test.json(conn, [@research_fixture])
      end)

      assert {:ok, [research]} = Aggregate.all()
      assert research.id == "P1"
      assert research.name == "Pesquisa 1"
      assert length(research.aggregates) == 1
      assert hd(research.aggregates).id == "1705"
    end
  end

  describe "get_metadata/1" do
    test "returns metadata for an aggregate" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/agregados/1705/metadados"
        Req.Test.json(conn, @metadata_fixture)
      end)

      assert {:ok, metadata} = Aggregate.get_metadata(1705)
      assert metadata.id == 1705
      assert metadata.name == "Metadados Teste"
    end
  end

  describe "get_periods/1" do
    test "returns periods for an aggregate" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/agregados/1705/periodos"
        Req.Test.json(conn, [@period_fixture])
      end)

      assert {:ok, [period]} = Aggregate.get_periods(1705)
      assert period.id == "202001"
    end
  end

  describe "get_locations/2" do
    test "returns locations for an aggregate and level" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/agregados/1705/localidades/N6"
        Req.Test.json(conn, [%{"id" => "3304557", "nome" => "Rio de Janeiro"}])
      end)

      assert {:ok, [location]} = Aggregate.get_locations(1705, "N6")
      assert location["id"] == "3304557"
    end
  end

  describe "get_variables/4" do
    test "returns variables data" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v3/agregados/1712/periodos/-6/variaveis/214"
        assert conn.query_string == "localidades=BR"
        Req.Test.json(conn, [@variable_fixture])
      end)

      assert {:ok, [variable]} = Aggregate.get_variables(1712, "-6", "214", localidades: "BR")
      assert variable.id == "214"
      assert variable.name == "Quantidade produzida"
    end
  end

  describe "all!/1" do
    test "returns results or raises error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@research_fixture])
      end)

      assert [%ExIbge.Aggregate.Research{}] = Aggregate.all!()
    end
  end

  describe "get_metadata!/1" do
    test "returns result or raises error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @metadata_fixture)
      end)

      assert %ExIbge.Aggregate.Metadata{} = Aggregate.get_metadata!(1705)
    end
  end

  describe "get_periods!/1" do
    test "returns result or raises error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@period_fixture])
      end)

      assert [%ExIbge.Aggregate.Period{}] = Aggregate.get_periods!(1705)
    end
  end

  describe "get_locations!/2" do
    test "returns result or raises error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [%{"id" => "3304557", "nome" => "Rio de Janeiro"}])
      end)

      assert [%{"id" => "3304557"}] = Aggregate.get_locations!(1705, "N6")
    end
  end

  describe "get_variables!/4" do
    test "returns result or raises error" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@variable_fixture])
      end)

      assert [%ExIbge.Aggregate.Variable{}] =
               Aggregate.get_variables!(1712, "-6", "214", localidades: "BR")
    end
  end
end
