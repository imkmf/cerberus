🐶 🐶 🐶

Cerberus is a (WIP) built-to-deploy user service.
It handles registration and authentication, via a GraphQL API.
I've used a couple Elixir/Phoenix auth libraries, but I'm beginning to lean more towards building this out as its own service, and integrating it with the rest of an application in a microservice-style architecture.

It's pretty strongly opinionated-GraphQL is the primary interface, and any additional fields on a user are encouraged to be added in your own fork, if needed.

This might work as part of an [umbrella app](http://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html), but I haven't tested it yet.

<3
