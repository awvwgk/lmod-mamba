-- SPDX-Identifier: Unlicense

-- adjust prefix to actual installation, assumes default ~/miniforge installation
local prefix = pathJoin(os.getenv["HOME"], "miniforge")  -- adjust prefix

prepend_path("PATH", pathJoin(prefix, "bin"))

local conda_sh = pathJoin(prefix, "etc", "profile.d", "conda."..myShellType())

cmd = "source " .. conda_sh .. "; conda activate base"
execute{cmd=cmd, modeA={"load"}}

if (myShellType() == "csh") then
  -- csh sets these environment variables and an alias for conda
  cmd = "unsetenv CONDA_EXE; unsetenv _CONDA_ROOT; unsetenv _CONDA_EXE; " ..
        "unsetenv CONDA_SHLVL; unalias conda"
  execute{cmd=cmd, modeA={"unload"}}
end
if (myShellType() == "sh") then
  -- bash sets environment variables, shell functions and path to condabin
  if (mode() == "unload") then
    remove_path("PATH", pathJoin(prefix, "condabin"))
  end
  cmd = "conda deactivate; unset CONDA_EXE; unset _CE_CONDA; unset _CE_M; " ..
        "unset -f __conda_activate; unset -f __conda_reactivate; " .. 
        "unset -f __conda_hashr; unset CONDA_SHLVL; unset _CONDA_EXE; " .. 
        "unset _CONDA_ROOT; unset -f conda"
  execute{cmd=cmd, modeA={"unload"}}
end
