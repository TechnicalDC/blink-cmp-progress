# blink-cmp-progress

A [blink.cmp](https://github.com/Saghen/blink.cmp) source for Progress 4GL language.

## Installation
### lazy.nvim
```lua
{
   'saghen/blink.cmp',
   dependencies = {
      'TechnicalDC/blink-cmp-progress'
   },
   opts = {
      sources = {
         providers = {
            progress = {
               name = "Progress",
               module = "blink-cmp-progress",
               opts = { insert = true }
            }
         },
         per_filetype = {
            progress = { ... 'progress' },
         },
      }
   }
}
```
