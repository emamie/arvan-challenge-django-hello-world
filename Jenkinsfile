//    # https://medium.com/@gustavo.guss/jenkins-building-docker-image-and-sending-to-registry-64b84ea45ee9
// https://octopus.com/blog/jenkins-docker-ecr 

def getAppServers(){
    return [
        "192.168.100.21",
        "192.168.100.22",
        "192.168.100.23",
    ]
}

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

        stage('update app01') {
            steps{
                script {
                    def APP_SERVERS = getAppServers()
                    def PARALLEL_STAGES = [:]
                    for(SERVER in APP_SERVERS){
                        def target_server = SERVER
                        PARALLEL_STAGES[target_server] = {
                            stage(target_server) {
                                sshagent(credentials : ['rsa_key']) {
                                    sh """
                                    ssh -o StrictHostKeyChecking=no debian@${target_server} "
                                        cd infra/app;
                                        docker-compose pull app
                                        docker-compose up -d;
                                        "
                                    """
                                }
                            }
                        }
                        
                    }
                    parallel PARALLEL_STAGES
                }
            }
        }
    }

    post{
        cleanup {
            cleanWs()
        }
    }

}
