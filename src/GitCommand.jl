module GitCommand

import Git_jll

export git
export @git_cmd

include("env_mapping.jl")
include("git_cmd.jl")
include("public.jl")
include("util.jl")

end # end module GitCommand
