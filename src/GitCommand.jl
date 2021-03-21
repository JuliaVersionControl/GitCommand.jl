module GitCommand

import JLLWrappers
import Git_jll
import ReplMaker

# export @git_cmd
export git
export gitrepl

const GIT_REPL_MODE_NAME = "GitCommand.jl Git REPL mode"
const GIT_REPL_MODE_PROMPT_TEXT = "git> "
const GIT_REPL_MODE_START_KEY = ','

include("env.jl")
include("git.jl")
include("repl.jl")
include("utils.jl")

end # end module GitCommand
