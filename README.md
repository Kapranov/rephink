> Phoenix API versioning: Use of the Accept header

* generate a swagger specification that can be ingested by other other
  applications like ``http://petstore.swagger.io``

```
mix phx.new rephink --no-brunch --no-ecto --no-html

rm lib/rephink_web/channels/user_socket.ex
rm lib/rephink_web/controllers/fallback_controller.ex
rm lib/rephink_web/views/changeset_view.ex
rm test/support/channel_case.ex

mix phx.gen.json Todos Todo todos title:string completed:boolean
```
To get it working properly, after adding the lines to ``config.exs``
file, run the following command:

```bash
mix deps.get
mix test
mix phx.routes
mix phx.server
```

```bash
$ iex -S mix
iex> MIME.extensions("application/xml") #=> []

MIME.extensions("application/xml")             #=> []
MIME.extensions("application/vnd.app.v1+json") #=> [:v1]
MIME.extensions("application/vnd.app.v2+json") #=> [:v2]
MIME.extensions("application/vnd.app.v3+json") #=> [:v3]
```

```bash
$ curl -H "Accept: application/vnd.app.v1+json" http://localhost:4000/todos/1
#=> {"title":"MY Task #1","id":1,"completed":true}
$ curl -H "Accept: application/vnd.app.v2+json" http://localhost:4000/todos/1
#=> {"titles":["MY Task #2","Hello, Welcome!"],"id":1,"completed":true}
$ curl -H "Accept: application/vnd.app.v3+json" http://localhost:4000/todos/1
#=> {"title":"Elixir","id":1,"completed":true}
```

> Elixir plug for API [versioning][1]

Add versioning to your Elixir Plug and Phoenix built API's

### 2017 August Oleg G.Kapranov

[1]: https://github.com/sticksnleaves/versionary
[2]: https://stackoverflow.com/questions/42331612/
