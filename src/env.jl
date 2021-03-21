function _env_mapping(; adjust_PATH::Bool = true,
                        adjust_LIBPATH::Bool = true)
    if Sys.iswindows()
        git_path, env_mapping = Git_jll.git(; adjust_PATH = adjust_PATH,
                                              adjust_LIBPATH = adjust_LIBPATH) do git_path
            env_mapping = Dict{String,String}()
            if haskey(ENV, "PATH")
                env_mapping["PATH"] = ENV["PATH"]
            end
            if haskey(ENV, JLLWrappers.LIBPATH_env)
                env_mapping[JLLWrappers.LIBPATH_env] = ENV[JLLWrappers.LIBPATH_env]
            end
            return git_path, env_mapping
        end
        return git_path, env_mapping
    end
    git_path, env_mapping = Git_jll.git(; adjust_PATH = adjust_PATH,
                                          adjust_LIBPATH = adjust_LIBPATH) do git_path
        sep = _separator()

        root = dirname(dirname(git_path))

        libexec = joinpath(root, "libexec")
        libexec_git_core = joinpath(libexec, "git-core")

        share = joinpath(root, "share")
        share_git_core = joinpath(share, "git-core")
        share_git_core_templates = joinpath(share_git_core, "templates")

        libcurlpath = dirname(Git_jll.LibCURL_jll.libcurl_path)
        originallibpath = get(ENV, JLLWrappers.LIBPATH_env, "")
        newlibpath = "$(libcurlpath)$(sep)$(originallibpath)"

        ssl_cert = joinpath(dirname(Sys.BINDIR), "share", "julia", "cert.pem")

        env_mapping = Dict{String,String}()
        env_mapping["GIT_EXEC_PATH"] = libexec_git_core
        env_mapping["GIT_SSL_CAINFO"] = ssl_cert
        env_mapping["GIT_TEMPLATE_DIR"] = share_git_core_templates
        env_mapping[JLLWrappers.LIBPATH_env] = newlibpath
        if haskey(ENV, "PATH")
            env_mapping["PATH"] = ENV["PATH"]
        end
        return git_path, env_mapping
    end
    return git_path, env_mapping
end
