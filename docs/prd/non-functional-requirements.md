# Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| **Tech Stack** | Flutter Web (Dart 3.x) frontend; Supabase (Postgres + Edge Functions) backend |
| **Performance** | First Contentful Paint ≤ 2 s on 4G; timer drift ≤ ±1 s per hour |
| **Accessibility** | WCAG 2.2 AA (color contrast, keyboard nav, focus states) |
| **Security** | OWASP Top 10 mitigations; CSP headers; automated Snyk scan |
| **Privacy** | Minimal PII (no names/emails in MVP); user can delete data anytime |
| **Compliance** | HIPAA-aligned encryption & audit logging; BAA with Supabase |
