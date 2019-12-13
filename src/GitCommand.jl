module GitCommand

import Git_jll

export git_cmd

function _separator()
    if Sys.iswindows()
        return ';'
    end
    return ':'
end

function git_cmd(f::Function;
                 adjust_PATH::Bool = true,
                 adjust_LIBPATH::Bool = true)
    return Git_jll.git(;
                       adjust_PATH = adjust_PATH,
                       adjust_LIBPATH = adjust_LIBPATH) do git_path
        git_core = joinpath(dirname(dirname(git_path)),
                            "libexec",
                            "git-core")
        libcurlpath = dirname(Git_jll.LibCURL_jll.libcurl_path)
        originallibpath = get(ENV, Git_jll.LIBPATH_env, "")
        ssl_cert = joinpath(dirname(Sys.BINDIR),
                            "share",
                            "julia",
                            "cert.pem")

        sep = _separator()

        env_mapping = Dict{String,String}()
        env_mapping["GIT_EXEC_PATH"] = git_core
        env_mapping["GIT_SSL_CAINFO"] = ssl_cert
        env_mapping[Git_jll.LIBPATH_env] = "$(libcurlpath)$(sep)$(originallibpath)"

        return withenv(env_mapping...) do
            return f(git_path)
        end
    end
end

end # end module GitCommand
