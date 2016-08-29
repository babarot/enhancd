let s:cpo_save = &cpo
set cpo&vim

if !exists('g:enhancd_action')
    let g:enhancd_action = 'cd'
end

function! s:enhancd()
    let files = []
    for line in readfile(expand("$ENHANCD_DIR/enhancd.log"))
        call add(files, line)
    endfor

    if len(files) == 0
        return
    endif

    call fzf#run({
                \ 'source': uniq(files),
                \ 'sink': g:enhancd_action,
                \ 'options': '--tac -x +s',
                \ 'down': 15})
endfunction

function! s:enhancd_filter()
    return commands = map(
                \ uniq(split(expand('$ENHANCD_FILTER'), ':')),
                \ 'substitute(v:val, "\s.*$", "", "g")'
                \ )
endfunction

command! Enhancd call s:enhancd()

let &cpo = s:cpo_save
unlet s:cpo_save
