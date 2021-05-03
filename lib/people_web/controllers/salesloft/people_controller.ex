defmodule PeopleWeb.Salesloft.PeopleController do
  use PeopleWeb, :controller

  alias People.Salesloft.PeopleService

  def character_count(%{query_params: %{"field" => "email_address"}} = conn, _) do
    emails = PeopleService.get_email_character_count()
    render(conn, "api.json", data: emails)
  end

  def character_count(%{query_params: %{"field" => other}} = conn, _) do
    render(conn, "error.json",
      errors: ["Character count for field '#{other}' is not currently supported."]
    )
  end

  def character_count(conn, _) do
    render(conn, "error.json", errors: ["Missing valid 'field' parameter"])
  end

  def index(conn, _params) do
    people = PeopleService.get_all()
    render(conn, "api.json", data: people)
  end

  def matches(conn, _params) do
    matches = PeopleService.get_matches()
    render(conn, "api.json", data: matches)
  end
end
