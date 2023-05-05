### Setting Up three machines in aws 

## Jenkins Server 
# Jenkins-server pre-lauch
    - image:ubuntu
    - instance type: t2.small
    - keypair: creat your own
    - user data: copy the file (jenkins-setup.sh) to user data that will take care of instaliing java-open-jdk and the jenkins
    - Security group:
        - inbound rules: 
            open port 22 to ssh from your public ip
            open port 8080 from anywhere (to allow github to acees jenkins server)
            open port 8080 to SonarQube security group (as SonarQube will send test results to jenkins)



# Jenkins-server post-lauch    
    - You'll have to ssh to the machine ssh -i /path/to/private/key ubuntu@Machine-ip-adress   
    - Run "systemctl jenkins status" to make sure jenkins is configured 
    - If so  copy the ip adress to the broweser knwonig taht the port is 8080
    - On start up install the recommened plugins
    - then we will need to install other 6 plugnis:
        - Maven Integration
        - GitHub Integration 
        - Nexus Artifact Integration
        - SonarQube Scanner
        - Slack Notification
        - Build TimeStamp

## Nexus Server 
# Nexus-server pre-lauch
    - image:Amazon Linux2
    - instance type: t2.medium
    - keypair: creat your own
    - user data: copy the file (nexus-setup.sh) --> this will take care of installing:
        - java open-jdk
        - nexus repo
        - creating a systemd service for nexus to we can automatically boot it with systemctl

    - Security group:
        - inbound rules: 
            - open port 22 to ssh from your public ip
            - open port 8081 from your ip
            - open port 8081 from jenkins security group (aritfact will be uploaded to nexus)


# Nexus-server post-lauch    
    - You'll have to ssh to the machine ssh -i /path/to/private/key ec2-user@Machine-ip-adress   
    - Run "systemctl nexus status" to make sure it is configured 
    - If so  copy the ip adress to the broweser knwonig taht the port is 8081
    - On start up go to __(settings > Reposotories > create reposatory)__ we will 4 repos:
        1- maven2 (hosted): to store our artifacts
        2- maven2 (proxy): for depncies which maven needs
                Remote Storage: https://repo1.maven.org/maven2  (or any repo the you would like to associate) 
        3- maven2 (hosted): this where we store our snapshots
                Version Policey: snapshot
        4- maven2 (group) : just to group the three repos                
    
## SonarQube Server 
# SonarQube pre-lauch
    - image:Amazon ubuntu 20
    - instance type: t2.medium
    - keypair: creat your own
    - user data: copy the file (sonar-setup.sh) --> this will take care of installing:
        - sonarqube repo
        - postgress database
        - nginx (for reverse proxy and appling ssh)
        - creating a systemd service for sonarqube to we can automatically boot it with systemctl

    - Security group:
        - inbound rules: 
            - open port 22 to ssh from your public ip
            - open port 80 from your ip (the default is 9090 but we are using 80 here as we acess ngins which redirects to sonar server)
            - open port 80 from jenkins security group (jenkins will upload test results here)


# SonarQube post-lauch    
    - You'll have to ssh to the machine ssh -i /path/to/private/key ubuntu@Machine-ip-adress   
    - Run "systemctl sonarqube status" to make sure it is configured 
    - If so  copy the ip adress to the broweser knwonig taht the port is 80
    - On start up go to password and user name are both admin (configured in sonar-setup.sh)

    

## Git Code Migration
    - Clone my repo to your local host
    - cd to the cloned repo
    - run vim .git/config
    - now change the remote repo put yours instead of mine
    - or alternatively use this command git remote set-url origin /ssh/url/of/your/repo
    - check it was set using cat git/config you should see your repo ssh url now
    - now your using the branch ci-Jenkins if you want to change run __git branch__ then  __checkout main__
    - it'll push every thing to our private repo __"git push origin --all"__ //The --all flag tells Git to push all branches, not just the currently checked-out branch // origin here the repo name // all implies all branches' names
    - (optional) if we want to push changes to specific branch git push -u origin main //origin the remote repo name & main is the remote branch name
    - (Hint) it will upload the code with the state it inhereted from my repo so if you made any changes will not reflect untill you commit and push your own changes
    - (optional if needed) vim ~/.gitconfig & add your github username and password
    - Alternatively run git config --global user.email "your@email.com" & git config --global user.name "github-username"



####
### Prerequisites
- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later

### Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- MySQL
### Database
Here,we used Mysql DB 
MSQL DB Installation Steps for Linux ubuntu 14.04:
- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file :
- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql


