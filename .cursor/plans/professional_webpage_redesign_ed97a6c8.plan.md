---
name: Professional Webpage Redesign
overview: Transform the mental health directory with mobile-first focus—ensuring the page works correctly and feels native on phones, while applying a calmer, more professional design system. Most users seeking mental health resources will find them on mobile; the desktop experience should enhance, not drive, the design.
todos: []
isProject: false
---

# Professional Redesign for Mental Health Directory (Mobile-First)

## Design principle: Mobile first

**Primary target**: Phones (320px–480px width). The page must be fully usable, readable, and tappable on small screens before any desktop enhancements. Desktop (≥600px) gets progressive enhancement—more columns, more spacing—but mobile is the baseline.

---

## Current issues

The page ([index.html](index.html)) is a single-file React app (RTL Hebrew, Israel mental health guide). It currently has:

- **Generic palette**: Repeated teal/blue (`#2d5a7b`, `#4a90a4`), gray gradients (`#f5f7fa` → `#c3cfe2`), green (`#52b788`), purple (`#6a1b9a`), red (`#d63447`) with no clear hierarchy.
- **Gradient overuse**: Same `linear-gradient(135deg, ...)` on hero, buttons, category headers, modals, and emergency box.
- **Emoji as UI**: 🌟, 🆘, 📞, 🚨, 📖, ❤️, ✕ used in headings and buttons instead of a consistent icon language.
- **Uniform roundness**: 15px / 20px / 25px on everything (cards, inputs, buttons) creating a “pill template” feel.
- **Flat visual hierarchy**: All cards look identical (white, `2px solid #e0e0e0`, same hover); emergency block and footer don’t feel intentionally distinct.
- **Inline style repetition**: Same hex codes and spacing repeated in dozens of places with no single source of truth.
- **Default typography**: Single system font stack with similar sizes; no scale or personality.

### Mobile / responsive (critical)

- **No mobile focus**: Only one `@media (max-width: 600px)` rule exists (category title font sizes); layout and spacing assume desktop.
- **Oversized padding**: 20px, 30px, 40px used everywhere—on a 320px viewport this wastes space and makes content feel cramped.
- **Fixed min-width grids**: `minmax(320px, 1fr)` on service cards and `minmax(220px, 1fr)` on footer—can force horizontal overflow on narrow screens.
- **Small touch targets**: Buttons/links use 8px padding; tap areas fall below the 44×44px minimum for touch.
- **Category header layout**: `gridTemplateColumns: '1fr auto 1fr'` with inline elements can wrap awkwardly or overflow on small screens.
- **Hero and modals**: Large padding and multi-column layouts; modals may not use full viewport or scroll correctly on mobile.
- **Search input**: Fixed padding and widths—may feel cramped or overflow on small screens.

---

## Design direction

- **Trustworthy and calm**: Mental-health context suggests restraint: solid colors, subtle depth, clear structure.
- **Professional**: Fewer gradients; use them only where they add meaning (e.g. one hero accent) or drop them.
- **Accessible and RTL-safe**: Keep contrast, focus states, and RTL layout; use a Hebrew-friendly font if we add one.
- **Maintainable**: Centralize colors and spacing in CSS variables in the existing `<style>` block so one change updates the whole page.
- **Mobile-first**: Design for 320px width first; add `@media (min-width: 600px)` (or similar) for desktop enhancements. Touch targets ≥44px; no horizontal overflow; single-column where it makes sense.

---

## Proposed changes

### 1. Design tokens (CSS variables)

Add a small design system in the existing `<style>` block in [index.html](index.html) (around lines 10–29):

- **Colors**: Primary (one main blue), primary-dark, accent (e.g. for phone/CTA), danger (crisis), neutral grays (text, borders, backgrounds). Use solid colors; keep at most one subtle gradient for the hero or main CTA.
- **Spacing**: e.g. `--space-xs` through `--space-xl` (4px, 8px, 12px, 16px, 24px, 32px, 40px). Consider `--padding-card-mobile`, `--padding-section-mobile` for mobile-specific values.
- **Touch targets**: `--touch-min: 44px` for minimum tap area (WCAG 2.5.5).
- **Radii**: e.g. `--radius-sm` (6px), `--radius-md` (10px), `--radius-lg` (16px). Reduce pill-style 20–25px to these for a more professional feel.
- **Shadows**: One or two levels (e.g. card, elevated) instead of many ad-hoc values.
- **Typography**: Optional `--font-hebrew` (e.g. Heebo or Rubik from Google Fonts) and a simple scale (--text-sm, --text-base, --text-lg, --text-xl, --text-2xl).

Then replace inline hex codes and magic numbers in the React components with `var(--primary)`, `var(--space-md)`, etc., so the file stays one HTML file but gains a single source of truth.

### 2. Typography

- Keep or add one Hebrew-friendly font (e.g. Heebo) for headings and body; keep system fallback.
- Define a clear type scale (size + weight) for: page title, section titles, category headers, card titles, body, captions. Use the new CSS variables in inline styles (e.g. `fontSize: 'var(--text-lg)'`).
- Slightly increase line-height for body and intro text to improve readability.

### 3. Color and gradients

- **Background**: Replace the full-page gray gradient with a neutral solid or very subtle gradient (e.g. off-white / light gray).
- **Hero**: One clear hero block—either solid primary color or one restrained gradient; ensure contrast for white text.
- **Buttons**: Primary (e.g. “לאתר”, “אתם לא לבד”): solid primary or accent. Secondary (e.g. “מילון מונחים”): outline or muted fill. Crisis/emergency: keep a distinct color (e.g. red) but solid, not gradient.
- **Category headers**: Solid primary or dark variant; no gradient.
- **Cards**: White or near-white background, one border color from the design tokens, one shadow level. Optional: very subtle background difference for “emergency” cards if they appear in the grid.
- **Footer**: Dark solid (e.g. primary-dark or neutral) with no gradient.

This removes the “everything is a gradient” effect and makes the emergency and CTA elements stand out by meaning, not decoration.

### 4. Replace emoji with icons or text

- **Hero title**: Remove 🌟 or replace with a small SVG/icon (e.g. leaf, heart, or simple mark) or text only.
- **Category icons**: DATA uses `cat.icon` (🆘, 📞, 🌐, etc.). Options: (a) keep emoji but style the container so they feel intentional (size, background circle); (b) map categories to Font Awesome classes (already loaded) and render `<i className="fas fa-..." />` instead of emoji.
- **Buttons**: “אתם לא לבד” — use a heart icon from FA instead of ❤️; “מילון מונחים” — use book icon; modal close — use `×` or `fa-times`.
- **Emergency section**: Replace 🚨 with an icon (e.g. `fa-exclamation-triangle`) and ensure the block is styled as the main crisis CTA (color, placement, one clear gradient or solid).

This keeps the interface clear and consistent without relying on emoji in every heading.

### 5. Hierarchy and layout

- **Hero**: Slightly tighter padding and margin; optional small tagline or breadcrumb; make the two buttons clearly primary vs secondary (solid vs outline/muted).
- **Emergency strip**: Keep above search; give it a distinct background (solid danger color or dark), clear typography, and one prominent CTA style so it reads as “act here first.”
- **Search**: Single, clear search box (border from design tokens, one radius, optional icon). No need for a second “credits” card to look like another search panel; consider moving credits to footer or a compact line under the hero.
- **Category blocks**: Keep accordion; use solid header background and one consistent padding scale. Service count badge: use a smaller, muted style so it doesn’t compete with the title.
- **Service cards**: One card style (border, radius, shadow from tokens). Slight hover (e.g. border color or shadow change) without large transform/scale. Phone vs Website vs “More” links: use the same button styles as the rest of the site (primary/accent for main action, secondary for “לאתר” if needed).
- **Footer**: Single disclaimer block with solid background; “עודכן” and any credits in one place.

### 6. Mobile-first layout and responsive behavior

Design and test at 320px first. Add breakpoints only for larger screens.

- **Viewport**: Confirm `<meta name="viewport" content="width=device-width, initial-scale=1.0">` is present (it is).
- **Touch targets**: All tappable elements (buttons, phone links, website links, category accordion headers, search input, modal close) must have min 44×44px touch area—use `min-height: 44px`, `min-width: 44px`, or padding that yields that.
- **Spacing on mobile**: Use smaller padding on narrow viewports (e.g. `--space-sm` / `--space-md` for cards and sections; `--space-lg` / `--space-xl` only on desktop). Add CSS variables like `--padding-card-mobile: 12px` and `--padding-section-mobile: 16px`.
- **Grids**: Service cards—use `minmax(min(100%, 280px), 1fr)` or single column on mobile via `@media (max-width: 599px) { grid-template-columns: 1fr; }`. Footer grid—stack on mobile.
- **Category headers**: On mobile, simplify to a single row or stacked layout (icon + title + badge + chevron) so nothing overflows; avoid complex 3-column grid.
- **Hero**: Reduce padding on mobile; stack buttons vertically if needed so each is full-width and tappable.
- **Modals (intro, terms)**: Full viewport on mobile—use `width: 100%`, `min-height: 100vh`, `overflow-y: auto`. Ensure close button is large and fixed/sticky so it's always tappable.
- **Search**: Full-width on mobile; ensure input doesn't overflow; icon (if any) sized appropriately.
- **Emergency strip**: Must remain prominent and readable on mobile; reduce padding but keep contrast and CTA clear.
- **No horizontal scroll**: Ensure `overflow-x: hidden` on body or main container if needed, and that no fixed-width or min-width element causes overflow at 320px.

### 7. Polish

- **Focus states**: Ensure all interactive elements (buttons, links, search input) have a visible focus outline (e.g. `outline: 2px solid var(--primary)` or similar) for keyboard users.
- **Consistent spacing**: Use the spacing variables between sections and inside cards so the layout breathes and doesn’t feel cramped or random.
- **Modal (intro + terms)**: Same design tokens (background, radius, shadow); close button with icon; typography from the scale. Reduce duplicate gradient blocks inside the intro content (e.g. one styled “crisis” callout instead of two nearly identical boxes).

---

## Implementation approach

- **Scope**: All changes inside [index.html](index.html) only (no new files, no build step). React and DATA stay as-is; only JSX style props and the `<style>` block change.
- **Order (mobile-first)**: (1) Add CSS variables including mobile-specific values (e.g. `--padding-card-mobile`, `--touch-min: 44px`). (2) Fix mobile layout first: single-column grids, touch targets ≥44px, reduced padding at 320px, no horizontal overflow. Test on narrow viewport. (3) Add `@media (min-width: 600px)` overrides for desktop (multi-column, larger padding). (4) Replace colors and radii in sections. (5) Replace emoji with Font Awesome. (6) Focus states and final polish.
- **RTL**: Preserve `dir="rtl"` and existing RTL-friendly layout (e.g. `textAlign: 'right'`, padding/margin sides); ensure any new margins use logical properties or the same RTL-safe approach.

---

## Summary


| Area                | Current                          | After                                                           |
| ------------------- | -------------------------------- | --------------------------------------------------------------- |
| **Mobile**          | Desktop-centric; one media query | Mobile-first; 44px touch targets; no overflow; responsive grids |
| **Colors**          | Many gradients, repeated hex     | CSS variables; mostly solid; one hero gradient optional         |
| **Typography**      | Single stack, similar sizes      | Optional Heebo/Rubik; clear scale (variables)                   |
| **Icons**           | Emoji in titles/buttons          | Font Awesome + text; emoji only if styled                       |
| **Cards / buttons** | 20–25px radius, gradient buttons | Token radii (e.g. 6–16px); solid buttons; touch-friendly        |
| **Hierarchy**       | Flat, same treatment everywhere  | Distinct hero, emergency, content, footer                       |
| **Maintainability** | Inline hex/spacing everywhere    | Variables in one `<style>` block                                |


Result: a calmer, more professional directory that works properly on mobile (primary use case) and scales up to desktop, without a full rewrite or new tooling.