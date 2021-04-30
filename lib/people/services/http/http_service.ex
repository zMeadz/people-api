defmodule People.HttpService do
  def get(url, headers \\ [], options \\ []) do
    url
    |> HTTPoison.get!(headers, options)
    |> _get_response_body()
  end

  def _get_response_body(%HTTPoison.Response{body: body}) do
    Jason.decode!(body)
  end
end