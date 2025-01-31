# ronin-app

* [Website](https://ronin-rb.dev)
* [Issues](https://github.com/ronin-rb/docker/issues)
* [DockerHub](https://hub.docker.com/r/roninrb/ronin)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

ronin-app is a small web application that is meant to be ran locally by the
user. It provides a web interface to [ronin-support], [ronin-repos], [ronin-db],
[ronin-payloads], [ronin-exploits], as well as automating
[ronin-nmap], [ronin-masscan], and [ronin-web-spider].

## Features

* Provides a web interface to the [ronin-db].
* Supports automating [nmap] and [masscan] scans and importing their results
  into the [ronin-db].
* Small memory footprint (~184K).
* Fast (~1.251ms response time).

## Requirements

* [libsqlite3][sqlite]
* [redis-server][redis]
* [nmap]
* [masscan]
* [Ruby] >= 3.1.0
* [bundler] >= 2.0.0

## Setup

```shell
$ ./scripts/setup
```

## Start

```shell
$ ./scripts/server
```

Then visit http://localhost:5000/

### docker-compose

```shell
$ docker-compose build --build-arg RONIN_UID=$(id -u) --build-arg RONIN_GID=$(id -g)
$ docker-compose up
```

**Note:** In order for `docker-compose` to use [ronin-db] and [ronin-repos]
files, in `~/.local/share/ronin-db` and `~/.cache/ronin-repos`, the Docker
container user must have the same `UID` and `GID` as the host's user.

## Security

* This app is intended to be ran locally.
* Allow HTML output is escaped with `Rack::Utils.escape_html`.
* Allow HTTP params are validated using [dry-validation].

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin/fork)
2. Clone It!
3. `cd ronin`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

### Development mode

```shell
$ ./scripts server -e development
```

### Directory Structure

* `Gemfile` - defines all gem dependencies.
* `Procfile` - defines the various services of the app that will be started.
* `Procfile.dev` - defines the various services of the app that will be started
  in development mode.
* `config.ru` - The main entry point for `rackup`/`puma`.
* `app.rb` - The main Rack app that contains all of the HTTP routes.
* `workers.rb` - The main entry point for Sidekiq which loads all worker classes
  from `lib/workers/`.
* `config/` - Contains all app configuration files.
* `lib/workers/` - Contains all Sidekiq worker classes.
* `lib/types.rb` - Defines custom [dry-types].
* `lib/schemas/` - Contains common [dry-schema]s for coercing/processing params.
* `lib/validations/` - Contains [dry-validation]s logic for validating
  submitted HTTP params.
* `lib/helpers/` - Contains all Sinatra helper modules which define methods that
  can be called within the views.
* `views/` - Contains all ERB views that are rendered by `app.rb`.
* `public/` - Contains all static assets (images, CSS stylesheets, and
  JavaScript).
* `scripts/` - Contains scripts for setting up or starting the app.

## License

Copyright (C) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-app is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-app is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with ronin-app.  If not, see <http://www.gnu.org/licenses/>.

[sqlite]: https://sqlite.org/
[redis]: https://redis.io/
[nmap]: https://nmap.org/
[masscan]: https://github.com/robertdavidgraham/masscan#readme

[Ruby]: https://www.ruby-lang.org/
[bundler]: https://bundler.io/
[dry-types]: https://dry-rb.org/gems/dry-types/
[dry-schema]: https://dry-rb.org/gems/dry-schema/
[dry-validation]: https://dry-rb.org/gems/dry-validation/

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-nmap]: https://github.com/ronin-rb/ronin-nmap#readme
[ronin-masscan]: https://github.com/ronin-rb/ronin-masscan#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
