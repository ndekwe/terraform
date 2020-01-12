# terraform
This repository holds codes used to provision a distributed and highly available infrastructure on AWS.

## Prerequisites
Having an AWS account and the corresponding access and secret keys.

## Steps
**Step 1**: Download Terraform from terraform.io

Step 2: Unzip the downloaded terraform file

Step 3: Place "terraform" binary on the PATH

Step 4: Clone ndekwe/terraform github project

        $ git clone https://github.com/ndekwe/terraform.git
                
Step 5: Access project directory

        $ cd terraform/
        
Step 6: Initialise terraform in order to get the right provider plugin for the project

        $ terraform init 
        
Step 7: Setup "AWS access" and "AWS secret access" keys on CLI

        $ export AWS_ACCESS_KEY="AWS access key goes here"
        $ export AWS_SECRET_ACCESS_KEY="AWS secret access key goes here"
        
Step 8: Verify the execution plan

        $ terraform plan
        
Step 9: Provision AWS infrastructure resources as well as the state file 

        $ terraform apply
        
In the outpout of this command, terraform will ask you to confirm after it displays "Enter a value".  \
Once you enter 'yes' the provision will start as expected. \
When the provision is over, terraform will display the following information: 

        Apply complete! Resources: x added, 0 changed, 0 destroyed. 
        Outputs:
        elb_dns_name = terraform-asg-advocacy-<"ID">.<"region">.elb.amazonaws.com
   
To make sure the infrastructure has been provisionned as expected, log into AWS console and click on "Instances" to notice newly provisionned EC2. 

Congratulations! You have provisionned a highly available and distributed infrastructure on AWS, via Terraform!

Step 10: Unless you want to keep your infrastructure running, do not forget to destroy it with the following command:
        
        $ terraform destroy
