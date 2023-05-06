
# Setting Up three machines in aws 

## Jenkins Server 
### Jenkins-server pre-lauch
    - image:ubuntu
    - instance type: t2.small
    - keypair: creat your own
    - user data: copy the file (jenkins-setup.sh) to user data that will take care of instaliing java-open-jdk and the jenkins
    - Security group:
        - inbound rules: 
            open port 22 to ssh from your public ip
            open port 8080 from anywhere (to allow github to acees jenkins server to add the webhook which trigerrs jenkins server automatically whenever someone makes a commit)
            open port 8080 to SonarQube security group (as SonarQube will send test results to jenkins)



### Jenkins-server post-lauch    
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
### Nexus-server pre-lauch
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


### Nexus-server post-lauch    
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
### SonarQube pre-lauch
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


### SonarQube post-lauch    
    - You'll have to ssh to the machine ssh -i /path/to/private/key ubuntu@Machine-ip-adress   
    - Run "systemctl sonarqube status" to make sure it is configured 
    - If so  copy the ip adress to the broweser knwonig taht the port is 80
    - On start up go to password and user name are both admin (configured in sonar-setup.sh)

    

# Git Code Migration
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

# Build Job with nexus repo
## setting up the jenkins confs

### Connect Jenkins to Maven
    - (we already installed jdk11 for our jenkins server but for our piline there is no jdk11 supported with maven so will need to ssh to the jenkins server and install jdk8) --> sudo apt install openjdk-8-jdk -y
    ls /user/lib/jvm now you'll see to java versions installed one used by jenkins and the other will be configured to be used by maven in the next step

    - mange jenkins ---> global tool configuration --> add java:
        - set Name= OracleJDK8 (pick you own name)
        - set JAVA_HOME to /usr/lib/jvm/java-8-openjdk-amd64

    - mange jenkins ---> global tool configuration --> add Maven:
        - set Name= MAVEN3 (pick you own name)
        - install automatically --> install from Apache --> version:3.8.6

        - In Jenkinsfile add this:
            tools {
                maven "MAVEN3"
                idk "OracleJDK8"
            }
__NOW Jenkins IS CONNECTED TO MAVEN__  

### Connect jenkins to nexus
we have to store the nexus credintials in jenkins so that jenkins upload the artifact to nexus
    
    - Manage Jenkins --> Manage Credentials --> Jenkins --> Global Credentilas(Unrestricted) --> Add Credentials:
        - Kind: Usename with password
        - Username: put your nexus server user name
        - Password: put your nexus server password
        - ID: nexuslogin (pick you own naming)
        - Description: nexuslogin (pick you own naming)

        - In Jenkinsfile add this: 
            environment {
                NEXUS_VERSION = "nexus3"
                NEXUS_PROTOCOL = "http"
                NEXUS_URL = "172.31.40.209:8081"
                NEXUS_REPOSITORY = "vprofile-release"
                NEXUS_REPOGRP_ID    = "vprofile-grp-repo"
                NEXUS_CREDENTIAL_ID = "nexuslogin"
                ARTVERSION = "${env.BUILD_ID}"
            }      
__NOW JENKINS IS CONNECTED TO THE NEXUS SERVER__

### Connect maven to nexus
we need to coonect maven to nexus so that maven gets the dependencies from nexus
  - pom.xml:
    this a maven conf file and it's project dependant has variable for the nexus repos
  
  - settings.xml:
    thia overall maven setting that contains all variables that it needs to connect to the remote repos
  
  - In Jenkinsfile add this: (already added in the privous step) 
            environment {
                NEXUS_VERSION = "nexus3"
                NEXUS_PROTOCOL = "http"
                NEXUS_URL = "172.31.40.209:8081"
                NEXUS_REPOSITORY = "vprofile-release"
                NEXUS_REPOGRP_ID    = "vprofile-grp-repo"
                NEXUS_CREDENTIAL_ID = "nexuslogin"
                ARTVERSION = "${env.BUILD_ID}"
            } 
   
   - this will tell maven to go to settings.xml to authinticate with nexues using the variables there and the values are passed in the previous steps in the enviroment block
    steps {
        sh 'mvn -s settings.xml -DskipTests install'
    }                

__NOW Maven IS CONNECTED TO THE NEXUS SERVER__


### cinfigure github
  - Manage Jenkins --> Manage Credentials --> Jenkins --> Global Credentilas(Unrestricted) --> Add Credentials:
        - Kind: SSH Username with Private key
        - ID: githublogin (pick you own naming)
        - Description: githublogin (pick you own naming)
        - username: git (pick you own naming)
        - private key --> enter directly here --> put your private key (make sure you put the public key on hit hub)
  - we have to ssh to our jenkins machine:
    1- sudo -i
    2- su - jenkins
    3- git ls-remote -h -- git@github.com:Muhammed-Emam/Continous-Integration-project.git HEAD
    (this will store the github identity permannetly in the machine we can check that by running cat .ssh/known_hosts) 


### Building job
    - new item
        name: vprofile-ci-pipeline (pick you own naming)
        pipline:
            Definition: pipline script from SCM
            SCM: git
            Repository URL: git@github.com:Muhammed-Emam/Continous-Integration-project.git  (put yours)
            Credentials: githublogin (the one we just create in the previous step)
            Branches to build: main (depens onthe the branch your project located)
            Script Path: Jenkinsfile



<!-- ### Add webhook      
    - go to you repostory on github --> rep setting --> webhook --> add webhook:
        -Payload URL: http://ip-of-jenkins-machine:8080/github-webhook/ 
        - Content type: application/jason
    - go to jenkins job  --> configure  --> build trigger --> github hook trigger for GITScm polling -->


 







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



#Congiguring Nexus Repo


