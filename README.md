> Test-Driven APIs with Phoenix and Elixir

Learn how to use fast feedback provided by TDD to better understand some
of the Phoenix and Elixir components while implementing a feature.

We will start by thinking about what we want from our implementation. If
we simply jump into generators, things will probably work, but we will
have a lot of useless code in our codebase, and no understanding of the
layers. Since we want to create an API, we do not need any HTML views or
stylesheets. That's a good place to start:

```
mix phx.new rephink --no-html --no-brunch
```

We don't need a database right now, but we will create one, since we are
going to use it at a later stage. We'll use Phoenix's default database,
`Sqlite`: `mix ecto.create`

Now everything looks fine. We can start thinking about our first
feature.

**Developing a Feature: Listing Movies**

It's time to start thinking about the feature. We should avoid dealing
with the implementation details as much as possible.

**Adding an API Endpoint**

What do we know so far? We'll return a JSON response, which means that
we need a JSON library. We need `Poison`. Let's start by adding the
following dependencies to `mix.exs`:

```
defp deps do
  [
    {:phoenix, "~> 1.3.0"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_ecto, "~> 3.2"},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:sqlite_ecto2, "~> 2.0", only: [:dev, :test]},
    {:faker, "~> 0.8", only: [:dev, :test]},
    {:poison, "~> 2.2"}
  ]
end
```

Next, we'll run `mix deps.get` to get those dependencies.

It's time to create an integration test. Create a `test/integration`
directory and a file named `listing_movies_test.exs` inside it.


### 2017 August Oleg G.Kapranov
