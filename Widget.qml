import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omapaper"

  readonly property string script: Quickshell.env("HOME")
    + "/.config/omarchy/plugins/" + root.moduleName + "/scripts/wallpapers"

  readonly property string keybind: setting("keybind", "SUPER + CTRL + ALT + SPACE")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function run(mode) {
    if (proc.running) return
    proc.command = [root.script, mode]
    proc.running = true
  }

  function registerKeybind() {
    if (root.keybind === "" || bindProc.running) return
    bindProc.command = [root.script, "bind", root.keybind]
    bindProc.running = true
  }

  onKeybindChanged: root.registerKeybind()
  Component.onCompleted: root.registerKeybind()

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (String(event && event.name ? event.name : "") === "configreloaded") {
        root.registerKeybind()
      }
    }
  }

  Process {
    id: proc
  }

  Process {
    id: bindProc
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰋩"
    active: proc.running
    tooltipText: "Wallpapers — click to browse · middle-click for next · right-click for settings"

    onPressed: function(b) {
      if (b === Qt.RightButton) root.run("settings")
      else if (b === Qt.MiddleButton) root.run("next")
      else root.run("pick")
    }
  }
}
