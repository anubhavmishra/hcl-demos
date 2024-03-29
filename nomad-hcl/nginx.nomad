job "nginx" {
  datacenters = ["dc1"]
  type = "service"
  group "nginx" {
    count = 2
    task "nginx" {
      driver = "docker"
      config {
        image = "nginx"
        port_map {
          http = 8080
        }
        port_map {
          https = 443
        }
        volumes = [
          "custom/default.conf:/etc/nginx/conf.d/default.conf"
        ]
      }
      template {
        data = <<EOH
          server {
            listen 8080;
            server_name nginx.service.consul;
            location /nginx {
              root /local/data;
            }
          }
        EOH
        destination = "custom/default.conf"
      }
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
        }
      }
    }
  }
}
