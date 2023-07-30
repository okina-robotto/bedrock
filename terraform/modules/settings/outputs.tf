// this needs to be updated with the list of allowed IPs for staging and preproduction
// right now it's open to the world, once updated it'll lock down the bastion and the test environments
output "dev_ips" {
  value = "0.0.0.0/0"
}
