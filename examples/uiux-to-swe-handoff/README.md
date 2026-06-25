# Example — UI/UX → SWE handoff

This is the canonical claude-multi-roles loop: one role does focused work, writes a
contract to the bus, and the next role picks it up cold — no meeting, no re-briefing.

## Session 1 — UI/UX (role 2)

```bash
./multiroles      # Role > 2   →   MCP: none
```

The role reads its `ROLE.md`, `MEMORY.md`, and the shared state, then builds a
product card against mock data, keeping the data shape explicit:

```tsx
// lib/mock-data.ts
export type Product = { id: string; title: string; price: number; imageUrl: string }
export const products: Product[] = [/* … */]
```

At session end the `Stop` hook runs the quality gate (8/10), updates the role's
private memory ([`uiux.MEMORY.md`](./uiux.MEMORY.md)), and appends one line to the
shared bus ([`BUS.md`](./BUS.md)):

```
[2026-06-25 | UIUX] Built ProductCard + ProductGrid on mock-data.ts.
Shape: { id, title, price, imageUrl }. NEEDS: SWE → data.ts with identical
signature, Supabase-backed.
```

It then writes `commands/next-session-uiux.md` and proposes a commit.

## Session 2 — SWE (role 3)

```bash
./multiroles      # Role > 3   →   MCP: supabase
```

SWE opens `BUS.md` at startup and already knows the contract. It implements
`lib/data.ts` with the **exact same signature** as `mock-data.ts`, backed by
Supabase — so not a single line of JSX changes:

```ts
// lib/data.ts — same Product type, real source
export async function getProducts(): Promise<Product[]> {
  const { data } = await supabase.from('products')
    .select('id, title, price, image_url')
  return data!.map(r => ({ ...r, imageUrl: r.image_url }))
}
```

SWE broadcasts back when done, and the relay continues.

## Why it works

The UI/UX role never had to know about Supabase, and the SWE role never had to read
UI/UX's private notes — the **only** shared surface was one append-only line. That's
the whole pattern: durable, auditable, deadlock-free handoffs.
