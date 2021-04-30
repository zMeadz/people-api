defmodule PeopleWeb.Salesloft.PeopleController do
  use PeopleWeb, :controller

  alias People.Salesloft.PeopleService

  def index(conn, _params) do
    people = PeopleService.get_all()
    json(conn, people)
  end
end
