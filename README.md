> Phoenix API versioning: Embed the version as part of the URL

* generate a swagger specification that can be ingested by other
  applications like ``http://petstore.swagger.io``

```
mix phx.new rephink --no-brunch --no-ecto --no-html

rm lib/rephink_web/channels/user_socket.ex
rm lib/rephink_web/controllers/fallback_controller.ex
rm lib/rephink_web/views/changeset_view.ex
rm test/support/channel_case.ex

mix phx.gen.json Todos Todo todos title:string completed:boolean


curl -H "Content-Type: application/json" http://localhost:4000/v1/todos/1
#=> {"title":"MY Task #1","id":1,"completed":true}

curl -H "Content-Type: application/json" http://localhost:4000/v2/todos/1
#=> {"titles":["MY Task #2","Hello, Welcome!"],"id":1,"completed":true}

curl -H "Content-Type: application/json" http://localhost:4000/v3/todos/1
#=> {"title":["MY Task #3","How are your there!"],"id":1,"completed":true}

mix test
```
### 2017 August Oleg G.Kapranov
