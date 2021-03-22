using GitCommand
using Test

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
