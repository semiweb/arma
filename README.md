ARMA
====================

ARMA stores and displays data sent by [ZeCollector](https://github.com/semiweb/zecollector) gem.

## Installation

No need to create a database, ARMA uses SQLite.

Define the following environment variables:

```
ARMA_AUTHORIZATION_KEY -> the authorization key sent with ZeCollector's requests
ARMA_GITHUB_USERNAME   -> Github username under which the repository is
ARMA_GITHUB_ACCESS_TOKEN -> your Github personal access token
ARMA_SECRET_KEY        -> the secret key used by rails in the initializers
```

Create a first user to be able to sign in: signing up has been deactivated for now.

```ruby
User.create!(username: 'jonSnow', password: 'password', password_confirmation: 'password')
```

## Usage

Run the application.

In ZeCollector's config, set the `uri` to `http://ARMA_URL/collect` and that's it.
Next time you'll restart the application that uses ZeCollector, ARMA will display its current state.