# extension-video-speed-controller - fork notes

A fork of [philc/vimium](https://github.com/philc/vimium) that adds
[globalSpeed](https://github.com/polywock/globalSpeed)-style HTML5 **video/audio media controls** as
native Vimium normal-mode commands (keyboard shortcuts).

Everything Vimium already does is unchanged. This fork only _adds_ a new "Media / video" command
group; it touches four upstream files plus this note, so it stays easy to keep in sync with
upstream.

## Original spec

> for vimium and implement shortcuts that can do all of the functionality of
> https://github.com/polywock/globalSpeed make sure vimium is still connected so i can always keep
> my fork up to date while also pushing this code to the codeberg repo.

## Commands & default keybindings

All media commands live under the **`s`** (speed) prefix, chosen because Vimium binds nothing to `s`
by default - so there are zero collisions with stock Vimium keys, and every binding is rebindable on
Vimium's Options page like any other.

| Keys           | Command                       | Action                                 |
| -------------- | ----------------------------- | -------------------------------------- |
| `sk`           | `speedUpVideo`                | Increase playback rate (+0.25, ×count) |
| `sj`           | `slowDownVideo`               | Decrease playback rate (−0.25, ×count) |
| `sr`           | `resetVideoSpeed`             | Reset rate to 1×                       |
| `s1` `s2` `s3` | `setVideoSpeed speed=N`       | Set rate to 1× / 2× / 3×               |
| `sl`           | `seekVideoForward`            | Seek +5s (×count)                      |
| `sh`           | `seekVideoBackward`           | Seek −5s (×count)                      |
| `s.`           | `videoFrameForward`           | Step ~1 frame forward (pauses)         |
| `s,`           | `videoFrameBackward`          | Step ~1 frame backward (pauses)        |
| `sp`           | `toggleVideoPlay`             | Play / pause                           |
| `sm`           | `toggleVideoMute`             | Mute / unmute                          |
| `so`           | `toggleVideoLoop`             | Toggle loop                            |
| `si`           | `toggleVideoPictureInPicture` | Toggle picture-in-picture              |
| `sF`           | `toggleVideoFullscreen`       | Toggle fullscreen on the video         |
| `s0`           | `restartVideo`                | Jump to start                          |

Counts work like the rest of Vimium: `3sk` speeds up by three steps. Options are configurable when
rebinding, e.g. `map > speedUpVideo step=0.5`, `map gg seekVideoForward seconds=10`,
`map z setVideoSpeed speed=1.75`.

### Behaviour notes

- **Speed changes apply to every `<video>`/`<audio>` in the frame** and are **remembered per host**
  (like globalSpeed): the remembered rate is re-applied to media that appears later (SPAs, lazy
  players, source switches). Stored in `chrome.storage.local` under `videoSpeedRate.<hostname>`.
- Seek / play / frame-step / PiP / fullscreen target the **most relevant** media element (largest
  playing visible video, else largest video, else any media).
- Rate is clamped to `[0.0625, 16]`. Frame step assumes ~60fps (the real frame rate is not exposed
  to web pages).

### Out of scope (vs globalSpeed)

globalSpeed's Web-Audio effects (gain/volume-boost, pitch, mono, audio filters), A–B loop, marks,
and screenshots are **not** implemented - they need a separate Web Audio subsystem and UI rather
than simple media-element shortcuts. The speed, seek, frame, and playback controls above cover the
keyboard-shortcut surface.

## Implementation

- `background_scripts/all_commands.js` - registers the 14 commands in the `media` group.
- `content_scripts/mode_normal.js` - `VideoMedia` helper + the `NormalModeCommands` methods.
  `VideoMedia.init()` runs only in a browser (guarded against the Deno command-listing build).
- `background_scripts/commands.js` - default `s`-prefix key mappings.
- `pages/help_dialog_page.html` & `pages/command_listing.html` - "Media / video" group sections.

## Build (Firefox primary, Chrome secondary)

Uses Vimium's own [Deno](https://deno.com) toolchain - no extra setup.

```sh
./make.js package      # builds BOTH targets into dist/
#   dist/firefox/vimium-firefox-<ver>.zip   <- Firefox (load via about:debugging)
#   dist/chrome-store/  dist/chrome-canary/  dist/vimium/   <- Chrome (load unpacked)
./make.js test-unit    # 217 unit tests (incl. one-entry-per-command check)
deno fmt && deno lint  # match upstream style before committing
```

`test-dom` needs a local Chrome binary (puppeteer) and is skipped in headless CI.

## Keeping the fork up to date with vimium

`upstream` points at philc/vimium; `origin` is the Codeberg repo.

```sh
git fetch upstream
git merge upstream/master      # or: git rebase upstream/master
```

Because the media feature is isolated to the files listed above (and matches upstream's `deno fmt`
style), upstream pulls should rarely conflict.

## ⚠️ Codeberg push: repo must be SHA-1

A Git fork must share its object format with upstream. Vimium (and all of GitHub) is **SHA-1**, so
this local repo is SHA-1. The Codeberg repo `sterre/extension-video-speed-controller` was created
**SHA-256** and cannot receive SHA-1 history (`fatal: mismatched algorithms`).

To push this fork, recreate the (currently empty) Codeberg repo as SHA-1:

1. On Codeberg, delete `extension-video-speed-controller` (only holds an initial README commit).
2. Recreate it with the **default** object format (SHA-1 - just don't pick SHA-256).
3. `git push -u origin master`

The other two extensions (`extension-temporary-containers`, `extension-time-tracker`) are file
copies, not Git forks, so they stay SHA-256 and push as-is.
