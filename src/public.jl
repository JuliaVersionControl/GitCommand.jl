function git(f::Function;
             adjust_PATH::Bool = true,
             adjust_LIBPATH::Bool = true)
    git_path, env_mapping = _env_mapping(; adjust_PATH = adjust_PATH,
                                           adjust_LIBPATH = adjust_LIBPATH)
    return withenv(env_mapping...) do
        return f(git_path)
    end
end

function gitrepl(; mode_name = GIT_REPL_MODE_NAME,
                   prompt_text = GIT_REPL_MODE_PROMPT_TEXT,
                   start_key = GIT_REPL_MODE_START_KEY,
                   kwargs...)::Nothing
    _gitrepl(; mode_name = mode_name,
               prompt_text = prompt_text,
               start_key = start_key,
               kwargs...)
    return nothing
end
