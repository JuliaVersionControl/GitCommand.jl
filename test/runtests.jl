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
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        git() do git
            @test !isdir("General")
            @test !isfile(joinpath("General", "Registry.toml"))
            run(`$git clone https://github.com/JuliaRegistries/General`)
        end
        @test isdir("General")
        @test isfile(joinpath("General", "Registry.toml"))
    end

    with_temp_dir() do tmp_dir
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        cmd = GitCommand.git`clone https://github.com/JuliaRegistries/General`
        @test cmd isa Cmd
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        run(cmd)
        @test isdir("General")
        @test isfile(joinpath("General", "Registry.toml"))
    end

    with_temp_dir() do tmp_dir
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        expr = GitCommand._gitrepl_parser("clone https://github.com/JuliaRegistries/General")
        @test expr isa Expr
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        @eval $(expr)
        @test isdir("General")
        @test isfile(joinpath("General", "Registry.toml"))
    end
end
