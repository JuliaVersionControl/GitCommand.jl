macro git_cmd(ex)
    return _git_cmd(ex)
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
