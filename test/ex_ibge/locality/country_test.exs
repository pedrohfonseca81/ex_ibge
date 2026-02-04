defmodule ExIbge.Locality.CountryTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.Country

  @country_fixture %{
    "id" => %{
      "M49" => 76,
      "ISO-ALPHA-2" => "BR",
      "ISO-ALPHA-3" => "BRA"
    },
    "nome" => "Brasil",
    "regiao-intermediaria" => nil
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@country_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all countries" do
      assert {:ok, [country]} = Country.all()
      assert country.id == 76
      assert country.name == "Brasil"
      assert country.iso_alpha_2 == "BR"
      assert country.iso_alpha_3 == "BRA"
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/paises/76"
        Req.Test.json(conn, @country_fixture)
      end)

      assert {:ok, [country]} = Country.find(76)
      assert country.id == 76
      assert country.name == "Brasil"
    end
  end
end
