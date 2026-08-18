/*
 * Vimium UI in Omarchy theme colors.
 *
 * Omarchy renders this template into
 * ~/.local/state/omarchy/current/theme/vimium.css on every theme change.
 * The Vimium fork bakes that rendered file in as the default value of its
 * "CSS for Vimium UI" setting, via the make.js omarchy-theme task.
 *
 * Vimium injects this stylesheet into the page for link hints, and into its
 * own extension frames for the hud and the vomnibar, so one file themes all
 * three. Selectors follow the class names Vimium documents as user facing.
 *
 * After a theme change, rebuild and reload the extension:
 *   cd ~/Desktop/technology/projects/browser-extensions/vimium
 *   deno run -A make.js omarchy-theme && deno run -A make.js package
 */

/* Link hints */
div > .vimiumHintMarker {
  background: {{ accent }};
  border: 1px solid {{ mix accent background 35% }};
  border-radius: 3px;
  box-shadow: 0 1px 3px {{ mix background foreground 8% }};
  padding: 1px 3px;
}

div > .vimiumHintMarker span {
  color: {{ background }};
  font-weight: bold;
  font-size: 12px;
  text-shadow: none;
}

/* The part of the hint you have already typed */
div > .vimiumHintMarker > .matchingCharacter {
  color: {{ mix background accent 45% }};
}

div > .vimiumActiveHintMarker {
  background: {{ yellow }};
  border-color: {{ mix yellow background 35% }};
}

/* Heads up display, bottom left */
#hud {
  background: {{ mix background foreground 12% }} !important;
  color: {{ foreground }} !important;
  border: 1px solid {{ mix background foreground 25% }} !important;
  border-bottom: none !important;
}

#hud span#hud-find-input {
  color: {{ bright_foreground }} !important;
}

#hud span#hud-match-count {
  color: {{ muted }} !important;
}

/* Vomnibar */
#vomnibar {
  background: {{ mix background foreground 10% }} !important;
  border: 1px solid {{ mix background foreground 25% }} !important;
  box-shadow: 0 4px 20px {{ background }} !important;
}

#vomnibar input {
  background: {{ mix background foreground 18% }} !important;
  color: {{ bright_foreground }} !important;
  border: 1px solid {{ mix background foreground 30% }} !important;
}

#vomnibar input::selection {
  background: {{ selection_background }} !important;
  color: {{ selection_foreground }} !important;
}

#vomnibar ul {
  background: transparent !important;
  border-top: 1px solid {{ mix background foreground 25% }} !important;
}

#vomnibar li {
  border-bottom: 1px solid {{ mix background foreground 15% }} !important;
  color: {{ foreground }} !important;
}

#vomnibar li .title {
  color: {{ foreground }} !important;
}

#vomnibar li .url {
  color: {{ muted }} !important;
}

#vomnibar li .match,
#vomnibar li em {
  color: {{ accent }} !important;
  font-style: normal !important;
}

#vomnibar li .source {
  color: {{ cyan }} !important;
}

#vomnibar li.selected {
  background: {{ mix background accent 22% }} !important;
}

#vomnibar li.selected .title {
  color: {{ bright_foreground }} !important;
}
