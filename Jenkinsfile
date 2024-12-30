/* Requires the Docker Pipeline plugin */
pipeline {
    agent { docker { image 'maven:3.9.9-eclipse-temurin-21-alpine' } }
    // agent { "docker_agent" }
    stages {
        stage('build') {
            steps {
                sh 'mvn --version'
            }
        }
    }
}
