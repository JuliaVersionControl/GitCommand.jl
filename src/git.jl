function _git_cmd(str::AbstractString;
                  adjust_PATH::Bool = true,
                  adjust_LIBPATH::Bool = true)
    git_path, env_mapping = _env_mapping(; adjust_PATH, adjust_LIBPATH)
    return addenv(`$(git_path) $(split(str))`, env_mapping)
end

macro git_cmd(ex)
    return _git_cmd(ex)
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

function git(;
             adjust_PATH::Bool = true,
             adjust_LIBPATH::Bool = true)
    git_path, env_mapping = _env_mapping(; adjust_PATH, adjust_LIBPATH)
    return addenv(`$(git_path)`, env_mapping...)
end

# This function should be deprecated, it's kept only for backward-compatibility
function git(f::Function;
             adjust_PATH::Bool = true,
             adjust_LIBPATH::Bool = true)
    return f(git(; adjust_PATH, adjust_LIBPATH))
end
