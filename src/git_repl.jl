import ReplMaker

function _gitrepl(; mode_name = GIT_REPL_MODE_NAME,
                    prompt_text = GIT_REPL_MODE_PROMPT_TEXT,
                    start_key = GIT_REPL_MODE_START_KEY,
                    kwargs...)
    return ReplMaker.initrepl(_gitrepl_parser;
                              mode_name = mode_name,
                              prompt_text = prompt_text,
                              start_key = start_key,
                              kwargs...)
end

function _gitrepl_parser(repl_input::AbstractString)
    return quote
        GitCommand.git() do git
            repl_input = $(Expr(:quote, repl_input))
            run(`$(git) $(split(repl_input))`)
            return nothing
        end
    end
end
