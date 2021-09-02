data "http" "wan_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  ifconfig_co_json = jsondecode(data.http.wan_ip.body)
}

data "aws_route53_zone" "apetre_sc" {
  name         = "apetre.sc."
  private_zone = false
}

resource "aws_route53_record" "home_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "home.apetre.sc"
  type    = "A"

  records = [
    local.ifconfig_co_json.ip
  ]
  ttl = 60
}

resource "aws_route53_record" "paperless_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "paperless.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl = 300
}

