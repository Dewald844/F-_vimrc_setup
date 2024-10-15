set nocompatible
syntax on
set relativenumber
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"""""""""
"Plugins"
"""""""""

Plugin 'VundleVim/Vundle.vim'
Plugin 'realbucksavage/riderdark.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'neoclide/coc.nvim'
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',  
  \ }

Plugin 'ionide/Ionide-vim',{
  \ 'do': 'make fsautocomplete',
  \}
    
call vundle#end()
        
""""""""""""""""""""
"   Fsharp setup   "
"""""""""""""""""""" 
let g:LanguageClient_serverCommands = {   
   \'fsharp':['fsautocomplete', '--background-service']
   \}
        
if executable('dotnet')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'fsautocomplete',
        \ 'cmd': {server_info->['dotnet', 'fsautocomplete', '--background-service-enabled']},
        \ 'whitelist': ['fsharp'],
        \ })
endif
    
    
filetype plugin indent on
set backspace=indent,eol,start

let g:ycm_global_ycm_extra_conf = '$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    
function ShowTypeAfterPipe()
    let l:line = getline('.')
    if l:line =~# '.*|>\s*$'
        let l:pos = getpos('.')
        let l:line_num = l:pos[1]
        let l:col_num = l:pos[2]
        let l:cmd = 'normal! o'
        execute l:cmd
        call cursor(l:line_num, l:col_num)
        let l:cmd = 'normal! I// Type: '
        execute l:cmd
        call cursor(l:line_num + 1, l:col_num + 9)
    endif
endfunction

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    command! Symbols :call LanguageClient_textDocument_documentSymbol()
    command! Fix :call LanguageClient_textDocument_codeAction()
     
    nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>rn :call LanguageClient#textDocument_rename()<CR>
    nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
    nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
    nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
    nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
    nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  endif
endfunction
        
autocmd FileType * call LC_maps()
    
if has('nvim') && exists('*nvim_open_win')
  augroup FSharpShowTooltip
    autocmd!
    autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
  augroup END
endif
