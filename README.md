# GitCommand

[![CI](https://github.com/JuliaVersionControl/GitCommand.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaVersionControl/GitCommand.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/JuliaVersionControl/GitCommand.jl/branch/master/graph/badge.svg?token=cdXpiH0OJ3)](https://codecov.io/gh/JuliaVersionControl/GitCommand.jl)

GitCommand allows you to use command-line Git in your Julia packages. You do
not need to have Git installed on your computer, and neither do the users of
your packages!

GitCommand provides a Git binary via
[Git_jll](https://github.com/JuliaBinaryWrappers/Git_jll.jl).
The latest version of GitCommand requires at least Julia 1.6.

GitCommand is intended to work on any platform that supports Julia,
including (but not limited to) Windows, macOS, Linux, and FreeBSD.

## Examples

```julia
julia> using GitCommand

julia> run(`$(git()) clone https://github.com/JuliaRegistries/General`)
```

## Git REPL mode

```julia
julia> using GitCommand

julia> gitrepl() # you only need to run this once per Julia session

# Press , to enter the Git REPL mode

git> clone https://github.com/JuliaRegistries/General
```

## Acknowledgements

- This work was supported in part by National Institutes of Health grants U54GM115677, R01LM011963, and R25MH116440. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.
