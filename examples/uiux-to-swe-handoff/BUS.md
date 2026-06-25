# BUS.md — Event bus shared by all roles
# APPEND-ONLY. Don't modify existing lines.
# Format: [YYYY-MM-DD | ROLE] {what changed}. NEEDS: {role} → {action}

---
## LOG

[2026-06-25 | UIUX] Built ProductCard + ProductGrid on mock-data.ts.
Shape: { id, title, price, imageUrl }. NEEDS: SWE → data.ts with identical
signature, Supabase-backed.

[2026-06-26 | SWE] Implemented lib/data.ts on Supabase, same Product signature.
RLS still open on `products`. NEEDS: Security → review RLS before any real data.
