# Gambe.ro

[gambe.ro](https://www.gambe.ro) is a community of italian programmers built using lobste.rs software.

This code is forked from [journalduhacker.net](https://www.journalduhacker.net) (code [available here](https://gitlab.com/journalduhacker/journalduhacker)). Journalduhacker, in turn, is a fork of [lobste.rs](https://www.lobste.rs) (code [available here](https://github.com/lobsters/lobsters)).

## License

Licensed under the AGPLv3 license. See [LICENSE](https://github.com/gambe-ro/lobsters/blob/develop/LICENSE) for the full license.

## Contributing

Please see the [CONTRIBUTING](https://github.com/gambe-ro/lobsters/blob/develop/CONTRIBUTING.md)
file.

## Setup

* Install [Docker](https://docs.docker.com/get-started/).

* Clone the repository:
  ```bash
  $ git clone https://github.com/gambe-ro/lobsters.git
  $ cd lobsters
  ```

* Define the following environment variables in the file `.env`:
  * `RAILS_ENV`: the environment in which Ruby on Rails will run. It must be one of the following: `development`, `test`, `production`.
  * [`SECRET_KEY_BASE`](https://stackoverflow.com/questions/25426940/what-is-the-use-of-secret-key-base-in-rails-4): a **secret** string used to verify the validity of cookies.
  * `MYSQL_USER`: the MariaDB username (for the user that gambe.ro will use).
  * `MYSQL_PASSWORD`: the MariaDB password.
  * `MYSQL_ROOT_PASSWORD`: the root password for MariaDB (used only for table initialization).
  * `MYSQL_DATABASE`: the MariaDB database name.
  * `SMTP_USERNAME`: the username for the SMTP server (whose address is hardcoded in `config/initializers/email.rb`).
  * `SMTP_PASSWORD`: the password for the SMTP server.

* Apply some manual security tweaks:
  * If you are **deploying** gambe.ro, edit your `.bashrc` (or the equivalent for your shell) and add the following:
  ```bash
  export DOCKER_CONTENT_TRUST=1
  ```
  then run the next steps in a new shell.
  * If you are **developing** gambe.ro, remove the check for `DOCKER_CONTENT_TRUST` from `script/docker-host-security.sh`, and remove `read_only: true` from the `app` container in `docker-compose.yml`.

* Run `scripts/docker-run.sh`:
  ```bash
  $ scripts/docker-run.sh
  ```
  This command will provision two containers: one for the Ruby on Rails server and one for the MariaDB database.

* You should now be able to view the website at `172.20.0.2:8080` (you can change this address from the `docker-compose.yml` file). Moreover, you should be able to login with the `test` account (password is `test`).

## Additional setup steps

* Define your site's name and default domain, which are used in various places, in a `config/initializers/production.rb` or similar file:
  ```ruby
  class << Rails.application
    def domain
      "example.com"
    end
  
    def name
      "Example News"
    end
  end
  
  Rails.application.routes.default_url_options[:host] = Rails.application.domain
  ```

* Put your site's custom CSS in `app/assets/stylesheets/local`.

* In production, set up crontab or another scheduler to run regular jobs:
  ```bash
  */20 * * * * cd /path/to/gambero && env RAILS_ENV=production bundle exec rake ts:index > /dev/null
  ```
## Moderation

On-site tasks are carried out directly on the website. Console tasks are carried out through the Ruby on Rails console in production.
To start the Rails console: `rails c`. To start the Rails console and rollback on exit: `rails c --sandbox`.

### On-site tasks

#### Edit/Delete a story

By clicking the 'edit' button under the story title you can:
* Delete the story
* Edit the URL
* Edit the title
* Add or remove tags
* Edit the body text
* Merge the story into another

#### Delete a comment

Click the 'delete' button next to it.

#### Attach a moderation note to a user

Inside a user profile page, you can write moderation notes for that particular user. Only moderators can see them.

#### Disable invites for a user

Inside a user profile page, click the 'Disable Invites' button at the bottom.
You will be able to re-enable invites by clicking on 'Enable Invites'.

#### Ban a user

Inside a user profile page, click the 'Ban' button at the bottom. You must provide a reason.
You will be able to unban the user by clicking on 'Unban'.

#### Read the latest 10 moderation notes and moderations applied to a user

You can see them inside a user profile page. To see more than 10, you need to use the console.

#### Manage hats requests

Go to /hats/requests.

### Console tasks

A typical command to add a resource is:
```ruby
name_of_resource.create(attribute1: value1, attribute2: value2, ...)
```

To edit a resource first assign it to a variable, edit it and then save:
```ruby
story = Story.find_by(short_id: story_short_id)
story.attribute = new_attribute_value
story.save()
```

To delete a resource (please see [difference between delete and destroy](https://stackoverflow.com/a/22757533/)):
```ruby
story = Story.find_by(short_id: story_short_id)
story.delete() # or story.destroy()
```

Note: all resources can be added, edited and deleted through the console. However, it will be usually used in the following cases:

#### Add/Edit/Disable tag

Available attributes:
* tag: name of the tag
* description: description of the tag
* privileged: if set to true, only moderators can post stories with this tag
* is_media: (?)
* inactive: if set to true, users cannot post stories with this tag anymore
* hotness_mod: (?)
