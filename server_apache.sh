#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1> Si se puedo ver esto, es que si funciono :')</h1>" | sudo tee /var/www/html/index.html
# echo "<h1>My Terraform Web ... ya pude chinga </h1>" | sudo tee /var/www/html/index.html