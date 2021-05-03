# People API

This gateway service provides a connection to Salesloft People API.

## Setup

First, install dependencies with `mix deps.get`.

Then, you'll need to make sure you have an access token set up to access the Salesloft service.
Run `cp config/dev.secret.example.exs config/dev.secret.exs` and be sure to fill in a working API key.

Then, start the server with `mix phx.server`.

Checkout the [UI](https://github.com/zMeadz/people-ui) for the best user experience! You may also make calls locally using a tool like [Postman](https://www.postman.com/).

## Authors

Zachary Meadors <zacharymeadors1@gmail.com>
