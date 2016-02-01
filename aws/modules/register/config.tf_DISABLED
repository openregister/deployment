resource "template_file" "presentation_config" {
  vars {
    db = "${var.id}"
//    host = "${var.rds_instance}"
    user = "${var.id}_presentation"
    password = "${var.id}_presentation"
  }

  template = <<EOT
server:
  registerDefaultExceptionMappers: false

database:
  driverClass: org.postgresql.Driver
  url: jdbc:postgresql://${host}:5432/${db}
  user: ${db}_readonly
  password: ${password}

  #db connection properties
  initialSize: 1
  minSize: 1
  maxSize: 4

  properties:
    charSet: UTF-8

EOT
}

resource "template_file" "mint_config" {
  vars = {
    db = "${var.id}"
    user = "${var.id}_mint"
    //host = "${var.rds_instance}"
    password = "${var.id}_mint"
  }

  template = <<EOT
database:
  driverClass: org.postgresql.Driver
  url: jdbc:postgresql://$RDS_MINT_END_POINT:5432/$REGISTER_DB_NAME
  user: $REGISTER_DB_NAME
  password: $MINT_USER_PASSWORD

  #db connection properties
  initialSize: 1
  minSize: 1
  maxSize: 4

  properties:
    charSet: UTF-8

server:
  applicationConnectors:
  - type: http
    port: 4567
EOT
}
