/* Requires the Docker Pipeline plugin */
pipeline {
    agent { "docker_agent" }
    // agent {
    //     docker {
    //         image 'maven:3.9.9-eclipse-temurin-21-alpine'
    //     }
    // }
    stages {
        stage('build') {
            steps {
                // sh 'mvn --version'
                sh("pwd")
                sh("uname -a")
                sh("env")
                sh("docker ps")
            }
        }
    }
}
