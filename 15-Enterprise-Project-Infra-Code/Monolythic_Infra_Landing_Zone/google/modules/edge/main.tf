resource "google_compute_security_policy" "waf" {
  name        = "${var.name_prefix}-waf"
  project     = var.project_id
  type        = "CLOUD_ARMOR"
  description = "Cloud Armor policy with preconfigured OWASP protections for the public application."

  rule {
    action      = "deny(403)"
    priority    = 1000
    description = "Block OWASP SQL injection signatures."

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v33-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = 1100
    description = "Block OWASP cross-site scripting signatures."

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('xss-v33-stable')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = 1200
    description = "Block OWASP local file inclusion signatures."

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('lfi-v33-stable')"
      }
    }
  }

  rule {
    action      = "allow"
    priority    = 2147483647
    description = "Default allow after managed WAF rules."

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}

resource "google_compute_backend_service" "app" {
  name                  = "${var.name_prefix}-https-backend"
  project               = var.project_id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  port_name             = var.backend_port_name
  timeout_sec           = 30
  health_checks         = [var.health_check_id]
  security_policy       = google_compute_security_policy.waf.id

  log_config {
    enable      = var.enable_waf_logging
    sample_rate = 1.0
  }

  backend {
    group           = var.backend_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_managed_ssl_certificate" "app" {
  name    = "${var.name_prefix}-managed-cert"
  project = var.project_id

  managed {
    domains = var.certificate_domains
  }
}

resource "google_compute_ssl_policy" "app" {
  name            = "${var.name_prefix}-ssl-policy"
  project         = var.project_id
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_url_map" "https" {
  name            = "${var.name_prefix}-https-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.app.id
}

resource "google_compute_target_https_proxy" "app" {
  name             = "${var.name_prefix}-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.https.id
  ssl_certificates = [google_compute_managed_ssl_certificate.app.id]
  ssl_policy       = google_compute_ssl_policy.app.id
}

resource "google_compute_global_address" "app" {
  name         = "${var.name_prefix}-lb-ip"
  project      = var.project_id
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.name_prefix}-https-forwarding-rule"
  project               = var.project_id
  ip_address            = google_compute_global_address.app.id
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.app.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_url_map" "http_redirect" {
  name    = "${var.name_prefix}-http-redirect"
  project = var.project_id

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  name    = "${var.name_prefix}-http-redirect-proxy"
  project = var.project_id
  url_map = google_compute_url_map.http_redirect.id
}

resource "google_compute_global_forwarding_rule" "http_redirect" {
  name                  = "${var.name_prefix}-http-forwarding-rule"
  project               = var.project_id
  ip_address            = google_compute_global_address.app.id
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.redirect.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
