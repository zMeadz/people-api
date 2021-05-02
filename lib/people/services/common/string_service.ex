defmodule People.StringService do
  @doc """
   For a given string, get a map where the keys are the unique letters and
   the values are the number of occurences
   e.g. from "hello" we get %{
      "h" => 1,
      "e" => 1,
      "l" => 2,
      "o" => 1
    }
  """
  def get_character_occurence_map(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, &(&1 + 1))
    end)
  end
end
