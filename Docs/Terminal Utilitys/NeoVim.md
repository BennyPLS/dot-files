I use Neovim or Nvim to unfrecuenly edit configurations in the terminal in addition to Nvim i use the [[NvChad]] as base configuration of my NeoVim Instalation Setup. 

> [!NOTE]-
> I use normaly in the terminal the line cursor, and NvChad changes this for that to not happend i append this line in the end of the file of **init.lua**.
> `Path: ~/.config/nvim/init.lua`
> ```lua
> vim.cmd [[ au VimLeave,VimSuspend * set guicursor=a:ver25 ]] 
> ```

> [!INFO]- Website
> [NeoVim](https://neovim.io/)
