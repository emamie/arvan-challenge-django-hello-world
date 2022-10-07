 
pipeline {
    environment {
        registry = "192.168.100.100:50000/bourseapp"
    }
    
    agent any  

    stages {

        stage('Clone Infra project') {
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/$VERSION']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'GitLFSPull'], [$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'challengekey', url: 'git@github.com:emamie/arvan-challenge-django-hello-world.git']]])
            }
        }
        
        stage('Building image') {
            steps {
                
                script {
                    sh "docker build -t \$registry:$VERSION --pull --force-rm ./"
                }
            }
        }
        
        // stage('Push images') {
        //     steps{
        //         script {
        //             def server = Artifactory.server 'AQR Docker'
        //             def docker = Artifactory.docker server: server
        //             def image= docker.push registry+":"+version, 'docker'
        //             server.publishBuildInfo image
        //         }
        //     }
        // }
        
        // stage('Upgrade main server') {
        //     steps{
        //         sshagent(credentials : ['jenkins_ssh_user_key']) {
        //             sh """
        //             ssh -o StrictHostKeyChecking=no root@10.10.10.174 "docker pull docker.itc.aqr.ir/private/ghesmat:$VERSION; cd infra/docker-images/mehmansara; sed -i "s/GHESMAT_VERSION=.*/GHESMAT_VERSION=$VERSION/" .env; docker-compose -f docker-compose-replication.yml up -d"
        //             """
        //         }   
        //     }
        // }
        
    }

    post{
        cleanup {
            cleanWs()
        }
    }

}
