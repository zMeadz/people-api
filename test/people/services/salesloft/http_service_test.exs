defmodule People.Salesloft.HttpServiceTest do
  use ExUnit.Case

  alias People.Salesloft.HttpService

  test "can get auth token" do
    assert HttpService._get_auth_token() === "test_token"
  end

  test "can get base url" do
    assert HttpService._get_base_url() === "https://api.salesloft.com/v2"
  end

  test "can get headers" do
    assert HttpService._get_headers() === [Authorization: "Bearer test_token"]
  end
end
