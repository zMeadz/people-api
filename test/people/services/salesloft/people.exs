defmodule People.Salesloft.PeopleServiceTest do
  use ExUnit.Case
  import Mock

  alias People.Salesloft.PeopleService

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
end
