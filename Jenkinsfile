pipeline {
   parameters {
        string(name: 'credential', defaultValue : 'aws2', description: "Jenkins credential that provides the AWS access key and secret.")
   }

    agent any
    stages {
        stage('tf init plan') {
            steps {
                script {
                    def tfHome = tool name: 'tf'
                    env.PATH = "${tfHome}:${env.PATH}"
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: params.credential, 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh """
                            terraform init
                            terraform plan
                        """
                    }
                }
            }
        }
    }
}