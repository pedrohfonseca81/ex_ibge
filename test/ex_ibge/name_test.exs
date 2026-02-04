defmodule ExIbge.NameTest do
  use ExUnit.Case, async: true
  alias ExIbge.Name

  @frequency_fixture %{
    "nome" => "JOAO",
    "localidade" => "BR",
    "sexo" => nil,
    "res" => [
      %{"periodo" => "1930[", "frequencia" => 60155},
      %{"periodo" => "[1950,1960[", "frequencia" => 396_481}
    ]
  }

  @ranking_fixture %{
    "localidade" => "BR",
    "sexo" => nil,
    "res" => [
      %{"nome" => "MARIA", "frequencia" => 11_734_129, "ranking" => 1},
      %{"nome" => "JOSE", "frequencia" => 5_754_529, "ranking" => 2}
    ]
  }

  describe "frequency/2" do
    test "returns frequency for a single name" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v2/censos/nomes/joao"
        Req.Test.json(conn, [@frequency_fixture])
      end)

      assert {:ok, [freq]} = Name.frequency("joao")
      assert freq.name == "JOAO"
      assert freq.locality == "BR"
      assert length(freq.results) == 2
    end

    test "returns frequency for multiple names" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path =~ "/api/v2/censos/nomes/joao"
        Req.Test.json(conn, [@frequency_fixture, %{@frequency_fixture | "nome" => "MARIA"}])
      end)

      assert {:ok, freqs} = Name.frequency(["joao", "maria"])
      assert length(freqs) == 2
    end

    test "supports sexo filter" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.query_string == "sexo=F"
        Req.Test.json(conn, [@frequency_fixture])
      end)

      assert {:ok, _} = Name.frequency("ariel", sexo: "F")
    end
  end

  describe "ranking/1" do
    test "returns ranking with default params" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v2/censos/nomes/ranking"
        Req.Test.json(conn, [@ranking_fixture])
      end)

      assert {:ok, [ranking]} = Name.ranking()
      assert ranking.locality == "BR"
      assert length(ranking.results) == 2
    end

    test "supports decada filter" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.query_string == "decada=1950"
        Req.Test.json(conn, [@ranking_fixture])
      end)

      assert {:ok, _} = Name.ranking(decada: "1950")
    end

    test "supports localidade and sexo filters" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.query_string =~ "localidade=33"
        assert conn.query_string =~ "sexo=F"
        Req.Test.json(conn, [@ranking_fixture])
      end)

      assert {:ok, _} = Name.ranking(localidade: "33", sexo: "F")
    end
  end

  describe "bang functions" do
    test "frequency!/2 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@frequency_fixture])
      end)

      assert [%ExIbge.Name.Frequency{}] = Name.frequency!("joao")
    end

    test "ranking!/1 returns results" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        Req.Test.json(conn, [@ranking_fixture])
      end)

      assert [%ExIbge.Name.Ranking{}] = Name.ranking!()
    end
  end
end
