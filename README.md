# Ravena Bank

A small api to open account

## About

This application has two endpoints, one for create or update an user account and one to list the indications of a given CPF.

* POST /user_accounts;
* GET  /user_accounts/list_indications

## System dependencies

* Postgres - 11.5
* Ruby - 2.6.3

## Getting started

### Setup for development

Install all gems and create the development database for the first time:

```bash
$ bundle install
$ rails db:create db:migrate
```

### Running the server

To run the server locally, run the command:

```
$ rails s
```

You can stop the server by pressing:

```
CTRL + C
```

### Running the tests

Just run the command:

```
$ rspec
```

## Heroku

The app is running on Heroku, so you can test the API using the url https://ravena-bank.herokuapp.com/

## Documentation

Documentation on how to use the API is available [here](https://documenter.getpostman.com/view/3532987/SzmcZdfP).

## Contributing

Contributions are welcome.

To report an issue, go to the [Issues page](https://github.com/acarolinatavares/ravena-bank/issues).

To send a Pull Request an issue, go to the [Pull Requests page](https://github.com/acarolinatavares/ravena-bank/pulls).

#### Committing

Before allowing you to commit your code, [Overcommit](https://github.com/sds/overcommit) will run hooks, such as RuboCop, to the check your code.

Install Overcommit hooks:

```
$ overcommit --sign
$ overcommit --install
```

Now you can commit.

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Made by [Ana Carolina Tavares](https://www.linkedin.com/in/ana-carolina-tavares-4995a734/)

