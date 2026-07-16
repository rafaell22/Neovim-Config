# Neovim-Config
My configuration for Neovim.

## Setup

1. Install plugins from Neovim: `:PlugInstall`

2. **`sqlite3.dll` (Windows)** — required by `telescope-smart-history` for
   persistent, context-aware search history. The DLL is gitignored, so add it
   manually after cloning:
   - Download the Windows x64 DLL from https://www.sqlite.org/download.html
     (file `sqlite-dll-win-x64-*.zip`).
   - Extract `sqlite3.dll` into this config directory (next to `init.vim`).
   - The config points at it via `vim.g.sqlite_clib_path` in `lua/config.lua`.

   Without it, Telescope still works — only the persistent search history is
   disabled (the load is wrapped in `pcall`).
