> Phoenix API versioning: Parameter

* generate a swagger specification that can be ingested by other
  other applications like ``http://petstore.swagger.io``

```
mix phx.new rephink --no-brunch --no-ecto --no-html

rm lib/rephink_web/channels/user_socket.ex
rm lib/rephink_web/controllers/fallback_controller.ex
rm lib/rephink_web/views/changeset_view.ex
rm test/support/channel_case.ex

mix phx.gen.json Todos Todo todos title:string completed:boolean

mix test

curl http://localhost:4000/todos/1?version=v1
curl http://localhost:4000/todos/1?version=v2
curl http://localhost:4000/todos/1?version=v3

curl http://localhost:4000/todos/2?version=v1
curl http://localhost:4000/todos/2?version=v2
curl http://localhost:4000/todos/2?version=v3
```

### 2017 August Oleg G.Kapranov
