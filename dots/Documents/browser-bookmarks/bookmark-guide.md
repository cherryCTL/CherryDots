# Bookmark Guide

> **Guide version:** `1.0.0`  
> **Purpose:** The authoritative editing, naming, categorisation, exception, and versioning rules for the General and NSFW bookmark collections.

This guide is the source of truth for maintaining the bookmark files. Read it before editing, reorganising, importing, or rebuilding either collection. Browser-exported HTML files are data; this guide defines how that data must be managed.

---

## 1. File names and versioning

Maintain two independent bookmark collections. Each collection has its own semantic version and its own change-log entries.

### Canonical file names

Use these exact patterns, including the `.html` extension:

- General: `bookmarks-vMAJOR.MINOR.PATCH.html`
- NSFW: `bookmarksNSFW-vMAJOR.MINOR.PATCH.html`

Examples:

- `bookmarks-v1.0.0.html`
- `bookmarksNSFW-v1.0.0.html`
- `bookmarks-v1.2.0.html`
- `bookmarksNSFW-v1.1.1.html`

Do not use dates, `final`, `new`, `latest`, or other extra suffixes in managed filenames. Do not give both collections one shared version: update each collection's version independently according to the changes made to that collection.

### Semantic version rules

Use `MAJOR.MINOR.PATCH`:

| Part | Increase it when… | Example |
|---|---|---|
| `PATCH` | Fixing a typo, improving a description without changing its meaning, correcting a title, or fixing a URL while keeping the same destination. | `1.0.0` → `1.0.1` |
| `MINOR` | Adding or removing a bookmark, adding a category, moving bookmarks between categories, or making a backward-compatible organisational change. | `1.0.1` → `1.1.0` |
| `MAJOR` | Making a breaking structural change, changing the collection split or naming/category rules, or performing a major reorganisation that makes the previous structure incompatible. | `1.9.0` → `2.0.0` |

- Start each newly managed collection at `1.0.0` unless an existing, documented version is supplied.
- Never downgrade a version.
- Never reuse a version number for different contents.
- If a change affects both collections, update both versions independently and record both in the Change Log.
- A guide-only clarification does not automatically require a bookmark collection version increase. Increase the Guide version separately when its rules materially change.

---

## 2. Bookmark title format

Every bookmark title must use this exact format:

`English Website Name — توضیح کوتاه فارسی درباره کاربرد سایت`

Examples:

- `YouTube — پلتفرم اشتراک‌گذاری و تماشای ویدئو`
- `Reddit — انجمن‌های آنلاین برای گفتگو و اشتراک‌گذاری محتوا`
- `Modrinth — مخزن دانلود و انتشار مادهای Minecraft`
- `Excalidraw — ابزار آنلاین طراحی و ترسیم دیاگرام`

### Naming rules

1. Write the website or product name in English, using its recognisable official spelling.
2. Add an em dash (`—`) after the English name.
3. Write the description in Persian.
4. Describe what the website actually provides. Do not use vague descriptions such as `سایت مفید`, `ابزار آنلاین`, `سرگرمی`, or `وب‌سایت کاربردی` on their own.
5. Keep the description concise, but informative enough that the user can identify the site's purpose without opening it.
6. Do not turn the description into an advertisement or include unsupported quality claims.
7. Use the product name rather than a generic category as the English title. For example, use `GitHub`, not `Code Website`.
8. If two bookmarks belong to the same service but lead to meaningfully different pages or tools, distinguish their titles by page purpose, such as `HentaiRead Search — ...` and `HentaiRead Search 2 — ...`.
9. Keep the displayed website name and Persian description consistent across both collections if the same site is intentionally listed in both.

---

## 3. Category rules

Use browser bookmark folders as categories. Category names must be in English, short, descriptive, and consistent. Put each bookmark in the single most relevant category; avoid duplicate copies in multiple folders unless the user explicitly requests them.

### General collection: approved categories

Use the following categories when relevant. Reuse an existing category rather than creating a near-duplicate with a different name.

| Category | What belongs here |
|---|---|
| `Gaming` | PC and console games, game downloads, game communities, ROMs, emulation, fan patches, and game-related services. |
| `Minecraft` | Minecraft launchers, mod platforms, resource packs, servers, maps, skins, and Minecraft-specific tools. |
| `Anime` | Anime catalogues, anime streaming, manga/anime tracking, and anime-specific communities that are not adult-only. |
| `Wallpapers` | Desktop/mobile wallpapers, live wallpapers, backgrounds, and wallpaper galleries. |
| `Social & Media` | General social networks and user-generated media platforms, including video/photo sharing and discussion networks. |
| `Messaging` | Messaging services and their web clients. |
| `AI Tools` | General-purpose AI assistants, AI chat services, and AI creation/agent tools. Put specialised AI products in a more specific existing category only when their primary purpose clearly belongs there. |
| `Linux & Development` | Linux distributions, package/app repositories, source-code hosting, developer platforms, programming tools, and Linux resources. |
| `Browser & Development` | Browser add-on stores, browser-specific tools, browser debugging, and browser development resources. |
| `Search` | General-purpose search engines and search portals. |
| `Resources` | General-purpose resource directories, curated indexes, reference collections, and discovery hubs that do not fit a more specific category. Pawchive is an explicit exception; see §4. |
| `File Hosting` | File, image, and media upload/hosting or file-sharing services. |
| `Learning` | Courses, tutorials, educational libraries, documentation/training sites, and structured learning services. |
| `Video & Audio` | General video-on-demand, TV/catch-up services, media libraries, and sound-effect resources. Do not put general social video networks here when `Social & Media` is more appropriate. |
| `Music` | Music streaming, music discovery, instrument tabs/sheets, music creation, and music-production services. |
| `Productivity` | Email, calendars, meetings, task management, notes, and general work/productivity services. |
| `Art & Creativity` | Creative reference collections, art resources, symbols/kaomoji, and general creative inspiration. |
| `Design & Prototyping` | Wireframe tools, whiteboards, diagram editors, mockup tools, and interface/prototype design services. |

A category may be added when a genuinely new group of bookmarks needs it. Before adding one, check whether an existing category already covers the site's main purpose. Do not create a category for one bookmark unless that bookmark has a clear, useful reason to stand alone.

### NSFW collection: approved categories

The NSFW collection is reserved for adult-oriented sites and pages. Use these categories:

| Category | What belongs here |
|---|---|
| `NSFW Manga` | Adult manga, doujinshi, hentai comics, and adult comic search/catalogue pages. |
| `NSFW Chat` | Adult-oriented AI character chat, roleplay chat, and similar interactive conversation services. |
| `NSFW Games` | Adult game communities, adult game catalogues, and adult game discovery/download pages. |
| `NSFW Art & Imageboards` | Adult imageboards, adult illustration galleries, and adult visual-art discovery sites. Rule34 belongs here. |
| `NSFW Resources` | Adult-only indexes, directories, and reference hubs that do not fit the categories above. |

Do not place a general-purpose service in the NSFW collection merely because it contains some adult material. Use the site's primary purpose and the explicit exceptions in §4.

---

## 4. Explicit exceptions and placement overrides

These rules override normal category decisions. Do not move an exception based only on the site's content, tags, or a later automated classification.

| Site | URL | Required collection and category | Reason / rule |
|---|---|---|---|
| `Pawchive` | `https://pawchive.pw/` | **General → Resources** | Explicit user exception. Keep Pawchive in the ordinary General bookmarks even if it contains or links to adult material. Do not move it to the NSFW collection unless the user explicitly changes this rule. |
| `Rule34` | `https://rule34.xxx/` | **NSFW → NSFW Art & Imageboards** | Explicitly requested NSFW bookmark. Keep it in the NSFW collection. |

When the user declares a new exception:

1. Add it to this table with the exact site name, URL, required collection/category, and reason.
2. Apply the override in the bookmark HTML.
3. Record the change and affected collection version(s) in the Change Log.
4. Do not silently remove an existing exception later.

---

## 5. Collection assignment rules

1. General and NSFW are separate HTML files and must remain separate.
2. Classify by the site's primary purpose, not by one isolated page, tag, advertisement, or user-generated post.
3. Adult-only sites belong in the NSFW collection unless an explicit exception says otherwise.
4. General social, video, discussion, creator, and resource platforms stay in General unless the bookmarked destination itself is specifically an adult-only service/page and no exception applies.
5. A site may appear in both collections only when the user explicitly wants two genuinely different destinations or use cases. Do not duplicate the same URL just to make it easier to find.
6. If uncertain, do not guess or move it. Keep its current placement and add an `Needs review` note to the Change Log for the user's decision.
7. Do not move bookmarks between collections without recording both the source and destination collection versions.

---

## 6. URL and bookmark preservation

- Treat the URL as the bookmark's identity. Check for exact duplicate URLs before adding a bookmark.
- Do not change a URL simply to make it shorter or prettier.
- Preserve meaningful paths, query parameters, saved searches, filters, profile IDs, and deep links. They may represent a user's intentional destination.
- Remove tracking parameters only when they are clearly non-functional and the destination remains exactly equivalent. When uncertain, preserve the original URL.
- Do not invent, guess, or silently replace a destination URL.
- Preserve browser-exported bookmark structure and metadata where practical, including folder nesting, add dates, and favicons. Do not discard useful data during a title/category edit.
- Never delete a bookmark just because its site is temporarily unreachable. Mark it `Needs review` in the Change Log instead. Remove it only when the user requests removal or confirms that it is no longer needed.
- Do not create duplicate bookmarks with different titles when they point to the same URL and serve the same purpose.

---

## 7. Change Log requirements

The Change Log is part of this guide and is the durable history for both HTML files. Update it every time either collection changes.

### Mandatory information for every release

Each release entry must include:

- Date of the edit (`YYYY-MM-DD`).
- Collection (`General`, `NSFW`, or both).
- Old version and new version.
- A short summary of the change.
- Every bookmark added, removed, renamed, or moved, with its name and URL.
- For a moved bookmark: exact old collection/category → new collection/category.
- The version in which each changed bookmark was added, last edited, or moved.
- Any unresolved item that needs the user's decision.

### Bookmark-level version tracking

For every bookmark changed, record its latest event version in the Change Log. Use these labels:

- `Added in`: the collection version where the URL first appeared.
- `Updated in`: the latest version where its title, description, or URL was corrected.
- `Moved in`: the version where its category or collection placement changed.

Do not pretend that a bookmark's original introduction version is known when the available history does not establish it. For bookmarks already present when this guide is first adopted, use `Baseline: vX.Y.Z` rather than inventing an older version.

### Change Log template

Copy this block for each release and fill in the real changes:

```markdown
## YYYY-MM-DD — General vOLD → vNEW

**Summary:** One-sentence description of the release.

**Added**
- `Site Name` — URL — Added in General `vNEW`.

**Updated**
- `Site Name` — URL — title/description/URL change — Updated in General `vNEW`.

**Moved**
- `Site Name` — URL — `Old Category` → `New Category` — Moved in General `vNEW`.

**Removed**
- `Site Name` — URL — reason — Removed in General `vNEW`.

**Needs review**
- `Site Name` — URL — question or uncertainty; no change made.

---

## YYYY-MM-DD — NSFW vOLD → vNEW

**Summary:** One-sentence description of the release.

**Added**
- `Site Name` — URL — Added in NSFW `vNEW`.

**Updated**
- `Site Name` — URL — title/description/URL change — Updated in NSFW `vNEW`.

**Moved**
- `Site Name` — URL — `Old Category` → `New Category` — Moved in NSFW `vNEW`.

**Removed**
- `Site Name` — URL — reason — Removed in NSFW `vNEW`.

**Needs review**
- `Site Name` — URL — question or uncertainty; no change made.
```

If a bookmark moves from General to NSFW (or vice versa), update both collection versions and make paired Change Log entries showing the source removal and destination addition/move. A move is not complete until both files and both entries agree.

### Initial baseline entry

When first adopting this guide, treat the two managed files as the baseline:

- `bookmarks-v1.0.0.html` — General baseline `v1.0.0`.
- `bookmarksNSFW-v1.0.0.html` — NSFW baseline `v1.0.0`.

For all bookmarks already present in those baseline files, record `Baseline: v1.0.0` if a bookmark-level history is needed. Do not fabricate their earlier addition dates or versions.

---

## 8. Required workflow for an AI editor

Whenever bookmark HTML is supplied or exported from Chrome, Chromium, Firefox, or another browser:

1. Read this entire guide first. These rules take priority over assumptions based on the HTML's current folder names or titles.
2. Identify which input belongs to General and which belongs to NSFW. If the user supplies one combined browser export, classify bookmarks using §3–§5 and preserve the explicit exceptions.
3. Parse the actual HTML and preserve every existing bookmark unless the user asks for removal. Do not rely on a partial preview or a truncated excerpt.
4. Normalise titles to `English Name — Persian description` and use the category rules in this guide.
5. Check duplicate URLs, but do not merge different useful deep links just because they belong to the same service.
6. Apply the Pawchive and Rule34 exceptions exactly as written.
7. Determine the version increment separately for General and NSFW. Never silently reset or downgrade either version.
8. Write the updated HTML files using the exact filename patterns in §1.
9. Update this guide's Change Log with a complete, URL-specific record of what changed and the version for every affected bookmark.
10. Report the two output filenames, their versions, the number of bookmarks added/updated/moved/removed, and any `Needs review` items.

### Browser export compatibility

Do not rely on custom HTML comments, custom tags, or hidden metadata inside the bookmark HTML to preserve versioning or instructions. Browser export may rewrite the HTML and remove such additions. The separate `bookmark-guide.md` file is the authoritative place for rules, exceptions, version history, and Change Log. The HTML files should remain valid, importable browser bookmark files.

---

## 9. Current Change Log

### 2026-11-16 — Initial managed release `v1.0.0`

**Guide:** `bookmark-guide.md` — Guide `v1.0.0` (initial published specification).

**General:** `bookmarks-v1.0.0.html` — baseline release `v1.0.0`.

- **Moved in:** `Pawchive` — `https://pawchive.pw/` — `NSFW → Archives` → `General → Resources`.
- **Bookmark event:** `Moved in General v1.0.0`. This is the first managed baseline, so no older bookmark version is inferred.
- **Result:** 70 bookmarks in General.

**NSFW:** `bookmarksNSFW-v1.0.0.html` — baseline release `v1.0.0`.

- **Moved out:** `Pawchive` — `https://pawchive.pw/` — `NSFW → Archives` → `General → Resources`.
- **Bookmark event:** `Moved in NSFW v1.0.0` (source-side removal recorded as part of the move). This is the first managed baseline, so no older bookmark version is inferred.
- **Result:** 6 bookmarks in NSFW. The now-empty `Archives` category was removed.
- `Rule34` remains in the NSFW collection.

**Change summary:** Established the first versioned release for both bookmark collections and the Guide; moved Pawchive into the explicit General → Resources exception, removed it from NSFW, and removed the empty NSFW `Archives` folder. No other bookmark URLs were intentionally changed.

---

For every future release, append a dated entry here using the template in §7. Keep General, NSFW, and Guide versions independent. For a cross-collection move, record both collection-side events and the exact old and new categories. Do not rewrite or delete previous release entries.
