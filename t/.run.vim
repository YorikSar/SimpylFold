function s:preprocess(filename)
    let rlines = []
    let expectedfolds = []
    let foldlines = []
    for line in readfile(a:filename)
        if !len(expectedfolds)
            let tokens = matchlist(line, '^\s*expect folds\s*\(\(\d\+,\)*\d\+\)\s*$')
            if !empty(tokens)
                let expectedfolds = split(tokens[1], ',')
                continue
            endif
        else
            let tokens = matchlist(line, '^\s*end\s*$')
            if empty(tokens)
                if !len(foldlines)
                    let indent = match(line, '[^ ]')
                endif
                call add(foldlines, line)
            else
                call add(rlines, 'put! =[')
                for fline in foldlines
                    call add(rlines, printf('\  ''%s'',', substitute(fline[indent :], '"', '\\"', 'g')))
                endfor
                call add(rlines, '\ ]')
                for i in range(len(expectedfolds))
                    call add(rlines, printf('Expect foldlevel(%d) == %s', i+1, expectedfolds[i]))
                endfor
                let expectedfolds = []
                let foldlines = []
            endif
            continue
        endif
        call add(rlines, line)
    endfor
    let tempfile = tempname()
    call writefile(rlines, tempfile)
    return tempfile
endfunction
function s:main()
    let &runtimepath = getcwd() . ',' . getcwd() . '/t/vim-vspec,' . &runtimepath
    set vetbose
    1 verbose call vspec#test(s:preprocess($testcase))
    qall!
endfunction
call s:main()
