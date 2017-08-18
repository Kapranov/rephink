# Rephink - Phoenix JWT REST APIs Authentication App

```
# Software Versions
date -u "+%Y-%m-%d %H:%M:%S +0000"
uname -vm
mix hex.info
mix phoenix.new -v
cat mix.lock | grep distillery | cut -d" " -f 3,6 | sed 's/[",]//g'

# Environment Variable Definitions
# create file .env
touch .env

# file .env:
export DB_DEV="rephink.sqlite3"
export DB_PROD="rephink.sqlite3"
export DB_TEST="test/rephink_test.sqlite3"

source .env



```


### 2017 August Oleg G.Kapranov
