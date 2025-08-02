# Devops & CI/CD

1. GitHub Actions: lint, `dart test`, `flutter analyze`, web build, Supabase migrations check
2. Merge → Cloudflare Pages deploy (static) + `supabase functions deploy` (Edge)
3. Playwright e2e on preview URLs (mobile + desktop)  
   Rollback: “restore previous build” in Cloudflare + `supabase db revert <migration>`
