defmodule ExIbge.UtilsTest do
  use ExUnit.Case
  alias ExIbge.Utils

  test "to_camel_case/1 converts keys to camelCase" do
    params = [order_by: "name", other_param: 123]
    assert Utils.to_camel_case(params) == [{"orderBy", "name"}, {"otherParam", 123}]
  end

  test "to_camel_case/1 handles UF correctly" do
    params = [{"UF", 33}]
    assert Utils.to_camel_case(params) == [{"UF", 33}]
  end
end
