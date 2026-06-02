local wezterm = require("wezterm")
local config = wezterm.config_builder()
local constants = require("constants")
local commands = require("commands")

--Font Setting
config.font_size = 10.3
config.line_height = 1
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })

--Colors
config.colors = {
  cursor_bg = "white",
  cursor_border = "white",
}

--Apperance
config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.enable_wayland = true
-- config.window_background_image = constants.bg_images
config.kde_window_background_blur = true
config.text_background_opacity = 1
-- -- WALLPAPER
config.background = {
  --buat gambar
  {
    source = { File = constants.bg_images },
    opacity = 0.9,    -- wallpaper transparan
    hsb = {
      brightness = 1, -- wallpaper jadi gelap 12%
      saturation = 1,
    },
  },

  --layer atas gambar
  {
    source = {
      Gradient = {
        colors = { "#151515", "#151515" }, -- hitam 80%
        -- colors = { "#393E46", "#393E46" }, -- hitam 80%
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.6,    -- semakin besar semakin gelap
    hsb = {
      brightness = 1, -- wallpaper jadi gelap 12%
      saturation = 1,
    },
  },
}

config.window_padding = {
  left = 0,
  right = 20,
  top = 0,
  bottom = 0,
}

--Miscellaneous setting
config.max_fps = 120
config.prefer_egl = true

--custom command
wezterm.on("augment-command-palette", function()
  return commands
end)

function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#0b0022"
  local background = "#1b1032"
  local foreground = "#808080"
  local emote = ""

  if tab.is_active then
    background = "#62109F"
    foreground = "#ffffff"
    emote = "🖕🏻"
  elseif hover then
    background = "#3b3052"
    foreground = "#909090"
  end

  -- ambil cwd/folder aktif
  local cwd_uri = tab.active_pane.current_working_dir
  local cwd = ""
  if cwd_uri then
    local path = cwd_uri.file_path or cwd_uri:gsub("file://", "")
    cwd = string.match(path, "([^/]+)$") or path
  end

  local title = cwd
  title = wezterm.truncate_right(title, max_width)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = "" },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = emote .. " " .. title .. " " .. emote },

    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = "" },
  }
end)

-- For example, changing the initial geometry for new windows:
config.initial_cols = 100
config.initial_rows = 40

-- penting
config.xcursor_theme = "breeze_cursors"
config.xcursor_size = 24

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Finally, return the configuration to wezterm:
return config
