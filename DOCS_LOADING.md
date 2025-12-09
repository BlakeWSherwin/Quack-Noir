Loading screen feature

What I changed

- Added a `showActLoadingOverlay(actId, options)` helper that shows a full-screen "Loading…" overlay, kicks off important preloads (enemy sprites + street background lists), waits until those operations settle (or a timeout), then automatically hides.
- When the player selects an Act from the title Act menu the game now shows the loading overlay, waits for preloading, and then continues automatically to the existing transition screen and on to the run.
- `showActTransition` is updated to accept an options object and skip preloading when `options.preloaded === true` to avoid duplicate waits.
- The loading overlay now uses `assets/loading.png` as a background and shows a live progress counter and progress bar that tracks enemy sprites and street backgrounds.

Why this helps

Itch.io and some remote hosts can be slower to serve assets compared to local disk. Showing a dedicated loading overlay while assets fetch ensures the transition and the run experience feels snappier and avoids long interruptions during the transition or inside the first rooms.

How the loading overlay decides it's done

It waits for a combination of:

- enemy sprite preloads via `preloadActSprites(actId, timeoutMs, onProgress)` (now supports a progress callback)
- the street/background image list (via `window._streetBackgrounds.list` and `loadBgToCache`)
- a soft timeout (defaults to 6–8s for menu-triggered loads)

The overlay will hide once everything has settled or the timeout elapses.

Testing locally

1. Open `QuackNoirTest-New.html` in a browser (serve the folder using a simple static server if necessary — some browsers restrict local file loading):

   - Using Python 3: `python -m http.server 8000`
   - Navigate to `http://localhost:8000/` and click the title to open the Act menu.
2. Click an act (e.g. Act II) and you should see the loading overlay appear, then it will automatically move to the transition overlay and then the run.
3. Inspect the console for logs prefixed with `[preloadActSprites]` and `[ActTransition]` to follow the flow.

Ideas for future improvements

- Show an estimated progress percentage by tracking each resource load.
- Make spinner and copy configurable per-act (e.g., show different messages for Act IV cutscene).

If you want, I can add a progress counter (attempt to detect how many assets remain) or tweak the styling to match your title/transition more closely.
