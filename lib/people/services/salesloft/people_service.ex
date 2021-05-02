defmodule People.Salesloft.PeopleService do
  alias People.Salesloft.HttpService

  import People.HttpService, only: [get_body_data: 1]
  import People.StringService, only: [get_character_occurence_map: 1]

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

  def get_email_character_count() do
    get_all()
    |> Enum.reduce("", fn %{"email_address" => email_address}, acc -> acc <> email_address end)
    |> get_character_occurence_map()
  end

  def _format_responses(responses) do
    Enum.reduce(responses, [], fn cur, acc -> acc ++ get_body_data(cur) end)
  end
end
