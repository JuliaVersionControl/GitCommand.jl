module GitCommand

import Git_jll
import ReplMaker

# export @git_cmd
export git
export gitrepl

const GIT_REPL_MODE_NAME = "GitCommand.jl Git REPL mode"
const GIT_REPL_MODE_PROMPT_TEXT = "git> "
const GIT_REPL_MODE_START_KEY = ','

include("git.jl")
include("repl.jl")

end # end module GitCommand
