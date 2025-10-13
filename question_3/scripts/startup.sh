#!/bin/bash
apt-get update
apt-get -y install nginx
cat > /var/www/html/index.html <<'EOF'
<html>
  <body>
    <h1>Hello from GCP app instance</h1>
    <pre>$(curl -s "http://169.254.169.254/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")</pre>
  </body>
</html>
EOF
systemctl restart nginx
