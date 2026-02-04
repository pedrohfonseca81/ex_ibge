defmodule ExIbge.Locality.IntermediateRegionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.IntermediateRegion

  @intermediate_region_fixture %{
    "id" => 3301,
    "nome" => "Rio de Janeiro",
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
      Req.Test.json(conn, [@intermediate_region_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all intermediate regions" do
      assert {:ok, [region]} = IntermediateRegion.all()
      assert region.id == 3301
      assert region.name == "Rio de Janeiro"
      assert region.state.id == 33
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes-intermediarias/3301"
        Req.Test.json(conn, @intermediate_region_fixture)
      end)

      assert {:ok, [region]} = IntermediateRegion.find(3301)
      assert region.id == 3301
    end
  end

  describe "get_by_state/2" do
    test "returns intermediate regions for a state id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/33/regioes-intermediarias"
        Req.Test.json(conn, [@intermediate_region_fixture])
      end)

      assert {:ok, [region]} = IntermediateRegion.get_by_state(33)
      assert region.state.id == 33
    end
  end

  describe "get_by_region/2" do
    test "returns intermediate regions for a region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/regioes-intermediarias"
        Req.Test.json(conn, [@intermediate_region_fixture])
      end)

      assert {:ok, [region]} = IntermediateRegion.get_by_region(3)
      assert region.state.region.id == 3
    end
  end
end
