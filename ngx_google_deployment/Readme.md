# ngx_google_deployment_mod_C
Fork from [ngx_google_deployment](https://github.com/arnofeng/ngx_google_deployment "ngx_google_deployment").

**Sometgins Important: not avaliable on Centos.**

**Things different from arnonofeng's:**

1. You can specify nginx version.
2. Self signed certificate.

**What**

Install Proxy for Google by Nginx.
This project origins from g.doufu.ru&&g.adminhost.org(can only be accessed by typing the domain).

1. Forbid popular spiders like Google��Baidu;
2. Forbid any illegal referer;
3. Limit frequency of the same IP at 10 times in 1 second;
4. Can only access this site by typing the domian or using bookmarks;
5. If pages show "403 Forbid",try to delete "cookies" in your browser;

And more is to be discovered.

# Important Instruction
* ~~Initial configure does not require SSL/HTTPS.This means you can only access your web by HTTP in the beginning.By the way,you can deploy your SSL/HTTPS upon this project.~~
* Initial configure will auto generate a self-signed ssl certificate
* Configure document is "/usr/local/nginx/conf/nginx.conf".
* Start nginx by using "/usr/local/nginx/sbin/nginx" / ("/usr/local/nginx/sbin/nginx -s reload") / ("/usr/local/nginx/sbin/nginx -s stop").
* You can edit "nginx.conf" by yourself such as "Backend for google.com".

# Things you should do before your deployment
* You should run this project by ROOT user.
* Ensure your Linux did not install nginx before OR has uninstalled it properly.
* Prepare 2 domains/subdomains for "Google Search" and "Google Scholar".

# Usage:

## For Debain/Ubuntu/Centos
* wget -N --no-check-certificate https://github.com/Char1sma/Shell_Collections/raw/master/ngx_google_deployment/ngx_google_deployment.sh 
* chmod +x ngx_google_deployment.sh
* ./ngx_google_deployment.sh install| tee -a ngx_google_deployment.log

## How to change domain
* ./ngx_google_deployment.sh update 
* or modify nginx.conf yourself

# Depend on Projects
* [Nginx](http://nginx.org/)
* [ngx_http_substitutions_filter_module](https://github.com/yaoweibin/ngx_http_substitutions_filter_module)

