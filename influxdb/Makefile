.PHONY: apply \
	clean

cluster_address:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/influxcloud/admin | tail -n 1), $(error "Couldn't get InfluxCloud cluster address"))

admin_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/influxcloud/admin | head -n 1), $(error "Couldn't get InfluxCloud admin password"))

telegraf_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/influxcloud/telegraf | head -n 1), $(error "Couldn't get InfluxCloud telegraf password"))

grafana_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/influxcloud/grafana | head -n 1), $(error "Couldn't get InfluxCloud grafana password"))

influxdb_configuration.txt: influxdb_configuration.txt.tmpl
	jinja2 \
		-D telegraf_password="$(telegraf_password)" \
		-D grafana_password="$(grafana_password)" \
		$< > $@

apply: influxdb_configuration.txt
	influx \
		-host $(cluster_address) \
		-port 8086 \
		-username influxdb \
		-password "$(admin_password)" \
		-ssl \
		-import -path=$<

clean:
	rm -f influxdb_configuration.txt
