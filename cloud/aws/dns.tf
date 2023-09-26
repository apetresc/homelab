data "http" "wan_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

data "external" "fetch_subdomains" {
  program = ["bash", "./scripts/fetch_subdomains.sh"]
}

locals {
  ifconfig_co_json = jsondecode(data.http.wan_ip.response_body)
  subdomains_map   = data.external.fetch_subdomains.result
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

resource "aws_route53_record" "subdomain" {
  for_each = local.subdomains_map
  zone_id  = data.aws_route53_zone.apetre_sc.id
  name     = each.value
  type     = "CNAME"

  records = [aws_route53_record.home_apetre_sc.fqdn]
  ttl     = 300
}

