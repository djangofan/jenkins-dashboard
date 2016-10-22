# Jenkins Dashboard (based on build-window project)

Jenkins Dashboard built using [Dashing](http://shopify.github.com/dashing)

## Example



## Getting started

Run `bundle install`.

Edit `config/builds.json` with the configuration for your builds:

```
{
  "jenkinsBaseUrl": "http://localhost:8080",
  "builds": [
    {"id": "Job4", "server": "Jenkins"},
    {"id": "Job1", "server": "Jenkins"},
    {"id": "Job2", "server": "Jenkins"},
    {"id": "Job3", "server": "Jenkins"}
  ]
}
```

Place your API credentials in a `auth.yml` file at the root of the project. 

```
'url': 'http://localhost:8080'
'username': 'jenkins'
'password': '02c73658c32939a03bca45ee4ac53e83'
```

install latest Ruby x64, i used 2.3.1
on Windows: install Ruby dev-kit, to get cygwin
on Windows: setup devtools on your system path
on Windows: gem sources -r https://rubygems.org -a http://rubygems.org
gem install bundle
bundle  (bundle will install dashing for you: see included Gemfile file)

Run `dashing start`.

Runs at `http://localhost:3030/builds` by default.

Run `dashing start -d -p 3031` to run it as a daemon and to specify the port. You can stop the daemon with `dashing stop`.

See https://github.com/Shopify/dashing/wiki for more details.

## Docker support

You can spin up a Docker container with build-window by running:

`docker-compose up -d`

The application will be ready at `http://localhost:3030` (Linux) or at `http://<DOCKER_HOST_IP>:3030` (Windows/OS X).

You can also build the image and run a container separately, but [Docker Compose](https://docs.docker.com/compose/install/) makes this process much simpler.

## Contributing

Pull requests welcome. Run the tests with `rspec`.

## Contributions

Thanks to Max Lincoln ([@maxlinc](https://github.com/maxlinc)) for coming up with the name __Build Window__.
