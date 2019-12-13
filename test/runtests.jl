using GitCommand
using Test

function with_temp_dir(f::Function)
    original_directory = pwd()
    tmp_dir = mktempdir()
    atexit(() -> rm(tmp_dir; force = true, recursive = true))
    cd(tmp_dir)
    result = f(tmp_dir)
    cd(original_directory)
    rm(tmp_dir; force = true, recursive = true)
    return result
end

@testset "GitCommand.jl" begin
    if Sys.iswindows()
        @test GitCommand._separator() == ';'
    else
        @test GitCommand._separator() == ':'
    end
    with_temp_dir() do tmp_dir
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        GitCommand.git_cmd() do git_path
            run(`$(git_path) clone https://github.com/JuliaRegistries/General`)
        end
        @test isdir("General")
        @test isfile(joinpath("General", "Registry.toml"))
    end
end
