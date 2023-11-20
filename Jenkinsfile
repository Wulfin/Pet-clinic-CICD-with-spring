pipeline {
    agent any 
      
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    
    stages{
        stage('clean workspace'){
             steps{
                 cleanWs()
             }
         }
         
        stage("Git Checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/Wulfin/Pet-clinic-CICD-with-spring.git'
            }
        }
        
        stage("Maven Compile"){
            steps{
                sh "mvn clean compile"
            }
        }

        stage("Sonarqube Analysis "){
            steps{
                script{
                withSonarQubeEnv(credentialsId: 'sonar-token') {
                sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Quality Gate'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }

        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        // stage("Build war file"){
        //     steps{
        //         sh " mvn clean install"
        //     }
        // }

        stage("Docker Build & Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-creds' , toolName: 'docker') {
                            sh "docker build -t petclinic ."
                            sh "docker tag petclinic saifffff/pet-clinic:latest "
                            sh "docker push saifffff/pet-clinic:latest "
                    }
                }
            }
        }

        stage("Deploy Using Docker"){
            steps{
                sh " docker run -d --name petclinic -p 8082:8080 saifffff/pet-clinic:latest "
            } 
        }
        // hooking 6
    }
}