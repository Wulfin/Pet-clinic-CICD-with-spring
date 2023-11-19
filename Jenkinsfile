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
    }
}