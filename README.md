# Build Production Environment

以下建立環境是假設Ruby & Rails通通都還沒有裝，而且非常乾淨的環境。以下方法目前確定能夠運作的環境是在**ubuntu 16.04 & memory 1.5GB** 的環境下，如果memory太小記得要去mount一個1GB的swap。Deployment方法是基於[Ruby on Rails 實戰聖經](https://ihower.tw/rails/deployment.html)的說明，不過有一些差異，此說明包括設定email功能。

# Before Deployment

1. 先把環境基礎建設處理好
   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y
   sudo dpkg-reconfigure tzdata
   ```
   之後會要你選時區，選**asia-->Taipei**
   ```bash
   sudo apt-get install -y build-essential git-core bison openssl libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3  autoconf libc6-dev libpcre3-dev curl libcurl4-nss-dev libxml2-dev libxslt-dev imagemagick nodejs libffi-dev
   ```
2. 安裝ruby
   ```bash
   sudo apt-get install software-properties-common
   sudo apt-add-repository ppa:brightbox/ruby-ng
   sudo apt-get update
   sudo apt-get install ruby2.3 ruby2.3-dev
   ruby -v
   ```
   ruby -v有  `ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]` 跑出來代表裝好了
   安裝ruby套件工具bundler
   ```bash
   sudo gem install bundler
   ```
   安裝Rails
   ```bash
   sudo gem install rails --no-ri --no-rdoc
   ```

3. 安裝MySQL
   ```bash
   sudo apt-get install mysql-common mysql-client libmysqlclient-dev mysql-server
   ```
   安裝到一半會要你輸入root password，輸入完記住密碼，安裝完後進入mysql的console
   ```bash
   mysql -u root -p
   ```
   之後會要你輸入剛剛安裝的時候打的密碼，輸入後進到console，然後建立一個table給Sprout LMS用
   ```bash
   CREATE DATABASE sprout CHARACTER SET utf8mb4;
   ```
4. 安裝 Nginx + Passenger：用來Deploy用的Tool
   ```bash
   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

   sudo apt-get install -y apt-transport-https ca-certificates

   # Add our APT repository
   sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'

   sudo apt-get update

   # Install Passenger + Nginx
   sudo apt-get install -y nginx-extras passenger
   ```
   然後以下是開啟與關閉nginx的方法
   ```bash
   sudo service nginx start
   sudo service nginx stop
   sudo service nginx restart
   ```

# Deployment

1. Clone **SproutLMS** Project
   
   ```bash
   cd ~
   git clone https://github.com/ChihMin/ilms
   cd ilms
   bundle install
   ```
2. Database setting
   
   編輯 `config/database.yml` ，production那裡設定使用 MySQL:
   
   ```bash
   production:
     adapter: mysql2
     encoding: utf8mb4
     database: sprout
     host: localhost
     username: root
     password: "這裡打你剛剛安裝ＭySQL時設定的密碼"
   ```
3. 新增email設定檔，新增 `config/email.yml` 檔案，並加入以下內容：
   
   ```yml
   production:
     address: "這裡放SMTP的Address"
     port: "25"
     authentication: "plain"
     user_name: "這裡放email address"
     password: "這裡放email address的密碼"
     enable_starttls_auto: true
   ```

4. 編輯 `config/secrets.yml` (在機器上用 `rake secret` 可以隨機產生一個新的 key)：
   
   ```bash
   production:
   		secret_key_base: 放剛剛產生的key
   ```

5. Migrate Datebase schema to mysql2 & precompile assets
   
   ```bash
   RAILS_ENV=production bundle exec rake db:migrate
   RAILS_ENV=production bundle exec rake assets:precompile
   ```

6. 設定Nginx

   編輯 /etc/nginx/nginx.conf，打開以下一行(把這行的註解#拔掉)：
   
   ```
   include /etc/nginx/passenger.conf;
   ```
   
   在 /etc/nginx/nginx.conf最上方新增一行：
   ```
   env PATH;
   ```
   
   新增 `/etc/nginx/sites-enabled/sprout_lms.conf`
   
   ```bash
   server {
     listen 80;
     server_name your_domain.com;

     root /home/deploy/your_project_name/public;

     passenger_enabled on;

     passenger_min_instances 5;

     location ~ ^/assets/ {
   	expires 1y;
   	add_header Cache-Control public;
   	add_header ETag "";
   	break;
      }
   }
   ```
   - root 那裡擺clone下來的project的絕對路徑下的public資料夾，比方說clone 下來在 `/home/chihmin/ilms`，那麼就把這個絕對路徑指向`/home/chihmin/ilms/public`
   - server_name 如果沒有 domain name，就先打這台電腦的IP
     passenger_min_instances 數量就看電腦有多強，代表可以開的process 個數，設定完重新啟動nginx : `sudo service nginx restart`
7. 開啟email worker thread
   這個是用來處理非同步寄信功能用的機制，以下設定方法，安裝 screen，因為這個需要掛在背景執行，所以用screen把城市掛起來
   ```bash
   sudo apt-get install screen
   screen -S email_worker
   RAILS_ENV=production bundle exec rake jobs:work
   ```
   之後 `ctrl + a + d` 就可以把screen 掛在背景執行了
8. 開啟瀏覽器，直接輸入server IP 就好了
