# Rephink - Phoenix JWT REST APIs Authentication App

> Software Versions

```
date -u "+%Y-%m-%d %H:%M:%S +0000"
uname -vm
mix hex.info
mix phoenix.new -v
cat mix.lock | grep distillery | cut -d" " -f 3,6 | sed 's/[",]//g'
```

> Environment Variable Definitions

```
# create file .env
touch .env

# file .env:
export DB_DEV="rephink.sqlite3"
export DB_PROD="rephink.sqlite3"
export DB_TEST="test/rephink_test.sqlite3"

source .env
```

> Subdomains With Phoenix

> Phoenix API versioning: URL

API versioning allows you to response with different content, based on
the information sent by the client.

**How to use versions?**

There are a number of approaches that can be used when dealing with
versioned APIs. The most common are:

* Use of the ``Accept`` header (e.g. ``Accept: application/vnd.app.v1+json``
* Embed the version as part of the URL (e.g.  ``http://api.app.tld/v1/user``)

```bash
curl -H "Content-Type: application/json" http://localhost:4000/v1/todos
curl -H "Content-Type: application/json" http://localhost:4000/v2/todos
curl -H "Content-Type: application/json" http://localhost:4000/v3/todos

curl -H "Content-Type: application/json" http://localhost:4000/v1/todos/1
curl -H "Content-Type: application/json" http://localhost:4000/v2/todos/1
curl -H "Content-Type: application/json" http://localhost:4000/v3/todos/1

curl -H "Content-Type: application/json" -X POST -d '{"todo":{"title":"dats da bad guy","completed":false}}' http://localhost:4000/v1/todos
curl -H "Content-Type: application/json" -X POST -d '{"todo":{"title":"Mark I must be psychic","completed":true}}'  http://localhost:4000/v2/todos
curl -H "Content-Type: application/json" -X POST -d '{"todo":{"title":"Al Sharpen got his start on a lie","completed":false}}' http://localhost:4000/v3/todos
```

### 2017 August Oleg G.Kapranov
