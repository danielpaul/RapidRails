# Upgrade

Git provides an easy way to merge changes from RapidRails into your application. This is handy when new features or improvements are added to RapidRails and you'd like to merge them into your application.

1. Navigate to your project in your terminal.

2. Add a remote repository that points to RapidRails.
    > `git remote add rapid-rails https://github.com/danielpaul/RapidRails`

3. You can then merge any changes from RapidRails into the current branch in your project with the following command:
    > `git pull rapid-rails main --allow-unrelated-histories`

4. Resolve any merge conflits, commit your changes and you're all up to date.