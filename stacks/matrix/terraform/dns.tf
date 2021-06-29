data "aws_route53_zone" "apetresc" {
  name         = "apetre.sc."
  private_zone = false
}

resource "aws_route53_record" "matrix_record" {
  zone_id = data.aws_route53_zone.apetresc.id
  name = "matrix.apetre.sc"
  type = "CNAME"

  records = ["home.apetre.sc"]
  ttl = 300
}
