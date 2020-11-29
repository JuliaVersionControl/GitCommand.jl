import ReplMaker

function gitrepl(; mode_name = GIT_REPL_MODE_NAME,
                   prompt_text = GIT_REPL_MODE_PROMPT_TEXT,
                   start_key = GIT_REPL_MODE_START_KEY,
                   kwargs...)
    ReplMaker.initrepl(
        _gitrepl_parser;
        mode_name = mode_name,
        prompt_text = prompt_text,
        start_key = start_key,
        kwargs...,
    )
    return nothing
end
