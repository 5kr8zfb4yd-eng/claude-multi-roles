# MEMORY — UI/UX
# Private memory. Only this role writes here.
# The other roles read via shared/BUS.md, never directly.

## Completed sessions
- 2026-06-25 — ProductCard + ProductGrid built on mock-data.ts (quality gate 8/10).

## Patterns learned
- Keep the data shape in one place (mock-data.ts) so SWE can mirror it 1:1.
- Classify every component into an application role before writing it.

## Technical decisions made
- Card is presentational only; all data arrives via props typed `Product`.

## Unresolved known issues
(none)
