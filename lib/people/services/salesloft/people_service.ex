defmodule People.Salesloft.PeopleService do
  alias People.{
    CacheService,
    Salesloft.HttpService,
    Salesloft.MatchingService
  }

  import People.HttpService, only: [get_body_data: 1]
  import People.StringService, only: [get_character_occurence_map: 1]

  @cache_table :salesloft
  @max_per_page 100
  @total_pages 4

  def _format_responses(responses) do
    responses
    |> Enum.reduce([], fn cur, acc -> acc ++ get_body_data(cur) end)
    |> Enum.map(&_prune_fields(&1))
    |> IO.inspect()
  end

  def get_all() do
    case CacheService.get(@cache_table, :people) do
      nil ->
        records = _http_get_all()
        CacheService.set(@cache_table, :people, records)
        records

      records ->
        records
    end
  end

  def get_email_character_count() do
    get_all()
    |> Enum.reduce("", fn %{"email_address" => email_address}, acc -> acc <> email_address end)
    |> get_character_occurence_map()
  end

  def get_matches() do
    case CacheService.get(@cache_table, :matches) do
      nil ->
        matches = MatchingService.get_matches(get_all())
        CacheService.set(@cache_table, :matches, matches)
        matches

      matches -> matches
    end

  end

  def _http_get_all() do
    1..@total_pages
    |> Enum.map(fn page ->
      Task.async(fn ->
        HttpService.get("people.json", params: [per_page: @max_per_page, page: page])
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> _format_responses()
  end

  def _prune_fields(%{
        "first_name" => first_name,
        "last_name" => last_name,
        "email_address" => email_address,
        "title" => title,
        "crm_id" => crm_id
      }) do
    %{
      "first_name" => first_name,
      "last_name" => last_name,
      "email_address" => email_address,
      "title" => title,
      "crm_id" => crm_id
    }
  end
end
