---
name: perf-checklist-nuxt
description: Reusable performance checklist for Nuxt 3 routes (LCP/CLS/INP/TBT). Derived from PSI iterations 1-4 on jeveuxtravailler.com (DEC-016 → DEC-031).
---

# Nuxt 3 Performance Checklist — `{route or feature}`

> Target metrics: LCP ≤ 2.5s mobile, CLS ≤ 0.1, INP ≤ 200ms, TBT ≤ 200ms (PSI mobile @ Slow 4G / 4× CPU).
> Fill `🟢 / 🟡 / 🔴 / N/A` per item. Add `file:line` references when fixing.

## 0. Pre-flight

- [ ] **Primary deterministic metric** defined BEFORE coding (bytes saved, chunks blocked, requests removed, SQL queries removed) — this is the load-bearing success signal
- [ ] **3-5 PSI mobile runs** captured (`https://pagespeed.web.dev/`, 5-min interval) to characterize noise floor — single-run baseline is unfalsifiable (this project: 53 / 82 / 55 on identical build, DEC-030)
- [ ] PSI anonymous API limit (~25/day) noted — for 5+ programmatic runs use the web UI manually OR a Google API key. `npx lighthouse` local ≠ PSI cloud (different throttling, different pool, medians NOT comparable across the two)
- [ ] Lighthouse trace exported (DevTools > Performance > Throttling: Slow 4G + 4× CPU)
- [ ] Coverage report (DevTools > Coverage) — note unused JS/CSS bytes
- [ ] Acceptance threshold defined per metric BEFORE coding — primary deterministic + secondary PSI median, with explicit "if PSI variance dominates, trust deterministic delta" fallback

## 1. Render-blocking critical path

- [ ] No blocking CSS framework loaded for icons (Boxicons, FontAwesome via CDN, etc.) — see DEC-021
- [ ] Inline critical CSS only for above-fold; defer rest via `nuxt.config.ts` `experimental.inlineSSRStyles`
- [ ] Third-party JS (GTM, Klaviyo, Clarity) deferred via `requestIdleCallback` or interaction trigger
- [ ] `preconnect` reserved to **above-fold** origins only; deferred origins use `dns-prefetch` (rule `07-quality/07-preconnect-strategy.md`)
- [ ] No origin in `preconnect`/`dns-prefetch` whose request is never actually fired (`grep`-verify)
- [ ] `<link rel="preload">` on fonts uses **stable public URL** (`/fonts/...`), never hashed `/_nuxt/` path (DEC-020)
- [ ] `<link rel="preload">` `as=` attribute matches resource type (`as="font"` requires `crossorigin`)

## 2. LCP (image / hero)

- [ ] Hero image has `<link rel="preload" as="image" fetchpriority="high">` (DEC-025) — `fetchpriority` is mandatory, not optional
- [ ] Responsive hero uses `imagesrcset` + `imagesizes` in preload (NOT plain `href` — browser preloads largest variant otherwise)
- [ ] Hero `<img>` carries `fetchpriority="high"` `loading="eager"` `decoding="async"`
- [ ] WebP served via `<picture>` + `<source type="image/webp">` (DEC-019, rule `03-image-optimization.md`) — never @nuxt/image unless explicitly needed
- [ ] Explicit `width` + `height` on every `<img>` matching intrinsic dimensions (CLS guard)
- [ ] Below-fold images: `loading="lazy"` `decoding="async"` no `fetchpriority`
- [ ] Video poster points to `.webp` directly (`<picture>` doesn't apply to `<video poster>`)

## 3. CLS

- [ ] Reserved space for async content: skeletons, fixed `min-height`, aspect-ratio boxes
- [ ] `font-display: swap` + matching `@font-face src:` URLs identical to preload URLs (else FOUT + warning)
- [ ] No injected banner/cookie/auth UI shifting layout above the fold (use `<ClientOnly>` + reserved height)
- [ ] No late-loaded ads / iframes without explicit dimensions

## 4. JS bundle size & lazy-loading

- [ ] `pnpm nuxt build` — **zero** `dynamic import will not move module into another chunk` warnings (DEC-028)
- [ ] `grep -rn "from ['\"]firebase/" --include=*.{vue,js,ts}` — every match passes through `useFirebase()` composable (rule `useFirebase()` lazy-init pattern)
- [ ] No top-level `getFirestore()` / `doc(db, …)` in composables → use lazy `await useFirebase()` inside each method (else SSR crash, see fix DEC-…)
- [ ] Firebase auth listeners use one-shot pattern with `unsubscribe()` (rule `04-firebase-auth-listeners.md`) — except `app.vue:setupAuthExpiryWatcher`
- [ ] Marketing routes (`/`, `/entreprises`, `/comment-ca-marche`, `/entreprises/comment-ca-marche`) gated via `shared/marketingRoutes.js` `isMarketingPath()` — single source of truth (DEC-016)
- [ ] Heavy stores (Auth, Candidate, Company) instantiated only on first non-marketing navigation (DEC-016)
- [ ] `<link rel="modulepreload">` Firebase chunks stripped from marketing HTML via `server/plugins/strip-marketing-modulepreload.js` (DEC-029) — verify with `view-source:/`
- [ ] Modulepreload strip signatures live in `shared/firebaseSdkSignatures.js` (single source of truth) — never duplicated inline in plugin or tripwire (DEC-032)
- [ ] Before extending strip signatures: anti-collision scan `grep -rn '<token>' --include=*.{vue,js,ts}` — must match ONLY the SDK chunk filename, never application code (DEC-032)
- [ ] Postbuild tripwire `pnpm postbuild:check` (`scripts/verify-marketing-strip.mjs`) — fails build if any signature leaks into prerendered marketing HTML (DEC-032)
- [ ] Heavy data files (communes JSON, large fixtures) loaded on first interaction, not at boot (#103)
- [ ] Analytics scripts loaded after `requestIdleCallback` AND idempotent (loading guard + existing script detection) — see iteration-2-perf-learnings

## 5. CSS

- [ ] Tailwind purge effective: build CSS < 50 KB gzip on marketing routes
- [ ] No `@apply` chains > 4 levels deep
- [ ] No `transition-all` / `transition: all` (DEC-027). Restrict to specific composited properties: `transform`, `opacity`. Verify the transition actually fires (Vue reactive update + class change), else it's a paint cost for nothing
- [ ] No global `* { transition: ... }` selector
- [ ] Confetti / animation libs scoped to consuming component, not global stylesheet
- [ ] Icons via `lucide-vue-next` (tree-shaken) on public pages (DEC-021); `<box-icon>` only in admin

## 6. Caching & hosting

- [ ] HTML `Cache-Control: public, max-age=0, must-revalidate` (or `s-maxage` if CDN) — never `no-cache` for prerendered routes
- [ ] Assets `_nuxt/*` `Cache-Control: public, max-age=31536000, immutable`
- [ ] Fonts, video posters, social icons under long-term cache headers (#107)
- [ ] Firebase Hosting `firebase.json` — `trailingSlash: false` if SEO canonicals are slash-less (DEC-031); 301 redirects audited for prerendered routes
- [ ] No conflicting redirect rules between `nuxt.config.ts` and `firebase.json`

## 7. SSR / prerender

- [ ] `pnpm nuxt build` succeeds — no `Unexpected token 'default'`, no `Cannot find package`
- [ ] Prerender list in `nuxt.config.ts` `nitro.prerender.routes` matches `sitemap.xml` and `robots.txt` (rule `01-seo-robots-txt.md`)
- [ ] No top-level Firebase / Firestore / sessionStorage call in composables (lazy via `useFirebase()` or guarded by `process.client`)
- [ ] `<ClientOnly>` only where strictly needed (auth UI) — overuse hurts SEO and FCP
- [ ] Hydration mismatches: `0` console errors on first SSR load (DevTools console > Filter "hydration")
- [ ] Routes `ssr: false` (compte-entreprise, admin) do NOT produce a route-specific HTML — they fall back to `200.html`. Verify modulepreload strip on `.output/public/200.html`, not `.output/public/<ssr-false-route>/index.html`

## 8. Render performance (INP / TBT)

- [ ] No expensive sync work in `onMounted` of below-fold components — defer with `IntersectionObserver` `rootMargin: 200px` (DEC-023)
- [ ] No `requestAnimationFrame` loops without throttle / cleanup
- [ ] Long lists virtualized when > 100 rows (`vue-virtual-scroller` or similar)
- [ ] Event handlers debounced for input/scroll (`useDebounceFn` from VueUse)
- [ ] No layout thrashing patterns (read-then-write DOM in same frame)

## 9. Firebase / Firestore quota & perf

- [ ] All `query()` carry `limit()` (rule `03-firebase-resources.md`)
- [ ] Counts via `getAggregateFromServer(count())`, never `getDocs().length`
- [ ] No Firestore call inside `for` loops — batch with `documentId() in [...]` (chunk by 30)
- [ ] Static reference data cached in Pinia store with TTL (5min default)
- [ ] `onSnapshot` always unsubscribed in `onUnmounted`

## 10. Verification & non-regression

- [ ] **Primary success criterion** — deterministic delta confirmed (bytes saved, chunks blocked, requests removed, SQL queries removed). This is the load-bearing signal
- [ ] **Secondary PSI re-run** (5+ runs, mobile, 5-min interval) — declare "real gain" only if **median post-fix > maximum pre-fix**, else: "fix shipped, PSI variance dominates, deterministic delta is the trustable signal"
- [ ] Build artifacts checked: `view-source:/<route>` on prod / preview channel — confirm preload/modulepreload list matches expectation
- [ ] Lighthouse trace re-exported, compared to baseline trace
- [ ] No regression on adjacent routes (run PSI on 2-3 sibling routes)
- [ ] Decision recorded in `aidd_docs/internal/decisions/DEC-XXX-….md` if a non-obvious trade-off was made
- [ ] Project rules updated when a new pattern emerges (e.g. `.claude/rules/03-frameworks-and-libraries/...`)

## Common anti-patterns (rejected)

| Anti-pattern | Why rejected | Reference |
|--------------|--------------|-----------|
| Convert SOME static imports of a heavy dep to dynamic | Single residual static import collapses chunk back into parent — Vite warning is load-bearing | DEC-028 |
| Add `transition-all` for "smooth feel" | No-op when classes don't change OR `v-if` swap; paints non-composited properties | DEC-027 |
| `preconnect` to every external origin "just in case" | Wastes TCP+TLS slots; deferred scripts should `dns-prefetch` only | rule `07-preconnect-strategy.md` |
| `@nuxt/image` for one-off WebP optimization | Adds module + migration cost > native `<picture>` | DEC-019 |
| `loading="eager"` alone on hero | Browser still deprioritizes behind fonts — needs `fetchpriority="high"` on preload | DEC-025 |
| Manual `manualChunks` to split a heavy dep | Splits file count, not runtime cost; chunk still preloaded | DEC-028 |
| Mount-only marketing gating | Skips re-init on SPA navigation — heavy stores never bootstrap | DEC-016 / iteration-2-perf-learnings |
| Single-run PSI as success metric | Lighthouse cloud variance ±29 points run-to-run on identical build | DEC-030, iteration 5 baseline 53/82/55 |
| Strip-plugin signatures duplicated inline | Drift between plugin and tripwire — single source of truth required | DEC-032 |

## Quick verification commands

```bash
pnpm nuxt build 2>&1 | grep -E "(dynamic import|warn|WARN|ERROR)"
pnpm nuxt build 2>&1 | grep -i "modulepreload"
grep -rn "transition-all" --include=*.vue --include=*.css
grep -rn "from ['\"]firebase/" --include=*.{vue,js,ts}
grep -rn "preconnect" nuxt.config.ts
ls -lh .output/public/_nuxt/*.js | sort -k5 -h | tail -10
pnpm postbuild:check                                    # Tripwire: signatures leakage in marketing HTML (DEC-032)
node scripts/verify-marketing-strip.mjs                 # Manual run of the tripwire
```
