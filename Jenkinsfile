pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: true, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')        
    }


    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git branch: "main", url: "https://github.com/dipankar15/options-iaac.git"
                        }
                    }
                }
            }

        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                dir('artifacts/terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'

                    sh "terraform plan -input=false -out tfplan "
                    sh 'terraform show -no-color tfplan > tfplan.txt'

                   }
              }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           
                
            

           steps {
                dir('artifacts/terraform') {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
              }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                 dir('artifacts/terraform') {
                                script {
                 sh "terraform apply -input=false tfplan"
                     env.VM_IP = sh (returnStdout: true, script: "terraform output -raw options-vm-ip")    
                                                    echo 'VM_IP: ' + env.VM_IP
                                }
                 }             
               
            }
        }
        
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
             dir('artifacts/terraform') {
           sh "terraform destroy --auto-approve"
             }
        }
    }

  }
}

