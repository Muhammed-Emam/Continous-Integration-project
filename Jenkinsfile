// pipeline {
    
// 	agent any
// /*	
// 	tools {
//         maven "maven3"
//         jdk "OracleJDK8"

//     }
// */	
//     environment {

//         SNAP_REPO = 'vprofile_snapshot'
//         NEXUS_USER = 'admin'
//         NEXUS_PASS = 'admin'
//         RELEASE_REPO = 'vprofile_release'
//         CENTRAL_REPO = 'vpro-maven-central'
//         NEXUSIP = '3.88.70.53'
//         NEXUSPORT = '8081'
// 	    NEXUS_GRP_REPO    = "vprofile-maven-group"
//         NEXUS_LOGIN = "nexuslogin"
        
//         // ARTVERSION = "${env.BUILD_ID}"
//         // NEXUS_LOGIN = 'nexuslogin'
//         // NEXUS_VERSION = "nexus3"
//         // NEXUS_PROTOCOL = "http"
//         // NEXUS_URL = "3.88.70.53:8081"


//     }
	
//     stages{
        
//         stage('BUILD'){
//             steps {
//                 sh 'mvn clean install -DskipTests'
//             }
//             post {
//                 success {
//                     echo 'Now Archiving...'
//                     archiveArtifacts artifacts: '**/target/*.war'
//                 }
//             }
//         }

// 	stage('UNIT TEST'){
//             steps {
//                 sh 'mvn test'
//             }

//         }

// 	stage('INTEGRATION TEST'){
//             steps {
//                 sh 'mvn verify -DskipUnitTests'
//             }
//         }
		
//         stage ('CODE ANALYSIS WITH CHECKSTYLE'){
//             steps {
//                 sh 'mvn checkstyle:checkstyle'
//             }
//             post {
//                 success {
//                     echo 'Generated Analysis Result'
//                 }
//             }
//         }

//         stage('CODE ANALYSIS with SONARQUBE') {
          
// 		  environment {
//              scannerHome = tool 'sonarscanner'
//           }

//           steps {
//             withSonarQubeEnv('sonar-pro') {
//                sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
//                    -Dsonar.projectName=vprofile-repo \
//                    -Dsonar.projectVersion=1.0 \
//                    -Dsonar.sources=src/ \
//                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
//                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
//                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
//                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
//             }

//             timeout(time: 10, unit: 'MINUTES') {
//                waitForQualityGate abortPipeline: true
//             }
//           }
//         }

//         stage("Publish to Nexus Repository Manager") {
//             steps {
//                 script {
//                     pom = readMavenPom file: "pom.xml";
//                     filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
//                     echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
//                     artifactPath = filesByGlob[0].path;
//                     artifactExists = fileExists artifactPath;
//                     if(artifactExists) {
//                         echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version} ARTVERSION";
//                         nexusArtifactUploader(
//                             nexusVersion: NEXUS_VERSION,
//                             protocol: NEXUS_PROTOCOL,
//                             nexusUrl: NEXUS_URL,
//                             groupId: NEXUS_REPOGRP_ID,
//                             version: ARTVERSION,
//                             repository: NEXUS_REPOSITORY,
//                             credentialsId: NEXUS_CREDENTIAL_ID,
//                             artifacts: [
//                                 [artifactId: pom.artifactId,
//                                 classifier: '',
//                                 file: artifactPath,
//                                 type: pom.packaging],
//                                 [artifactId: pom.artifactId,
//                                 classifier: '',
//                                 file: "pom.xml",
//                                 type: "pom"]
//                             ]
//                         );
//                     } 
// 		    else {
//                         error "*** File: ${artifactPath}, could not be found";
//                     }
//                 }
//             }
//         }


//     }


// }




















pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }

    environment {
        SNAP_REPO = 'vprofile_snapshot'
        NEXUS_USER = 'admin'
        NEXUS_PASS = 'admin'
        RELEASE_REPO = 'vprofile_release'
        CENTRAL_REPO = 'vpro-maven-central'
        NEXUSIP = '34.230.41.5'
        NEXUSPORT = '8081'
	    NEXUS_GRP_REPO    = "vprofile-maven-group"
        NEXUS_LOGIN = "nexuslogin"
        SONNARSERVER = 'sonarscanner'
        SONARSCANNER = 'sonarscanner'
        
        // ARTVERSION = "${env.BUILD_ID}"
        // NEXUS_LOGIN = 'nexuslogin'
        // NEXUS_VERSION = "nexus3"
        // NEXUS_PROTOCOL = "http"
        // NEXUS_URL = "3.88.70.53:8081"

        

    }
    stages{
        // stage('Build'){
        //     steps {
        //         sh 'mvn  --global-settings settings.xml -DskipTests install'
        //     }
        //     post {
        //         success {
        //             echo "Now Archiving"
        //             archiveArtifacts artifacts: '**/*.war'
        //         }
        //     }
        // }
        
        stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }

        stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('CODE ANALYSIS with SONARQUBE') {
          
		  environment {
             scannerHome = tool "${SONARSCANNER}"
          }

          steps {
            withSonarQubeEnv("${SONARSERVER}") {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }
          }
        }        

        
    }
}    



// NEXUS_VERSION = "nexus3"
// NEXUS_PROTOCOL = "http"
// NEXUS_URL = "172.31.40.209:8081"
// NEXUS_REPOSITORY = "vprofile-release"
// NEXUS_REPOGRP_ID    = "vprofile-grp-repo"
// NEXUS_CREDENTIAL_ID = "nexuslogin"
// ARTVERSION = "${env.BUILD_ID}"
// NEXUSPORT = '8081'
// NEXUSIP = '172.31.40.209'














