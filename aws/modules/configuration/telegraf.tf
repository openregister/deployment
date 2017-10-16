resource "aws_s3_bucket_object" "telegraf_conf" {
  bucket = "openregister.${var.environment_name}.config"
  key = "telegraf.conf"
  content = "${data.template_file.telegraf.rendered}"
  etag = "${md5(data.template_file.telegraf.rendered)}"
}

data "template_file" "telegraf" {
  template = "${file("templates/telegraf.conf")}"

  vars {
    influxdb_server = "${var.influxdb_configuration["server"]}"
    influxdb_password = "${var.influxdb_configuration["password"]}"
    influxdb_database = "${var.influxdb_configuration["database"]}"
    influxdb_username = "${var.influxdb_configuration["username"]}"
    environment = "${var.environment_name}"
  }
}
