output "id" {
  value = "${aws_db_instance.db.id}"
}

output "instance" {
  value = "${aws_db_instance.db.address}"
}
