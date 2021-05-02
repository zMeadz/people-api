defmodule PeopleWeb.Salesloft.PeopleController do
  use PeopleWeb, :controller

  alias People.Salesloft.PeopleService

  def character_count(%{query_params: %{"field" => "email_address"}} = conn, _) do
    emails = PeopleService.get_email_character_count()
    json(conn, emails)
  end

  def character_count(%{query_params: %{"field" => other}} = conn, _) do
    resp(conn, 422, "Character count for field '#{other}' is not currently supported.")
  end

  def character_count(conn, _) do
    resp(conn, 422, "Invalid Request")
  end

  def index(conn, _params) do
    people = PeopleService.get_all()
    json(conn, people)
  end
end
