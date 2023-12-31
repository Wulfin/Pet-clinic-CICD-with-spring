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

        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs ."
            }
        } 

        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage("Build war file"){
            steps{
                sh " mvn clean install -DskipTests"
            }
        }

        stage("Docker Build"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-creds' , toolName: 'docker') {
                            docker.build("saifffff/petclinic")
                            sh "docker push saifffff/petclinic:latest"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds' , toolName: 'docker') {
                            sh "docker push saifffff/petclinic:latest"
                    }
                }
            }
        }

        stage("Deploy Using Docker"){
            steps{
                sh " docker run -d --name petclinic -p 8082:8080 saifffff/petclinic:latest"
            } 
        }
    }
}