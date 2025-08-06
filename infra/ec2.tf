data "aws_ami" "amazon_free_tier" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon_free_tier.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  security_groups             = [aws_security_group.lambda_sistemas_distribuidos.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y gcc-c++ make nodejs20 nginx

cat > /etc/nginx/conf.d/node_app.conf << 'END'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
END

systemctl start nginx
systemctl enable nginx

echo "const http = require('http');
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end('<h1>Sistemas Distribuídos</h1>');
});
server.listen(3000, () => {
  console.log('Server running on port 3000');
});" > /home/ec2-user/server.js

nohup node-20 /home/ec2-user/server.js > /dev/null 2>&1 &
EOF

  tags = {
    Name = "nodejs-api-instance"
  }
}

output "instance_public_ip" {
  value       = aws_instance.ec2_instance.public_ip
  description = "IP público da instância EC2 para acessar a API"
}