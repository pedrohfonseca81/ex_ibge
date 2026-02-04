defmodule ExIbge.Locality.RegionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Region

  @region_fixture %{
    "id" => 3,
    "sigla" => "SE",
    "nome" => "Sudeste"
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@region_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all regions" do
      assert {:ok, [region]} = Region.all()
      assert region.id == 3
      assert region.name == "Sudeste"
      assert region.acronym == "SE"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3"
        Req.Test.json(conn, @region_fixture)
      end)

      assert {:ok, [region]} = Region.find(3)
      assert region.id == 3
    end

    test "finds by list of ids" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3%7C4"
        Req.Test.json(conn, [@region_fixture, @region_fixture])
      end)

      assert {:ok, list} = Region.find([3, 4])
      assert length(list) == 2
    end
  end
end
