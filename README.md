# The Freeman's newspaper

This project is a RESTful Rails App developed to give me experience in the field
of web development as well as in particular the Ruby web framework Rails.

The Freeman's newspaper is an online website of a newspaper where everyone
can post articles and browse other people's content. Posting and browsing
content on the website is completely free of charge.

* [GitHub repo](https://github.com/Pejo-306/freeman-newspaper)
* [Heroku host](https://limitless-forest-89598.herokuapp.com/)

## Getting started
These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites
The most recent build of this project is built with:

```
Ruby 2.4.2
Rails 5.1.6
```

### Installation
First, clone the repository:

```
$ git clone https://github.com/Pejo-306/freeman-newspaper.git
```

Second, install the necessary gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working as intended:

```
$ rails test
```

If all tests pass, then you should be able to run the app on a local server:

```
$ rails server
```

## Running the tests
Tests (whether separate groups or individual ones) can be run via the rails
'test' command (See [Testing Rails Applications](http://guides.rubyonrails.org/testing.html))
for more details:

```
$ rails test # runs all tests
```

Furthermore, this project utilizes the ruby gem 'guard' which allows you to
watch for changes and automatically run tests:

```
$ bundle exec guard
```

## Built with
* [Rails](https://rubyonrails.org/) - The web framework used for this project

## License
All source code in this repository is available under the MIT License.
See [LICENSE](LICENSE) for more details.

