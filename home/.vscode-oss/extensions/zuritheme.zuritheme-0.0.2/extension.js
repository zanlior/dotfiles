'use strict';

const vscode = require('vscode');
const { IslandSync } = require('./src/sync');

function activate(context) {
  const output = vscode.window.createOutputChannel('ZuriTheme');
  const sync = new IslandSync(vscode, output);
  context.subscriptions.push(output, sync,
    vscode.commands.registerCommand('zuritheme.syncNow', () => sync.request(true)),
    vscode.workspace.onDidChangeConfiguration(event => {
      if (event.affectsConfiguration('zuritheme')) sync.start();
    }),
    vscode.window.onDidChangeWindowState(state => {
      if (state.focused) sync.request();
    }));
  return sync.start();
}

module.exports = { activate };
