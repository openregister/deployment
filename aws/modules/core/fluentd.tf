resource "aws_s3_bucket_object" "fluentd_conf" {
	bucket = "openregister.${var.vpc_name}.config"
	key = "fluentd.conf"
	content = "${data.template_file.fluentd.rendered}"
	etag = "${md5(data.template_file.fluentd.rendered)}"
}

data "template_file" "fluentd" {
	template = "${file("templates/fluentd.conf")}"

	vars {
		sumologic_key = "${var.sumologic_key}"
	}
}