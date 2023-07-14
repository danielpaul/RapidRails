# Setup Script Configuration

This document provides a guide on how to use the `bin/setup` script for setting up your RapidRails application. The script automates several setup tasks, including installing system and Ruby dependencies, setting up Rails credentials and environment variables, preparing the database and more.

## Services Required

Before running the script, ensure you have the following services installed:

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [Homebrew](https://brew.sh/) (for macOS users)
- [Bundler](https://bundler.io/)

## Script Features

The script performs the following tasks:

1. System Dependencies Installation: If Homebrew is installed, the script will install system dependencies using the brew bundle command.

2. Ruby Dependencies Installation: The script installs Ruby dependencies using Bundler.

3. Rails Credentials & ENV Variables Setup: The script prepares the .env file and Rails credentials file.

4. Database Setup: The script prepares the database.yml file and sets up the database using Rails commands.

5. Other Tasks: The script also removes old logs and temp files, and restarts the application server.

## Manual Setup

If you prefer to perform the setup manually, follow these steps:

1. System Dependencies: Install system dependencies manually using [Homebrew](https://brew.sh/) or your preferred package manager.

2. Ruby Dependencies: `bundle install`

3. Rails Credentials & ENV Variables: You can read more about this in our [files documentation]().

4. Database Setup: Create a config/database.yml file from the config/database.yml.template file. Replace rapid_rails with your database name. Then, run `bin/rails` db:prepare to set up the database. You can read more about this in the [rails guides](https://guides.rubyonrails.org/v2.3/getting_started.html#configuring-a-database).

5. Other Tasks: Run `bin/rails log:clear tmp:clear` to remove old logs and temp files. Restart the application server using `bin/rails restart`.
