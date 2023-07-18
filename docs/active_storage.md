# ActiveStorage and AWS S3 buckets

AWS S3 buckets are used in this Rails application for two main purposes:

### File Uploads

The application uses ActiveStorage for file uploads. In the production environment, these files are stored in an AWS S3 bucket. This is configured in [config/storage.yml](https://github.com/danielpaul/RapidRails/blob/main/config/storage.yml) under the amazon service.

### Sitemap Storage

The application generates a sitemap for SEO purposes. In the production environment, this sitemap is stored in an AWS S3 bucket. This is configured in [config/sitemap.rb](https://github.com/danielpaul/RapidRails/blob/main/config/sitemap.rb).

## Setting up an AWS S3 bucket

Here is how to create and set up an AWS S3 bucket to use on your project:

1. Head over to [AWS](https://aws.amazon.com/s3/) and create an account.

2. Once you're logged in search for "S3" and click the "Buckets" option under the "S3" service.
    ![Search S3](images/search_s3.png)

3. Next, click the "Create bucket" option.
    ![Create Bucket](images/create_bucket.png)

4. Fill in a bucket name, choose your region and then click the "Create bucket" button at the bottom of the screen.
    ![Bucket Options](images/bucket_options.png)

5. Search for "Users" in the search bar and click the option shown below.
    ![Search Users](images/search_users.png)

6. Click "Add users"
    ![Add Users](images/add_users.png)

7. Enter a user name. Something like "active-storage-user" will do. Then hit the "Next" button.
    ![User Details](images/user_details.png)

8. Click the "Attach policies directly" radio button. Then search for the policy named "AmazonS3FullAccess" and check the checkbox. Then hit the "Next" button.
    ![Set Permissions](images/set_permissions.png)

9. Finally click the "Create user" button.
    ![Create User](images/create_user.png)

10. Now click on the user you just created.
    ![Select User](images/select_user.png)

11. Select the "Security credentials" tab. Then scroll down on the page and and click "Create access key" button.
    ![Security Credentials](images/security_credentials.png)
    ![Create Access Key](images/create_access_key.png)

12. Select "Other" and click the "Next" button.
    ![Access Key Options](images/access_key_options.png)

13. After the access key is created you'll be shown the page below. Copy both the access keys.
    ![Retrieve Access Keys](images/retrieve_access_keys.png)

14. Open your `credentials.yml` file add fill in the options shown below with your own credentials.
    ![AWS Credentials](images/aws_credentials.png)

Your AWS S3 bucket is now configured to use with your application. More information about AWS S3 can be found on the [AWS S3 website](https://aws.amazon.com/s3/).
