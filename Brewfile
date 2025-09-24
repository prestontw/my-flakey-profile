# Non-versioned applications, in the style of <https://matklad.github.io/2025/02/23/macos-for-kde-users.html#Managing-Software>.
# I have tried installing GUI's through Nix on Linux, but that leads to issues around OpenGL contexts.
# Installing GUI's through Brew avoids this issue.
# Worse case, this file provides a list of GUI's to install through the native package manager on Linux.
 
# Utility method to install dependencies that vary between Linux and Mac
def install_in(mac: -> {}, linux: -> {})
  if OS.mac?
    mac.call
  elsif OS.linux?
    linux.call
  end
end 

# AeroSpace is an i3-like tiling window manager for macOS
install_in(mac: -> { cask "aerospace" })

install_in(mac: -> {
  cask "wezterm"
}, linux: -> {
  # Brew doesn't support Arm64 yet.
  tap "wezterm/wezterm-linuxbrew"
  brew "wezterm"
})

