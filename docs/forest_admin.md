# Admin with Forest Admin

We use [Forest Admin](https://www.forestadmin.com/) as the admin panel for our data. We have a lot of things setup for you to start using Forest Admin staright away.

You can configure Forest Admin for your project as follows:

1. Head over to [Forest Admin](https://www.forestadmin.com/)  and create a free account.

2. Once you're logged in you will be brought to a dashboard page. Click the "Get started" button on the "Advanced setup" side.
    ![Get started](images/advanced_setup.png)

3. Next hit "Get started" in the "Inside my own app" side" of the page.
    ![Inside my own app](images/inside_my_own_app.png)

4. Next select "Ruby on Rails" as the framework you are using.
    ![Select framework](images/select_framework.png)

5. Now you'll enter a configuration wizard. Click thorugh the wizard until your reach the "Install" page. Copy only the env secret key and paste this in your `credentials.yml` as your forest_admin env_secret.
    ![env secret](images/env_secret.png)

6. Run `rails dev:cache` in your terminal inside your project directory.

7. Complete the wizard and run `bin/dev`. Ta-da 🥳. All done. You will now see your admin panel on Forest Admin.

For more information about configuration and customization see the [Forest Admin documentation](https://docs.forestadmin.com/documentation/).
 