defmodule ExIbge.Locality.MesoregionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Mesoregion

  @mesoregion_fixture %{
    "id" => 3301,
    "nome" => "Noroeste Fluminense",
    "UF" => %{
      "id" => 33,
      "sigla" => "RJ",
      "nome" => "Rio de Janeiro",
      "regiao" => %{
        "id" => 3,
        "sigla" => "SE",
        "nome" => "Sudeste"
      }
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@mesoregion_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all mesoregions" do
      assert {:ok, [mesoregion]} = Mesoregion.all()
      assert mesoregion.id == 3301
      assert mesoregion.name == "Noroeste Fluminense"
      assert mesoregion.state.acronym == "RJ"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/mesorregioes/3301"
        Req.Test.json(conn, @mesoregion_fixture)
      end)

      assert {:ok, [mesoregion]} = Mesoregion.find(3301)
      assert mesoregion.id == 3301
    end
  end

  describe "get_by_state/2" do
    test "returns mesoregions for a state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/33/mesorregioes"
        Req.Test.json(conn, [@mesoregion_fixture])
      end)

      assert {:ok, [mesoregion]} = Mesoregion.get_by_state(33)
      assert mesoregion.state.id == 33
    end

    test "returns mesoregions for a state atom" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/33/mesorregioes"
        Req.Test.json(conn, [@mesoregion_fixture])
      end)

      assert {:ok, [mesoregion]} = Mesoregion.get_by_state(:rj)
      assert mesoregion.state.acronym == "RJ"
    end
  end

  describe "get_by_region/2" do
    test "returns mesoregions for a region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/mesorregioes"
        Req.Test.json(conn, [@mesoregion_fixture])
      end)

      assert {:ok, [mesoregion]} = Mesoregion.get_by_region(3)
      assert mesoregion.state.region.id == 3
    end
  end
end
