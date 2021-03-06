ui = {{cfg.ui}}

backend "{{cfg.backend.storage}}" {
  address = "{{bind.backend.first.sys.ip}}:{{bind.backend.first.cfg.port-http}}"
  path = "{{cfg.backend.path}}"
}

listener "{{cfg.listener.type}}" {
  address = "{{cfg.listener.location}}:{{cfg.listener.port}}"
  cluster_address = "{{cfg.listener.cluster_location}}:{{cfg.listener.cluster_port}}"
  tls_disable = {{cfg.listener.tls_disable}}
}

api_addr = "http://{{sys.ip}}:{{cfg.listener.port}}"
cluster_addr = "http://{{sys.ip}}:{{cfg.listener.cluster_port}}"
