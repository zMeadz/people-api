defmodule People.Salesloft.MatchingService do
  import People.StringService, only: [get_jaro_distance: 2]

  def _get_match_config(key) do
    Application.get_env(:people, :services)[:salesloft][:matching_thresholds][key]
  end

  def get_matches(collection) when is_list(collection) do
    collection
    |> Enum.with_index()
    |> Enum.reduce([], fn {record, index}, acc ->
      acc ++
        [
          %{
            record: record,
            matches: _get_record_matches(record, List.delete_at(collection, index))
          }
        ]
    end)
  end

  def _get_record_matches(record, candidates) when is_list(candidates) and is_map(record) do
    Enum.filter(candidates, fn candidate ->
      _email_matches?(record, candidate) or
        _name_matches?(record, candidate) or
        _crm_id_matches?(record, candidate)
    end)
  end

  def _email_matches?(
        %{"email_address" => record_email_address} = _record,
        %{"email_address" => candidate_email_address} = _candidate
      ) do
    get_jaro_distance(record_email_address, candidate_email_address) >=
      _get_match_config(:email_address)
  end

  def _name_matches?(
        %{"first_name" => record_first_name, "last_name" => record_last_name} = _record,
        %{"first_name" => candidate_first_name, "last_name" => candidate_last_name} = _candidate
      ) do
    get_jaro_distance(record_first_name, candidate_first_name) >= _get_match_config(:first_name) and
      get_jaro_distance(record_last_name, candidate_last_name) >= _get_match_config(:last_name)
  end

  def _crm_id_matches?(
        %{"crm_id" => record_crm_id} = _record,
        %{"crm_id" => candidate_crm_id} = _candidate
      )
      when is_nil(record_crm_id) or is_nil(candidate_crm_id) do
    false
  end

  def _crm_id_matches?(
        %{"crm_id" => record_crm_id} = _record,
        %{"crm_id" => candidate_crm_id} = _candidate
      ) do
    record_crm_id === candidate_crm_id
  end
end
