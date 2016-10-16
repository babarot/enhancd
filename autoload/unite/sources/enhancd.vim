let s:save_cpo = &cpo
set cpo&vim

if !exists('g:enhancd_action')
    let g:enhancd_action = 'cd'
end

function! unite#sources#enhancd#define()
    return s:source
endfunction

let s:source = {
            \ 'name': 'enhancd',
            \ 'action_table' : {},
            \ 'default_action' : 'cd',
            \ }

function! s:source.gather_candidates(args, context)
    return map(readfile(expand('$ENHANCD_DIR/enhancd.log')), "{ 'word' : v:val }")
endfunction

let s:action_table = {}
let s:action_table.cd = {
            \ 'description' : 'change directory',
            \ 'is_selectable' : 1,
            \ }

function! s:action_table.cd.func(candidates)
    let name = join(map(deepcopy(a:candidates), 'v:val.word'))
    execute g:enhancd_action . ' ' . name
endfunction

let s:source.action_table = s:action_table

let &cpo = s:save_cpo
unlet s:save_cpo
