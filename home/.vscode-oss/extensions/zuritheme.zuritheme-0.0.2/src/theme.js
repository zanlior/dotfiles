'use strict';

const palettes = require('./palettes.json');
const templates = Object.fromEntries([...new Set(Object.values(palettes).map(p => p.base))]
  .map(name => [name, require(`./templates/${name}.json`)]));

function rgb(hex) {
  return [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16));
}

function mix(first, second, fraction) {
  const a = rgb(first), b = rgb(second);
  return '#' + a.map((v, i) => Math.round(v + (b[i] - v) * fraction).toString(16).padStart(2, '0')).join('');
}

function luminance(hex) {
  const c = rgb(hex).map(v => v / 255).map(v => v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4);
  return c[0] * 0.2126 + c[1] * 0.7152 + c[2] * 0.0722;
}

function contrast(first, second) {
  const a = luminance(first), b = luminance(second);
  return (Math.max(a, b) + 0.05) / (Math.min(a, b) + 0.05);
}

function readable(color, backgrounds, foreground) {
  color = color.slice(0, 7).toLowerCase();
  for (let step = 0; step <= 20; step++) {
    const candidate = mix(color, foreground, step / 20);
    if (backgrounds.every(bg => contrast(candidate, bg) >= 4.5)) return candidate;
  }
  return foreground;
}

function validEntry(entry) {
  return entry && ['colors', 'samples'].every(key => Array.isArray(entry[key]) && entry[key].length === 6
    && entry[key].every(value => typeof value === 'string' && /^#[0-9a-f]{6}$/i.test(value)));
}

function createTheme(name, dynamicEntry) {
  const preset = palettes[name];
  if (!preset) throw new Error(`Unknown Island theme: ${name}`);
  const entry = dynamicEntry || preset;
  if (!validEntry(entry)) throw new Error(`Invalid palette: ${name}`);
  const [background, panel, card, foreground, muted, accent] = entry.colors;
  const terminal = dynamicEntry ? {
    background, foreground, cursor: accent, cursor_text_color: background,
    ...Object.fromEntries([card, ...entry.samples, foreground, muted, ...entry.samples, foreground]
      .map((value, i) => [`color${i}`, value])),
  } : preset.terminal;
  const bg = terminal.background.toLowerCase(), fg = terminal.foreground.toLowerCase();
  const [red, green, yellow, blue, purple, cyan] = Array.from({ length: 6 }, (_, i) => terminal[`color${i + 1}`]);
  const source = templates[preset.base];
  const c = source.colors, s = source.semanticTokenColors;
  const roleMap = new Map();
  const add = (sourceColor, target) => {
    if (typeof sourceColor === 'string') roleMap.set(sourceColor.slice(0, 7).toLowerCase(), target.toLowerCase());
  };
  add(c['editor.background'], bg);
  add(c['sideBar.background'], panel);
  add(c['input.background'], card);
  add(c['editor.selectionBackground'], card);
  add(c['terminal.ansiBlack'], card);
  add(c['editorLineNumber.foreground'], muted);
  add(c['editorRuler.foreground'], card);
  add(c['editorCodeLens.foreground'], muted);
  add(c['editor.foreground'], fg);
  add(s.variable, fg);
  add(s.comment, muted);
  add(s.string, green);
  add(s.number, mix(red, yellow, 0.5));
  add(s.type, yellow);
  add(s.function, blue);
  for (const [key, value] of [['Red', red], ['Green', green], ['Yellow', yellow], ['Blue', blue], ['Magenta', purple], ['Cyan', cyan]]) {
    add(c[`terminal.ansi${key}`], value);
  }
  add(c['progressBar.background'], accent);
  add('#ffffff', fg);
  add('#000000', bg);

  function recolor(value) {
    if (Array.isArray(value)) return value.map(recolor);
    if (value && typeof value === 'object') return Object.fromEntries(Object.entries(value).map(([key, val]) => [key, recolor(val)]));
    if (typeof value !== 'string' || !/^#[0-9a-f]{6}([0-9a-f]{2})?$/i.test(value)) return value;
    const base = value.slice(0, 7).toLowerCase();
    let replacement = roleMap.get(base);
    if (!replacement) {
      // Reuse the source's color roles even for less common decoration shades.
      const original = rgb(base);
      const nearest = [...roleMap.keys()].sort((a, b) => {
        const distance = key => rgb(key).reduce((sum, v, i) => sum + (v - original[i]) ** 2, 0);
        return distance(a) - distance(b);
      })[0];
      replacement = roleMap.get(nearest);
    }
    return replacement + value.slice(7).toLowerCase();
  }

  const theme = recolor(source);
  theme.name = preset.label;
  theme.type = name === 'e-ink' ? 'light' : 'dark';
  const backgrounds = [bg, panel];
  for (const rule of theme.tokenColors) {
    if (rule.settings.foreground) rule.settings.foreground = readable(rule.settings.foreground, backgrounds, fg);
  }
  theme.tokenColors[0].settings.background = bg;
  theme.tokenColors[0].settings.foreground = fg;
  for (const [key, value] of Object.entries(theme.semanticTokenColors)) {
    if (typeof value === 'string') theme.semanticTokenColors[key] = readable(value, backgrounds, fg);
  }
  for (const [key, value] of Object.entries(theme.colors)) {
    if (/(?:foreground|Foreground)$/.test(key) && !key.startsWith('terminal.')) {
      theme.colors[key] = readable(value, backgrounds, fg);
    }
  }
  // The source's high-contrast surface layout is the default. Retain readable
  // controls, visible focus and complete terminal colors for every new palette.
  Object.assign(theme.colors, {
    'editor.background': bg, 'editor.foreground': fg, 'editorGutter.background': bg,
    'terminal.background': bg, 'terminal.foreground': fg,
    'sideBar.background': panel, 'sideBarSectionHeader.background': panel,
    'activityBar.background': panel, 'activityBarTop.background': panel,
    'statusBar.background': panel, 'statusBar.foreground': readable(muted, backgrounds, fg),
    'titleBar.activeBackground': panel, 'titleBar.inactiveBackground': panel,
    'panel.background': panel, 'editorGroupHeader.tabsBackground': bg,
    'focusBorder': accent, 'contrastBorder': card, 'contrastActiveBorder': accent,
    'widget.border': card, 'editorGroup.border': card,
    'editorLineNumber.foreground': readable(muted, backgrounds, fg),
    'editorLineNumber.activeForeground': fg,
    'editorCursor.foreground': accent, 'editorCursor.background': bg,
    'terminalCursor.foreground': terminal.cursor || accent, 'terminalCursor.background': bg,
    'editorIndentGuide.background1': card, 'editorIndentGuide.activeBackground1': muted,
    'editorStickyScroll.background': bg, 'editorOverviewRuler.background': bg,
    'dropdown.foreground': fg, 'input.background': panel,
    'widget.shadow': '#0000004d',
  });
  const buttonText = [bg, fg, '#000000', '#ffffff'].sort((a, b) => contrast(b, accent) - contrast(a, accent))[0];
  for (const key of ['button.foreground', 'activityBarBadge.foreground', 'activityWarningBadge.foreground', 'activityErrorBadge.foreground']) {
    const controlBg = theme.colors[key.replace('foreground', 'background')] || accent;
    theme.colors[key] = [buttonText, '#000000', '#ffffff'].sort((a, b) => contrast(b, controlBg) - contrast(a, controlBg))[0];
  }
  const ansiNames = ['Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White'];
  ansiNames.forEach((label, i) => {
    theme.colors[`terminal.ansi${label}`] = terminal[`color${i}`];
    theme.colors[`terminal.ansiBright${label}`] = terminal[`color${i + 8}`];
  });
  return theme;
}

module.exports = { palettes, createTheme, validEntry, contrast };
