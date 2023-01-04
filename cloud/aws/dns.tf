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
  ttl     = 300
}

resource "aws_route53_record" "sftp_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "sftp.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "qbittorrent_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "qbittorrent.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "sonarr_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "sonarr.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "radarr_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "radarr.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "lidarr_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "lidarr.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "stash_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "stash.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "whisparr_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "whisparr.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "bazarr_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "bazarr.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "komga_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "komga.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "mylar_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "mylar.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "git_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "git.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "invoice_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "invoice.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "scrutiny_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "scrutiny.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

resource "aws_route53_record" "tube_apetre_sc" {
  zone_id = data.aws_route53_zone.apetre_sc.id
  name    = "tube.apetre.sc"
  type    = "CNAME"

  records = ["home.apetre.sc"]
  ttl     = 300
}

