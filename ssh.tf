# addign an option for a code with self generated ssh key(without pre generate)




# resource "tls_private_key" "db_private_key" {
#   algorithm = "RSA"
# }

# locals {
#   public_key_content1 = tls_private_key.db_private_key.public_key_openssh
# }

# resource "tls_private_key" "web_private_key" {
#   algorithm = "RSA"
# }

# locals {
#   public_key_content2 = tls_private_key.web_private_key.public_key_openssh
# }

# resource "local_file" "db_key" {
#   content  = tls_private_key.db_private_key.private_key_pem
#   filename = "./modules/data_base/db-ssh-key"
# }

# resource "local_file" "web_key" {
#   content  = tls_private_key.web_private_key.private_key_pem
#   filename = "./modules/web_vm/web-ssh-key"
# }
