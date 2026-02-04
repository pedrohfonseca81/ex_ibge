defmodule ExIbge.Locality.StateTest do
  use ExUnit.Case, async: true
  alias ExIbge.Locality.State

  @state_fixture %{
    "id" => 35,
    "sigla" => "SP",
    "nome" => "São Paulo",
    "regiao" => %{
      "id" => 3,
      "sigla" => "SE",
      "nome" => "Sudeste"
    }
  }

  setup do
    Req.Test.stub(ExIbge.Api, fn conn ->
      Req.Test.json(conn, [@state_fixture])
    end)

    :ok
  end

  describe "all/1" do
    test "returns all states" do
      assert {:ok, [state]} = State.all()
      assert state.id == 35
      assert state.acronym == "SP"
      assert state.name == "São Paulo"
    end

    test "passes query params" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.query_string == "orderBy=nome"
        Req.Test.json(conn, [@state_fixture])
      end)

      assert {:ok, _} = State.all(order_by: "nome")
    end
  end

  describe "find/2" do
    test "finds by id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35"
        Req.Test.json(conn, @state_fixture)
      end)

      assert {:ok, [state]} = State.find(35)
      assert state.id == 35
    end

    test "finds by atom" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35"
        Req.Test.json(conn, @state_fixture)
      end)

      assert {:ok, [state]} = State.find(:sp)
      assert state.id == 35
    end

    test "finds by list of atomic/integer ids" do
      ids = [:sp, 33]

      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/estados/35%7C33"
        Req.Test.json(conn, [@state_fixture, @state_fixture])
      end)

      assert {:ok, list} = State.find(ids)
      assert length(list) == 2
    end
  end

  describe "get_by_region/2" do
    test "gets by region id" do
      Req.Test.stub(ExIbge.Api, fn conn ->
        assert conn.request_path == "/api/v1/localidades/regioes/3/estados"
        Req.Test.json(conn, [@state_fixture])
      end)

      assert {:ok, _} = State.get_by_region(3)
    end
  end
end
