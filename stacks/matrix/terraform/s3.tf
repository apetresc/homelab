data "aws_s3_bucket" "website_bucket" {
  bucket = "apetre.sc"
}

resource "aws_s3_bucket_object" "well-known-server" {
  bucket = data.aws_s3_bucket.website_bucket.bucket
  key = ".well-known/matrix/server"
  acl = "public-read"
  source = "./server"
  etag = filemd5("./server")
}
