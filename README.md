> Plug in Elixir

In the `Elixir` world, `Plug` is the specification that enables different
frameworks to talk to different web servers in the `Erlang` VM.
If you are  familiar with `Ruby`, `Plug` tries to solve the same problem
that `Rack` does, just with a different approach.

Understanding the basics of how `Plug` works will make it easier to get up
to speed with `Phoenix`,  and probably any other web framework that is
created for `Elixir`.

**The role of a plug**

You can think of a `Plug` as a *piece of code* that receives a data
structure, does some sort of transformation, and returns this same data
structure, slightly modified. This data structure that a `Plug`
receives and returns is usually called `connection`, and represents
everything that there is to know about a request.

As plugs always receive and return a `connection`, they can be easily
composable, forming what is called a *Plug pipeline*. Actually, that is
what usually happens. We receive a request, then each `plug` transforms
this request a little bit and pass the result to the next plug, until
we get a response.

This `connection` that our plugs will be dealing with all the time is a
simple [Elixir struct][3], called `%Plug.Conn{}` which is [very well
documented][4].

***

![schema plug](plug.png "The schema plug")

***


**The two types of Plugs**

There are two types of `Plug`'s we can have: `Function plugs` and
`Module plugs`.

A **function plug** is any function that receives a `connection` (that
is a `%Plug.Conn{}`) and a set of options, and returns a `connection`
Here is a simple example of a valid `Plug`:

```
def my_plug(conn, opts) do
  conn
end
```

A **Module plug** is any module that implements two function: `init/1`
and `call/2`, like this:

```
module MyPlug do
  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn
  end
end
```

One interesting characteristic of module plugs is that `init/1` is
executed in compile time, while `call/2` happens at run time.

The value returned by `init/1` will be passed to `call/2`, making
`init/1` the perfect place to do any heavy lifting and let `call/2`
run as fast as possible at run time.

**A simple example**

To try to make things more concrete, let’s create a simple application
that uses a plug to handle an http request.

First, create a project with `mix`: `$ mix new rephink`

Then `cd` into the project’s directory and edit `mix.exs` adding `Plug`
and `Cowboy` (the web server) as dependencies:

```
defp deps do
  [
    {:plug, "~> 1.4"},
    {:cowboy, "~> 1.1"}
  ]
end
```

Now run `mix deps.get` to install these dependencies and we should be
good to start.

Our first plug will simply return a "Hello, World!" text:

```
# lib/rephink.ex
defmodule Rephink do
  # The Plug.Conn module gives us the main functions
  # we will use to work with our connection, which is
  # a %Plug.Conn{} struct, also defined in this module.
  import Plug.Conn

  def init(opts) do
    # Here we just add a new entry in the opts map,
    # that we can use in the call/2 function
    Map.put(opts, :my_option, "Hello")
  end

  def call(conn, opts) do
    # And we send a response back, with a status code and a body
    send_resp(conn, 200, "#{opts[:my_option]}, World!")
  end
end
```

To use this plug, open `iex -S mix` and run:

```
Plug.Adapters.Cowboy.http(Rephink, %{}) #=> {:ok, #PID<0.174.0>}
```

Here we use the `Cowboy` adapter, and tell it to use our plug. We also
need to pass an `options` value that will be used by `init/1`.
This should have started a `Cowboy` web server on port 4000, so if you
open `http://localhost:4000` you should see the "Hello, World!" message.

This was simple enough. Let’s just try to make this `plug` a bit smarter
and return a response based on the URL we hit, so if we access:
`http://localhost:4000/Name`, we should see “Hello, Name”.

I said that a `connection` represents everything there is to know about
a request, and that includes the request path. We can just pattern match
on this request path to create the response we want. Let’s change the
`call/2` function to be like this:

```
def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
  send_resp(conn, 200, "Hello, #{name}")
end
```

And that’s it. We pattern match the `connection` to extract just the
information we want, the name, and then send the response we want back
to the web server.

**Pipelines, because one ant is no ant**

### 2017 August Oleg G.Kapranov

[1]: http://www.brianstorti.com/getting-started-with-plug-elixir/
[2]: https://habrahabr.ru/post/306334/
[3]: http://elixir-lang.org/getting-started/structs.html
[4]: https://hexdocs.pm/plug/Plug.Conn.html
