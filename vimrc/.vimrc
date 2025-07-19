set relativenumber number
inoremap kj <esc>
set clipboard^=unnamedplus,unnamed

vnoremap <C-c> "+y
vnoremap <C-x> "+d
nnoremap <C-v> "+gP
vnoremap <C-v> "+gP

autocmd VimLeave * call system("xclip -selection clipboard -i", getreg('+'))
