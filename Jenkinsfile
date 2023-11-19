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
                git 'https://github.com/Aj7Ay/amazon-eks-jenkins-terraform-aj7.git'
            }
        }
        
        stage("Maven Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
    }
}