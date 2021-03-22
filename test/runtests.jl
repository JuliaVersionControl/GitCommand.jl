using GitCommand
using Test

import JLLWrappers

get_env(name) = get(ENV, name, nothing)
const orig_libpath     = deepcopy(get_env(JLLWrappers.LIBPATH_env))
const orig_execpath    = deepcopy(get_env("GIT_EXEC_PATH"))
const orig_cainfo      = deepcopy(get_env("GIT_SSL_CAINFO"))
const orig_templatedir = deepcopy(get_env("GIT_TEMPLATE_DIR"))

function withtempdir(f::Function)
    mktempdir() do tmp_dir
        cd(tmp_dir) do
            f(tmp_dir)
        end
    end
    return nothing
end

@testset "GitCommand.jl" begin
    withtempdir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        run(`$(git()) clone https://github.com/JuliaVersionControl/GitCommand.jl`)
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end

    withtempdir() do tmp_dir
        @test !isdir("GitCommand.jl")
        @test !isfile(joinpath("GitCommand.jl", "Project.toml"))
        run(`$(git()) clone https://github.com/JuliaVersionControl/GitCommand.jl`)
        @test isdir("GitCommand.jl")
        @test isfile(joinpath("GitCommand.jl", "Project.toml"))
    end

    withtempdir() do tmp_dir
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

end

@testset "Safety" begin
    # Make sure `git` commands don't leak environment variables
    @test orig_libpath == get_env(JLLWrappers.LIBPATH_env)
    @test orig_execpath == get_env("GIT_EXEC_PATH")
    @test orig_cainfo == get_env("GIT_SSL_CAINFO")
    @test orig_templatedir == get_env("GIT_TEMPLATE_DIR")
end
