defmodule People.SalesloftMatchingTest do
  use ExUnit.Case

  alias People.Salesloft.MatchingService

  test "can get matching configuration" do
    assert MatchingService._get_match_config(:email_address) === 0.9
    assert MatchingService._get_match_config(:first_name) === 0.84
    assert MatchingService._get_match_config(:last_name) === 0.84
  end

  test "can determine potential matches by email address" do
    assert MatchingService._email_matches?(
             %{"email_address" => "jaro_winkler@success.com"},
             %{"email_address" => "jared_winkler@success.com"}
           ) === true

    assert MatchingService._email_matches?(
             %{"email_address" => "jaro_winkler@success.com"},
             %{"email_address" => "timothy_winkler@success.com"}
           ) === false
  end

  test "can determine potential matches by name" do
    assert MatchingService._name_matches?(
             %{"first_name" => "jaro", "last_name" => "winkler"},
             %{"first_name" => "jared", "last_name" => "winklerly"}
           ) === true

    # Matching last but not first fails
    assert MatchingService._name_matches?(
             %{"first_name" => "jaro", "last_name" => "winkler"},
             %{"first_name" => "cassandra", "last_name" => "winkler"}
           ) === false

    # Matching first but not last fails
    assert MatchingService._name_matches?(
             %{"first_name" => "jaro", "last_name" => "winkler"},
             %{"first_name" => "jaro", "last_name" => "sinkerton"}
           ) === false
  end

  test "can determine potential matches by crm id" do
    assert MatchingService._crm_id_matches?(
             %{"crm_id" => "10001234"},
             %{"crm_id" => "10001234"}
           ) === true

    # Must be exact
    assert MatchingService._crm_id_matches?(
             %{"crm_id" => "10001234"},
             %{"crm_id" => "10001235"}
           ) === false
  end

  test "can find matches for record among candidates" do
    record = %{
      "first_name" => "jaro",
      "last_name" => "winkler",
      "crm_id" => "10001234",
      "email_address" => "jaro_winkler@success.com"
    }

    candidates = [
      # name match
      %{
        "first_name" => "jared",
        "last_name" => "winkler",
        "crm_id" => "123091023",
        "email_address" => "jman2000@matchme.com"
      },
      # email_address match
      %{
        "first_name" => "jerome",
        "last_name" => "thompson",
        "crm_id" => "109349834",
        "email_address" => "jared_winklerly@success.com"
      },
      # crm_id match
      %{
        "first_name" => "tommy",
        "last_name" => "bahama",
        "crm_id" => "10001234",
        "email_address" => "tommy_bahama@success.com"
      },
      # non matches
      %{
        "first_name" => "douglas",
        "last_name" => "mcclean",
        "crm_id" => "12p39992",
        "email_address" => "dmcclean@mcleanly.io"
      },
      %{
        "first_name" => "betty",
        "last_name" => "white",
        "crm_id" => "123123123okasdok",
        "email_address" => "bwhite@mforever.com"
      }
    ]

    assert MatchingService._get_record_matches(record, candidates) === [
             Enum.at(candidates, 0),
             Enum.at(candidates, 1),
             Enum.at(candidates, 2)
           ]
  end

  test "can determine matches among a collection" do
    collection = [
      %{
        "first_name" => "jaro",
        "last_name" => "winkler",
        "crm_id" => "10001234",
        "email_address" => "jaro_winkler@success.com"
      },
      # name match
      %{
        "first_name" => "jared",
        "last_name" => "winkler",
        "crm_id" => "123091023",
        "email_address" => "jman2000@matchme.com"
      },
      # email address match
      %{
        "first_name" => "jerome",
        "last_name" => "thompson",
        "crm_id" => "109349834",
        "email_address" => "jared_winklerly@success.com"
      },
      # crm_id match
      %{
        "first_name" => "tommy",
        "last_name" => "bahama",
        "crm_id" => "10001234",
        "email_address" => "tommy_bahama@success.com"
      },
      %{
        "first_name" => "douglas",
        "last_name" => "mcclean",
        "crm_id" => "12p39992",
        "email_address" => "dmcclean@mcleanly.io"
      },
      %{
        "first_name" => "betty",
        "last_name" => "white",
        "crm_id" => "123123123okasdok",
        "email_address" => "bwhite@mforever.com"
      }
    ]

    assert MatchingService.get_matches(collection) === [
             %{
               record: Enum.at(collection, 0),
               matches: [
                 # Should not include self
                 Enum.at(collection, 1),
                 Enum.at(collection, 2),
                 Enum.at(collection, 3)
               ]
             },
             %{
               record: Enum.at(collection, 1),
               matches: [
                 Enum.at(collection, 0)
               ]
             },
             %{
               record: Enum.at(collection, 2),
               matches: [
                 Enum.at(collection, 0)
               ]
             },
             %{
               record: Enum.at(collection, 3),
               matches: [
                 Enum.at(collection, 0)
               ]
             },
             %{
               record: Enum.at(collection, 4),
               matches: []
             },
             %{
               record: Enum.at(collection, 5),
               matches: []
             }
           ]
  end
end
