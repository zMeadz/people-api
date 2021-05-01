defmodule People.Salesloft.HttpService do
  alias People.HttpService, as: Http

  def get(url, options \\ []) do
    Http.get("#{_get_base_url()}/#{url}", _get_headers(), options)
  end

  def _get_auth_token() do
    Application.get_env(:people, :services)[:salesloft][:auth_token]
  end

  def _get_base_url() do
    vars = Application.get_env(:people, :services)[:salesloft]
    "#{vars[:base_url]}/#{vars[:version]}"
  end

  def _get_headers() do
    [Authorization: "Bearer " <> _get_auth_token()]
  end
end
