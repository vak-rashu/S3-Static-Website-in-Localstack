# S3-Static-Website-in-Localstack

I have been using Localstack for a quite a while now and I wondered if it has local wrapper for Terraform and it has exactly that.
Localstack provides a local wrapper for Terraform and to you it you need to write "tflocal" instead of terraform.
tflocal is a local wrapper for terraform and it allows to work just like terraform only it is in our local machine.

In this IaC, using tflocal, I have hosted a website using S3 and Route53.
Though their in no support for Route53 as a DNS Service in their community version of Localstack, and hence the domain that I have configured will not work.
But the S3 website configuration works perfectly fine.
