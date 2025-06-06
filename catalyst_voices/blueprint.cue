version: "1.0.0"
project: {
	name: "voices"
	deployment: {
		on: {
			merge: {}
			tag: {}
		}

		bundle: {
			modules: main: {
				name:    "app"
				version: "0.11.0"
				values: {
					deployment: containers:
					{
						main: {
							image: {
								name: _ @forge(name="CONTAINER_IMAGE")
								tag:  _ @forge(name="GIT_HASH_OR_TAG")
							}
							mounts: {
								config: {
									ref: {
										config: {
											name: "nginx"
										}
									}
									path:    "/etc/nginx/nginx.conf"
									subPath: "nginx.conf"
								}
							}
							ports: {
								http: port: 8080
							}
							probes: {
								liveness: {
									path: "/healthz"
									port: 8080
								}
								readiness: {
									path: "/healthz"
									port: 8080
								}
							}
						}
						metrics: {
							image: {
								name: "nginx/nginx-prometheus-exporter"
								tag:  "1.4"
							}

							ports: {
								metrics: port: 9113
							}

							env: {
								SCRAPE_URI: value: "http://localhost:8080/stub_status"
							}

							mounts: {}
						}
					}

					configs: nginx: data: "nginx.conf": """
						user  nginx;
						worker_processes  1;
						error_log  /var/log/nginx/error.log warn;
						pid        /var/run/nginx.pid;
						events {
						  worker_connections  1024;
						}
						http {
						  include       /etc/nginx/mime.types;
						  default_type  application/octet-stream;
						  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
											'$status $body_bytes_sent "$http_referer" '
											'"$http_user_agent" "$http_x_forwarded_for"';
						  access_log  /var/log/nginx/access.log  main;
						  sendfile        on;
						  keepalive_timeout  65;
						  server {
							listen       8080;
							server_name  localhost;

							# https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/web-cross-origin#background
							# https://drift.simonbinder.eu/platforms/web/#additional-headers
							add_header Cross-Origin-Opener-Policy "same-origin";
							add_header Cross-Origin-Embedder-Policy "require-corp";

							# Enforce browser to always check with server whether the app static files are up-to-date.
							add_header 'Cache-Control' 'must-revalidate';
							expires 1h;
							etag on;

							location / {
							  root   /app;
							  index  index.html;
							  try_files $uri $uri/ /index.html;
							}

							error_page   500 502 503 504  /50x.html;
							location = /50x.html {
							  root   /usr/share/nginx/html;
							}
						  }
						}
						"""

					dns: subdomain: "app"
					route: {
						rules: [
							{
								matches: [
									{
										path: {
											type:  "PathPrefix"
											value: "/"
										}
									},
								]
								target: port: 8080
							},
						]
					}

					service: {
						scrape: true
					}
				}
			}
		}
	}

	release: {
		docker: {
			on: {
				merge: {}
				tag: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}
