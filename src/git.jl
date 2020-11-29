function _git_cmd(str::AbstractString;
                  adjust_PATH::Bool = true,
                  adjust_LIBPATH::Bool = true)
    git_path, env_mapping = _env_mapping(; adjust_PATH = adjust_PATH,
                                           adjust_LIBPATH = adjust_LIBPATH)
    new_env = copy(ENV)
    for p in env_mapping
        new_env[p[1]] = p[2]
    end
    new_cmd = Cmd(`$(git_path) $(split(str))`; env = new_env)
    return new_cmd
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

function git(f::Function;
             adjust_PATH::Bool = true,
             adjust_LIBPATH::Bool = true)
    git_path, env_mapping = _env_mapping(; adjust_PATH = adjust_PATH,
                                           adjust_LIBPATH = adjust_LIBPATH)
    return withenv(env_mapping...) do
        return f(git_path)
    end
end
