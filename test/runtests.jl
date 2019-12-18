using GitCommand
using Test

# Some of the code in this file is based on:
# https://github.com/MasonProtter/ReplMaker.jl/blob/master/test/runtests.jl

Base.include(@__MODULE__, joinpath(Sys.BINDIR, "..", "share", "julia", "test", "testhelpers", "FakePTYs.jl"))
import .FakePTYs

const CTRL_C = '\x03'

function run_repl_test(test_script)
    slave, master = FakePTYs.open_fake_pty()
    # Start a julia process
    p = run(`$(Base.julia_cmd()) --code-coverage=user --history-file=no --startup-file=no --compiled-modules=no`, slave, slave, slave; wait=false)

    # Read until the prompt
    readuntil(master, "julia>", keep=true)
    done = false
    repl_output_buffer = IOBuffer()

    # A task that just keeps reading the output
    @async begin
        while true
            done && break
            write(repl_output_buffer, readavailable(master))
        end
    end

    # Execute our "script"
    for l in split(test_script, '\n'; keepempty=false)
        write(master, l, '\n')
    end

    # Let the REPL exit
    write(master, "exit()\n")
    wait(p)
    done = true

    # Gather the output
    repl_output = String(take!(repl_output_buffer))
    println(repl_output)
    return split(repl_output, '\n'; keepempty=false)
end

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

    with_temp_dir() do tmp_dir
        withenv("JULIA_DEBUG" => "all") do
            @test_throws UndefVarError gitrepl()
        end
    end

    with_temp_dir() do tmp_dir
        repl_test_script_1 = """
        import GitCommand
        GitCommand.gitrepl()
        ,clone https://github.com/JuliaRegistries/General
        """*CTRL_C
        @test !isdir("General")
        @test !isfile(joinpath("General", "Registry.toml"))
        if Sys.iswindows()
        else
            run_repl_test(repl_test_script_1)
            @test isdir("General")
            @test isfile(joinpath("General", "Registry.toml"))
        end
    end
end
