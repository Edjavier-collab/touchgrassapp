# Security & Compliance

• TLS 1.3 via Cloudflare, HSTS enabled
• AES-256-GCM disk encryption (Supabase)
• Anon JWT expires 24 h; silent refresh
• Edge middleware logs `event_type`, `actor_id`, hashed IP
• Snyk in CI, monthly OWASP ZAP passive scan
