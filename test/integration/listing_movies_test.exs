defmodule ListingMoviesIntegrationTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias RephinkWeb.Router

  @opts Router.init([])
  test 'listing movies' do
    # response = conn(:get, "/movies")
    conn = conn(:get, "/movies")
    response = Router.call(conn, @opts)
    assert response.status == 200
    assert response.resp_body == "[]"
  end
end
