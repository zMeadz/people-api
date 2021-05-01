defmodule People.Salesloft.PeopleService do
  alias People.Salesloft.HttpService

  @max_per_page 100
  @total_pages 4

  def get_all() do
    1..@total_pages
    |> Enum.map(fn page ->
      Task.async(fn ->
        HttpService.get("people.json", params: [per_page: @max_per_page, page: page])
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> _format_responses()
  end

  def _format_responses(responses) do
    Enum.reduce(responses, [], fn cur, acc -> acc ++ _get_data(cur) end)
  end

  def _get_data(%{"data" => data}), do: data
end
