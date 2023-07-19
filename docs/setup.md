# Automated Setup

Run the command `bin/setup`. You will be taken through RapidRails custom setup flow. 

The script automates several setup tasks, including installing system and Ruby dependencies, setting up Rails credentials and environment variables, preparing the database and more.

# Manual Setup

### 1. System Dependencies
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [Homebrew](https://brew.sh/) (for macOS users)
- [Bundler](https://bundler.io/)

### 2. Ruby Dependencies: 
`bundle install`

### 3. Rails Credentials & ENV Variables
You can read more about this in our [files documentation]().

### 4. Database Setup
Create a `config/database.yml` file from the `config/database.yml.template` file. 
Replace `rapid_rails` with your database name. 
Then, run `bin/rails db:prepare` to set up the database. You can read more about this in the [rails guides](https://guides.rubyonrails.org/v2.3/getting_started.html#configuring-a-database).

### 5. Other Tasks
Run `bin/rails log:clear tmp:clear` to remove old logs and temp files. Restart the application server using `bin/rails restart`.
