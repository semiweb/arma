ARMA
====================

ARMA stores and displays data sent by [the_collector](https://github.com/semiweb/the_collector) gem.

## Installation

No need to create a database, ARMA uses SQLite.

Define the following environment variables:

```
ARMA_AUTHORIZATION_KEY -> the authorization key sent with the_collector's requests
ARMA_PASSWORD          -> the password that is used to sign into ARMA (and then a permanent cookie is created)
ARMA_GITHUB_USERNAME   -> your Github username
ARMA_GITHUB_PASSWORD   -> your Github password
ARMA_SECRET_KEY        -> the secret key used by rails in the initializers
```

## Usage

Run the application.

In the_collector's config, set the `uri` to `http://ARMA_URL/collect` and that's it.
Next time you'll restart the application that uses the_collector, ARMA will display the its current state.