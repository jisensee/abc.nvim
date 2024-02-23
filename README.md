# abc.nvim

Utilities for to make editing `.abc` files in neovim a bit more productive.

## Installation

**With lazy.nvim:**
```lua
{
  'jisensee/abc.nvim',
  config = function() require('abc-nvim').setup() end,
  ft = 'abc',
},
```

## Usage

`abc.nvim` provides the following commands:

- `:AbcPreview` - Serves a rendered version of the current file in a browser. Will refresh automatically on save.
- `AbcPreviewStop` - Stops the currently active preview.
- `AbcPlay` - Plays the track under the cursor (searches upwards until it finds the `X:` header).
- `AbcStop` - Stops current playback.

Alternatively you can `require('abc-nvim)` and use the following functions if you prefer:
- `play`
- `stop`
- `preview`
- `stop_preview`

## Requirements

`abc.nvim` uses several external tools for working with `.abc` and `.mid` files.
The following binaries need to be available in the `PATH`:

- `abcm2ps` to render `.abc` files
- `live-server` (https://www.npmjs.com/package/live-server) to serve the rendered file with live reloading
- `abc2midi` to convert `.abc` files to `.midi`
- `timidity` (https://wiki.archlinux.org/title/Timidity++) to play the generateded `.midi` file
