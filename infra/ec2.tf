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
  res.end(\`
<html>
    <head>
      <title>Sistemas Distribuídos</title>
      <meta charset=\"UTF-8\">
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: white;
          color: black;
          margin: 20px;
          line-height: 1.6;
        }
        h1 {
          text-align: center;
          color: #333;
          font-size: 28px;
        }
        h2 {
          color: #555;
          font-size: 20px;
          margin-top: 20px;
        }
        p {
          font-size: 16px;
          margin-bottom: 15px;
        }
        ul {
          list-style-type: none;
          padding: 0;
        }
        li {
          margin-bottom: 10px;
          font-size: 16px;
        }
        a {
          color: #007bff;
          text-decoration: none;
        }
        a:hover {
          text-decoration: underline;
        }
        .container {
          max-width: 800px;
          margin: 0 auto;
        }
      </style>
    </head>
    <body>
      <div class=\"container\">
        <h1>Sistemas Distribuídos</h1>
        <p>Sistemas distribuídos são sistemas compostos por múltiplos computadores autônomos que se comunicam por meio de uma rede para alcançar um objetivo comum. Esses sistemas são fundamentais em aplicações modernas, como computação em nuvem, bancos de dados distribuídos e sistemas de big data.</p>
        <h2>Características Principais</h2>
        <ul>
          <li><strong>Concorrência</strong>: Múltiplos processos executam simultaneamente, coordenando-se para realizar tarefas.</li>
          <li><strong>Escalabilidade</strong>: Capacidade de expandir o sistema para lidar com maior carga de trabalho.</li>
          <li><strong>Tolerância a Falhas</strong>: Continuidade de operação mesmo com falhas em componentes individuais.</li>
          <li><strong>Transparência</strong>: Ocultação das complexidades da distribuição, como localização e replicação, dos usuários.</li>
        </ul>
        <h2>Recursos para Aprofundamento</h2>
        <p>Para mais informações sobre sistemas distribuídos, consulte os seguintes recursos:</p>
        <ul>
          <li><a href=\"https://pt.wikipedia.org/wiki/Sistema_distribu%C3%ADdo\">Wikipedia: Sistemas Distribuídos</a></li>
          <li><a href=\"https://www.pearson.com/us/higher-education/product/Tanenbaum-Distributed-Systems-Principles-and-Paradigms-2nd-Edition/9780132392273.html\">Distributed Systems: Principles and Paradigms</a></li>
        </ul>
      </div>
    </body>
  </html>
  \`);
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