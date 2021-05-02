defmodule People.StringServiceTest do
  use ExUnit.Case

  alias People.StringService

  test "can get char occurence map" do
    assert StringService.get_character_occurence_map("hello") === %{
             "h" => 1,
             "e" => 1,
             "l" => 2,
             "o" => 1
           }
  end
end
