class PsBuild
{
    hidden $tab

    PsBuild() {
        $this.tab = @{}
    }

    [void]Task([string] $name, [System.Action] $fun ) {
        $this.tab[$name] = @{function = $fun; subTasks = $null}
    }

    [void]Task([string] $name, [string[]] $tasks,[System.Action] $fun ) {
        $this.tab[$name] = @{function = $fun; subTasks = $tasks}
    }

    [void]Run([string]$name) {
        $task = $this.tab[$name]
        if( $task.subTasks -ne $null) {
            $task.subTasks|% {$this.Run($_)}
        }
        $task.function.Invoke()
    }
}

function CreatePsBuild()
{
    return [PsBuild]::new()
}

function RunTask([PsBuild]$psBuild, $tasks)
{
    if($tasks.Count -gt 0) {
        $tasks|% {$psBuild.Run($_)}
    } else {
        $taskName = Read-Host 'Task name:'
        $psBuild.Run($taskName)
    }
}

Export-ModuleMember -Function CreatePsBuild, RunTask