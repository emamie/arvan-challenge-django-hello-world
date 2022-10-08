//    # https://medium.com/@gustavo.guss/jenkins-building-docker-image-and-sending-to-registry-64b84ea45ee9
// https://octopus.com/blog/jenkins-docker-ecr 
pipeline {
    environment {
        registry = "bourseapp"
    }
    
    agent any  

    stages {

        stage('Clone Infra project') {
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/$VERSION']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'GitLFSPull'], [$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'challengekey', url: 'git@github.com:emamie/arvan-challenge-django-hello-world.git']]])
            }
        }

        stage('Buiild & Deploy Image') {
            steps{
                script {
                    docker.withRegistry('http://192.168.100.100:5000', '') {
                        def app = docker.build(registry + ":$VERSION")
                        app.push()
                    }
                }
            }
        }

        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$VERSION"
            }
        }
    }

    post{
        cleanup {
            cleanWs()
        }
    }

}
