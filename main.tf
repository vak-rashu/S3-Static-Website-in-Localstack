provider "aws" {
	secret_key = "test" 
	region = "us-east-1"
	access_key = "test"
}

resource "aws_s3_bucket" "tf_bucket" {
	bucket = "websitebucket"
}

resource "aws_s3_object" "tf_bucket_object" {
	bucket = aws_s3_bucket.tf_bucket.id
	key = "index.html"
	source = "./index.html"
	content_type = "text/html"
	acl = "public-read"
}

resource "aws_s3_bucket_public_access_block" "tf_pab"{
	bucket = aws_s3_bucket.tf_bucket.id 
	
	block_public_acls = false
	block_public_policy = false 
	ignore_public_acls = false
	restrict_public_buckets = false 
}

resource "aws_s3_bucket_policy" "tf_bucketpolicy" {
	bucket = aws_s3_bucket.tf_bucket.id

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
				Sid = "PublicReadGetObject"
				Effect = "Allow"
				Principal = "*"
				Action = "s3:GetObject"
				Resource = "${aws_s3_bucket.tf_bucket.arn}/*" 
		}]
	})
} 

resource "aws_s3_bucket_website_configuration" "tf_bucket_config" {
	bucket = aws_s3_bucket.tf_bucket.id
	
	index_document {
		suffix = "index.html"
	}
} 

resource "aws_route53_zone" "tf_zone" {
	name = "mylocalwebsite.test"  
}

resource "aws_route53_record" "tf_record"{
	zone_id = aws_route53_zone.tf_zone.zone_id
	name = "mylocalwebsite.test"
	type = "A"
	alias {
		name = aws_s3_bucket_website_configuration.tf_bucket_config.website_endpoint
		zone_id = aws_s3_bucket.tf_bucket.hosted_zone_id
		evaluate_target_health = false 
	}
}

output "mylocalwebsite_url"{
	value = aws_route53_record.tf_record.name
}
