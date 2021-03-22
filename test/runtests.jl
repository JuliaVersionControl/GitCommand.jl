using GitCommand
using Test

import JLLWrappers
import REPL

get_env(env) = get(ENV, env, nothing)

const orig_libpath     = deepcopy(get_env(JLLWrappers.LIBPATH_env))
const orig_execpath    = deepcopy(get_env("GIT_EXEC_PATH"))
const orig_cainfo      = deepcopy(get_env("GIT_SSL_CAINFO"))
const orig_templatedir = deepcopy(get_env("GIT_TEMPLATE_DIR"))

include("test-utils.jl")

@testset "GitCommand.jl" begin
    if Sys.iswindows()
        @test GitCommand._separator() == ';'
    else
        @test GitCommand._separator() == ':'
    end

    with_temp_dir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        run(`$(git()) clone https://github.com/JuliaVersionControl/GitCommand.jl`)
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end

    with_temp_dir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        git() do git
            @test !isdir("GitCommand.jl")
            @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
            run(`$git clone https://github.com/JuliaVersionControl/GitCommand.jl`)
        end
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end

    with_temp_dir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        cmd = GitCommand.git`clone https://github.com/JuliaVersionControl/GitCommand.jl`
        @test cmd isa Cmd
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        run(cmd)
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end

    with_temp_dir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        expr = GitCommand._gitrepl_parser("clone https://github.com/JuliaVersionControl/GitCommand.jl")
        @test expr isa Expr
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        @eval $(expr)
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end
end

@testset "Safety" begin
    # Make sure `git` commands don't leak environment variables
    @test orig_libpath == get_env(JLLWrappers.LIBPATH_env)
    @test orig_execpath == get_env("GIT_EXEC_PATH")
    @test orig_cainfo == get_env("GIT_SSL_CAINFO")
    @test orig_templatedir == get_env("GIT_TEMPLATE_DIR")
end

@testset "init REPL" begin 
    @test GitCommand.gitrepl(; repl = REPL.BasicREPL) == nothing
end
