'use strict';

const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const { palettes, createTheme, validEntry } = require('./theme');

class IslandSync {
  constructor(vscode, output) {
    this.vscode = vscode;
    this.output = output;
    this.queue = Promise.resolve();
    this.disposed = false;
  }

  stateFile() {
    const custom = this.vscode.workspace.getConfiguration('zuritheme').get('islandStateFile', '');
    if (custom) return custom.startsWith('~/') ? path.join(os.homedir(), custom.slice(2)) : path.resolve(custom);
    return path.join(process.env.XDG_CONFIG_HOME || path.join(os.homedir(), '.config'), 'island-shell/theme-state.json');
  }

  enabled() {
    return this.vscode.workspace.getConfiguration('zuritheme').get('syncWithIsland', true);
  }

  async update(section, key, value) {
    const config = this.vscode.workspace.getConfiguration(section);
    const previous = config.inspect(key)?.globalValue;
    if (JSON.stringify(previous) !== JSON.stringify(value)) {
      await config.update(key, value, this.vscode.ConfigurationTarget.Global);
    }
  }

  async updateScoped(section, key, values) {
    const config = this.vscode.workspace.getConfiguration(section);
    const existing = config.inspect(key)?.globalValue || {};
    await this.update(section, key, { ...existing, '[Material You]': { ...existing['[Material You]'], ...values } });
  }

  async sync(force = false) {
    if (this.disposed || !this.enabled()) return;
    let text;
    try {
      text = await fs.promises.readFile(this.stateFile(), 'utf8');
    } catch (err) {
      if (err.code !== 'ENOENT') throw err;
      return;
    }
    if (!force && text === this.lastState) return;
    const state = JSON.parse(text);
    const name = ({ tokyonight: 'tokyo-night', tokyo_night: 'tokyo-night' })[state.name] || state.name;
    if (!Object.hasOwn(palettes, name)) return;
    if (name === 'material-you') {
      if (!validEntry(state.entry)) return;
      const theme = createTheme(name, state.entry);
      await this.updateScoped('workbench', 'colorCustomizations', theme.colors);
      await this.updateScoped('editor', 'tokenColorCustomizations', { textMateRules: theme.tokenColors });
      await this.updateScoped('editor', 'semanticTokenColorCustomizations', { enabled: true, rules: theme.semanticTokenColors });
    }
    if (this.disposed || !this.enabled()) return;
    await this.update('workbench', 'colorTheme', palettes[name].label);
    this.lastState = text;
    this.output.appendLine(`Synced Island palette: ${name}`);
  }

  request(force = false) {
    this.queue = this.queue.catch(() => {}).then(() => this.sync(force)).catch(err => {
      this.output.appendLine(`Theme sync: ${err.message}`);
    });
    return this.queue;
  }

  start() {
    this.watcher?.close();
    this.watcher = undefined;
    clearTimeout(this.timer);
    this.lastState = undefined;
    if (!this.enabled() || this.disposed) return;
    const file = this.stateFile();
    try {
      // Watch the directory: Island uses an atomic replacement on theme change.
      this.watcher = fs.watch(path.dirname(file), (event, filename) => {
        if (!filename || String(filename) === path.basename(file)) {
          clearTimeout(this.timer);
          this.timer = setTimeout(() => this.request(true), 100);
        }
      });
      this.watcher.on('error', err => this.output.appendLine(`Theme watcher: ${err.message}`));
    } catch (err) {
      if (err.code !== 'ENOENT') this.output.appendLine(`Theme watcher: ${err.message}`);
    }
    return this.request(true);
  }

  dispose() {
    this.disposed = true;
    this.watcher?.close();
    clearTimeout(this.timer);
  }
}

module.exports = { IslandSync };
