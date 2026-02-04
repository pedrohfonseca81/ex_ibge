defmodule ExIbge.Locality.IntegratedDevelopmentRegionTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.IntegratedDevelopmentRegion

  @ride_fixture %{
    "id" => "07801",
    "nome" => "Região Integrada de Desenvolvimento do Distrito Federal e Entorno",
    "municipios" => []
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@ride_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all integrated development regions" do
      assert {:ok, [ride]} = IntegratedDevelopmentRegion.all()
      assert ride.id == "07801"
      assert ride.name == "Região Integrada de Desenvolvimento do Distrito Federal e Entorno"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path ==
                 "/api/v1/localidades/regioes-integradas-de-desenvolvimento/07801"

        Req.Test.json(conn, @ride_fixture)
      end)

      assert {:ok, [ride]} = IntegratedDevelopmentRegion.find("07801")
      assert ride.id == "07801"
    end
  end
end
