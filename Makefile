all:
	@mix deps.get

clean:
	@mix deps.clean --all
	@rm -fr _build
	@mix deps.get
	@mix deps.update --all
	@mix deps.get

deploy:
	@git push -u origin watchlist

repl:
	@iex -S mix

test:
	@mix test

server:
	@iex -S mix phx.server

run:
	@mix phx.server

.PHONY: all clean deploy repl test server run
