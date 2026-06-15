# 🧘 commentless.nvim

Hide comments, focus on the code flow, and reveal them if needed.

This plugin lets you fold all comments to better visualize your code’s logic,
and unfold them whenever needed.

<div align="center">
  <img src="https://i.imgur.com/32JkGlQ.gif" alt="commentless.nvim usage" width="90%">
</div>

## 📦 Installation

Use your favorite plugin manager to install it, and then run
`require("soemre/commentless.nvim").setup({})` to start it up.

Also, check out the [Some Recommendations for Global Folding Behavior](some-recommendations-for-global-folding-behavior) section.

### lazy.nvim

The `setup` call is handled internally by `lazy.nvim`.

```lua
{
    "soemre/commentless.nvim",
    cmd = "Commentless",
    keys = {
        {
            "<leader>/",
            function()
                require("commentless").toggle()
            end,
            desc = "Toggle Comments",
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        -- Customize Configuration
    },
}
```

## 🚀 Usage

To get started, bind keys to the public API or run `:Commentless <args>` directly.

### Example

```lua
vim.keymap.set("n", "<leader>/", function()
    require("commentless").toggle()
end)
```

or with [Folke's snacks](https://github.com/folke/snacks.nvim)

```lua
-- folke/snacks.nvim
Snacks.toggle({
  name = "Comments",
  notify = false,
  get = function()
    return require("commentless").is_hidden()
  end,
  set = function()
    require("commentless").toggle()
  end,
  wk_desc = {
    enabled = "Reveal ",
    disabled = "Hide ",
  },
}):map("<leader>/")
```

## 🛠️ Configuration

Check `:help commentless` for full documentation.

### Default Configuration

```lua
{
    hide_following_blank_lines = true,
    hide_current_comment = true,
    enable_notifications = true,
    using_folke_lazyvim_setup = false,
    apply_to_new_buffer = false,
    apply_on_buffer_change = false,
    foldtext = function(folded_count)
        return "(" .. folded_count .. " comments)"
    end,
}
```

### Some Recommendations for Global Folding Behavior

```lua
vim.opt.foldminlines = 0 -- Allow folding/hiding single lines
vim.opt.fillchars = "fold: " -- Remove the trailing dots
```

## ⓘ FAQ

### Why isn't it working with some file types?

To determine whether something is a comment, it uses `tree-sitter`. Therefore,
you need to have `tree-sitter` parsers installed for the file types (languages)
you plan to use. You can install them using `:TSInstall <language_to_install>`
or via the `ensure_installed` option in `tree-sitter`'s setup parameters.
