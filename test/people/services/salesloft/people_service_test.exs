defmodule People.Salesloft.PeopleServiceTest do
  use ExUnit.Case
  import Mock

  alias People.{
    CacheService,
    Salesloft.PeopleService
  }

  setup do
    on_exit(fn ->
      CacheService.delete(:salesloft, :people)
    end)
  end

  test "can format list of responses" do
    responses = [
      %{
        "data" => [
          %{
            "name" => "one"
          }
        ],
        "metadata" => %{
          "page" => 1
        }
      },
      %{
        "data" => [
          %{
            "name" => "two"
          }
        ],
        "metadata" => %{
          "page" => 1
        }
      }
    ]

    assert PeopleService._format_responses(responses) === [
             %{"name" => "one"},
             %{"name" => "two"}
           ]
  end

  test "can get all people" do
    response = %{
      "data" => [
        %{
          "name" => "one"
        }
      ],
      "metadata" => %{
        "page" => 1
      }
    }

    with_mock HTTPoison,
      get!: fn _url, _headers, _options ->
        %HTTPoison.Response{
          status_code: 200,
          body: Jason.encode!(response)
        }
      end do
      result = PeopleService.get_all()

      assert called(
               HTTPoison.get!(
                 "https://api.salesloft.com/v2/people.json",
                 [Authorization: "Bearer test_token"],
                 params: [per_page: 100, page: 1]
               )
             )

      assert called(
               HTTPoison.get!(
                 "https://api.salesloft.com/v2/people.json",
                 [Authorization: "Bearer test_token"],
                 params: [per_page: 100, page: 2]
               )
             )

      assert called(
               HTTPoison.get!(
                 "https://api.salesloft.com/v2/people.json",
                 [Authorization: "Bearer test_token"],
                 params: [per_page: 100, page: 3]
               )
             )

      assert called(
               HTTPoison.get!(
                 "https://api.salesloft.com/v2/people.json",
                 [Authorization: "Bearer test_token"],
                 params: [per_page: 100, page: 4]
               )
             )

      assert result === [
               %{"name" => "one"},
               %{"name" => "one"},
               %{"name" => "one"},
               %{"name" => "one"}
             ]
    end
  end

  test "can get character count for all available emails" do
    response = %{
      "data" => [
        %{
          "name" => "one",
          "email_address" => "hello@people.com"
        }
      ],
      "metadata" => %{
        "page" => 1
      }
    }

    with_mock HTTPoison,
      get!: fn _url, _headers, _options ->
        %HTTPoison.Response{
          status_code: 200,
          body: Jason.encode!(response)
        }
      end do
      result = PeopleService.get_email_character_count()

      assert result === %{
               "." => 4,
               "@" => 4,
               "c" => 4,
               "e" => 12,
               "h" => 4,
               "l" => 12,
               "m" => 4,
               "o" => 12,
               "p" => 8
             }
    end
  end
end
