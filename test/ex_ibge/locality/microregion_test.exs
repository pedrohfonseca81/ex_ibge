defmodule ExIbge.Locality.MicroregionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Microregion

  @microregion_fixture %{
    "id" => 33007,
    "nome" => "Nova Friburgo",
    "mesorregiao" => %{
      "id" => 3303,
      "nome" => "Centro Fluminense",
      "UF" => %{"id" => 33, "sigla" => "RJ", "nome" => "Rio de Janeiro"}
    }
  }

  describe "all/1" do
    test "returns all microregions" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/microrregioes"
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert {:ok, [microregion]} = Microregion.all()
      assert microregion.id == 33007
      assert microregion.name == "Nova Friburgo"
    end
  end

  describe "find/2" do
    test "returns microregion by ID" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/microrregioes/33007"
        Req.Test.json(conn, @microregion_fixture)
      end)

      assert {:ok, [microregion]} = Microregion.find(33007)
      assert microregion.id == 33007
    end
  end

  describe "get_by_state/2" do
    test "returns microregions by state ID" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/33/microrregioes"
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert {:ok, [microregion]} = Microregion.get_by_state(33)
      assert microregion.id == 33007
    end
  end

  describe "get_by_mesoregion/2" do
    test "returns microregions by mesoregion ID" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/mesorregioes/3303/microrregioes"
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert {:ok, [microregion]} = Microregion.get_by_mesoregion(3303)
      assert microregion.id == 33007
    end
  end

  describe "get_by_region/2" do
    test "returns microregions by region ID" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/microrregioes"
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert {:ok, [microregion]} = Microregion.get_by_region(3)
      assert microregion.id == 33007
    end
  end

  describe "bang functions" do
    test "all!/1 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert [%ExIbge.Geography.Microregion{}] = Microregion.all!()
    end

    test "find!/2 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, @microregion_fixture)
      end)

      assert [%ExIbge.Geography.Microregion{}] = Microregion.find!(33007)
    end

    test "get_by_state!/2 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@microregion_fixture])
      end)

      assert [%ExIbge.Geography.Microregion{}] = Microregion.get_by_state!(33)
    end
  end
end
