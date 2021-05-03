defmodule PeopleWeb.Salesloft.PeopleView do
  use PeopleWeb, :view

  def render("api.json", %{data: data}) do
    %{
      data: data,
      code: 200,
      response_id: UUID.uuid1(),
      errors: []
    }
  end

  def render("error.json", %{errors: errors}) do
    %{
      data: [],
      code: 422,
      response_id: UUID.uuid1(),
      errors: errors
    }
  end

  def render("error.json", %{code: code, errors: errors}) do
    %{
      data: [],
      code: code,
      response_id: UUID.uuid1(),
      errors: errors
    }
  end
end
