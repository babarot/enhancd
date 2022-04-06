
alias cd "cdin start"

function cdin
    if count $argv > /dev/null
        if [ "$argv[1]" = 'start' ]
            alias cd "cd"
            if [ "$argv[2]" != '' ]
                cd $argv[2]
            else
                fzf_cd
            end
            alias cd "cdin start"
        end
    end
end


function fzf_cd
    read -la line; set var (command find $PWD -name $line)
    set dname (dirname $var)
    cd (find $PWD -name (ls $dname|fzf))
#     # find $dname -type d | fzf
end
