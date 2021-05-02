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

  @doc """
  Calculate Jaro distance of 2 strings.
  Converts any non-strings to strings
  """
  def get_jaro_distance(string1, string2) do
    string1 = Kernel.inspect(string1)
    string2 = Kernel.inspect(string2)
    String.jaro_distance(string1, string2)
  end
end
