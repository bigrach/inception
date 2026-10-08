# User documentation

## Services
There are **3** services:
- **MariaDB** - handles the ***database***
- **WordPress** - handles the ***website files***
- **NGINX** - handles the ***hosting*** and ***certifications***

## Commands 
### Start and stop the project 
In the root repository, you can open the terminal (right click in the folder -> Open in Terminal) and execute `make go`. 

The services will be build and go live automatically. Wait for all services to be created and started. 
```
 ✔ Network inception    Created                                            0.1s 
 ✔ Volume "wordpress"   Created                                            0.0s 
 ✔ Volume "mariadb"     Created                                            0.0s 
 ✔ Container mariadb    Started                                            0.1s 
 ✔ Container wordpress  Started                                            0.0s 
 ✔ Container nginx      Started                                            0.0s 
```

To take a break, use `make stop`. When you want to get back at it, `make start`.

### Access the website
Once everything is live, you can open your internet browser and go to `https:/localhost` to see the website. You can also use the domain name that should be specified in the .env file.  
```
DOMAIN = website.url
```
For example, in this case, you could go to `website.url` and see the website. 

### Edit the website
Once you are on the website, you can add `/wp-admin` to the end of your url to access the administration panel, like this: `website.url/wp-admin`

![WordPress login page](https://kinsta.com/fr/wp-content/uploads/sites/4/2017/12/page-d-administration-de-wordpress.png)

A log in page should appear. Once logged in, the dashboard will be available, and you will be able to edit the website as you wish. 

### Credentials
Use the credentials you will find in the `.env` file in the `srcs` folder. 

``` 
WP_USER = *the login will be written here*
WP_USER_PASSWORD = *the user password will be written here* 
```
For admin access, use the admin credentials. 
```
WP_ADMIN = *the admin login will be written here*
WP_ADMIN_PASSWORD = *the admin password will be written here*
```

### Monitoring the services  
If you want to check how the services are doing, you can `make status` to have more information. You should have three live services after doing `make go`, and there should be a `wordpress` and `mariadb` folder in data. 

