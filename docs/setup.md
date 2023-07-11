# Setup Script Configuration

This document provides a guide on how to use the bin/setup script for setting up your Rapid Rails application. The script automates several setup tasks, including installing system and Ruby dependencies, setting up Rails credentials and environment variables, preparing the database, and more.

## Services Required
Before running the script, ensure you have the following services installed:

- Ruby
- Homebrew (for macOS users)
- Bundler

## Script Features
The script performs the following tasks:

1. System Dependencies Installation: If Homebrew is installed, the script will install system dependencies using the brew bundle command.

2. Ruby Dependencies Installation: The script installs Ruby dependencies using Bundler.

3. Rails Credentials & ENV Variables Setup: The script prepares the .env file and Rails credentials file.

4. Database Setup: The script prepares the database.yml file and sets up the database using Rails commands.

5. Other Tasks: The script also removes old logs and temp files, and restarts the application server.

## Manual Setup
If you prefer to perform the setup manually, follow these steps:

1. System Dependencies: Install system dependencies manually using Homebrew or your preferred package manager.

2. Ruby Dependencies: Run bundle install to install Ruby dependencies.

3. Rails Credentials & ENV Variables: Create a .env file from the .env.template file. For Rails credentials, create config/credentials.yml.enc and config/master.key files manually.

4. Database Setup: Create a config/database.yml file from the config/database.yml.template file. Replace rapid_rails with your database name. Then, run bin/rails db:prepare to set up the database.

5. Other Tasks: Run bin/rails log:clear tmp:clear to remove old logs and temp files. Restart the application server using bin/rails restart.

## Configuration
You can enable or disable certain parts of the script by commenting out or uncommenting the relevant sections of the code.

For more detailed information on specific topics, refer to the following documentation:

- [Ruby Installation](https://www.ruby-lang.org/en/documentation/installation/)
- [Homebrew Installation](https://brew.sh/)
- [Bundler Documentation](https://bundler.io/)
- [Rails Database Setup](https://guides.rubyonrails.org/v2.3/getting_started.html#configuring-a-database)
- [Rails Credentials](https://edgeguides.rubyonrails.org/security.html#environmental-security)