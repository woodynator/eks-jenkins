pipeline {
   parameters {
        choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the dynamodb table.')
        string(name: 'dynamo', defaultValue : 'dynamotest', description: "dynamoDB table name.")
        // choice(name: 'k8s_version', choices: '1.21\n1.20\n1.19\n1.18\n1.17\n1.16', description: 'K8s version to install.')
        string(name: 'credential', defaultValue : 'aws2', description: "Jenkins credential that provides the AWS access key and secret.")
        // string(name: 'region', defaultValue : 'eu-west-1', description: "AWS region.")

   }

  options {
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
    withAWS(credentials: params.credential, region: params.region)
  }

  agent any

  environment {
    // Set path to workspace bin dir
    // def tfHome = tool name: 'tf'
    // env.PATH = "${tfHome}:${env.PATH}"
    PATH = "${env.WORKSPACE}/bin:${env.PATH}"
    // Workspace kube config so we don't affect other Jenkins jobs
    KUBECONFIG = "${env.WORKSPACE}/.kube/config"

  }

  tools {
    terraform 'tf'
  }

  stages {

    stage('Setup') {
      steps {
        script {
          currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + " " + params.cluster
          plan = params.dynamo + '.plan'

           println "Getting the kubectl and helm binaries..."
          //  (major, minor) = params.k8s_version.split(/\./)
          //  sh """
          //    [ ! -d bin ] && mkdir bin
          //    ( cd bin
          //    # 'latest' kubectl is backward compatible with older api versions
          //    curl --silent -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
          //    curl -fsSL -o - https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar -xzf - linux-amd64/helm
          //    mv linux-amd64/helm .
          //    rm -rf linux-amd64
          //    chmod u+x kubectl helm
          //    ls -l kubectl helm )
          //  """
          //  // This will halt the build if jq not found
          //  println "Checking jq is installed:"
          //  sh "which jq"
        }
      }
    }

 
        stage('tf init plan') {
            when {
                expression { params.action == 'create' }
            }
            steps {
                script {
                    // def tfHome = tool name: 'terraform'
                    // env.PATH = "${tfHome}:${env.PATH}"

                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: params.credential, 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh """
                            terraform init
                            terraform plan -no-color -out ${plan}

                        """
                    }
                }
            }
        }
 
        stage('terraform Apply') {
            when {
                expression { params.action == 'create' }
            }
 
            steps {
                script {
                    // def tfHome = tool name: 'terraform'
                    // env.PATH = "${tfHome}:${env.PATH}"
                    input "Create/update Terraform stack ${params.dynamo} in aws?" 

                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: params.credential, 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """
                        terraform apply -no-color -input=false -auto-approve ${plan}
                       """
                    }
                }
            }
            
        }

        stage('terraform Destroy') {
            when {
                expression { params.action == 'destroy' }
            }
 
            steps {
                script {
                    // def tfHome = tool name: 'terraform'
                    // env.PATH = "${tfHome}:${env.PATH}"
                    input "Destroy Terraform stack ${params.dynamo} in aws?" 

                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: params.credential, 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """
                        terraform destroy -no-color -input=false -auto-approve
                       """
                    }
                }
            }
            
        }
      
    }
}