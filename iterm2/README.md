# iTerm2 settings

`com.googlecode.iterm2.plist` is an export of the live preferences
(font: FiraCode Nerd Font, profiles, key bindings).

## Restore on a new machine

```sh
defaults import com.googlecode.iterm2 ~/.config/iterm2/com.googlecode.iterm2.plist
```

Then fully quit iTerm2 (⌘Q) and reopen.

## Update after changing settings

```sh
defaults export com.googlecode.iterm2 ~/.config/iterm2/com.googlecode.iterm2.plist
```

`AppSupport/` (sockets, saved state, server dirs) is runtime data and is
gitignored.
