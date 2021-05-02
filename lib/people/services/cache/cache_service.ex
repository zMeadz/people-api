defmodule People.CacheService do
  use GenServer

  @moduledoc """
  ETS Generic Cache
  """

  @ets_table_names [
    :salesloft
  ]

  @ets_table_settings [
    :named_table,
    :set,
    :public,
    read_concurrency: true,
    write_concurrency: false
  ]

  @log_limit 1_000_000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def get(table, key) do
    case :ets.lookup(table, key) do
      [] -> nil
      [{_key, value}] -> value
    end
  end

  def set(table, key, value) do
    :ets.insert(table, {key, value})
  end

  def delete(table, key) do
    :ets.delete(table, key)
  end

  def init(_) do
    Enum.each(@ets_table_names, fn table ->
      :ets.new(table, @ets_table_settings)
    end)

    {:ok, %{log_limit: @log_limit}}
  end
end
