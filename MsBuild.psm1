class MsBuild
{
    hidden [string] $targetFramework
    hidden [string] $platform
    hidden [string] $configuration
    hidden [string] $msbuild
    hidden [int] $maxCPU

    MsBuild() {
        $msBuild_4 = "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild.exe"        
        $this.msbuild = $msBuild_4
    }

    [MsBuild] Net45() {
        $this.targetFramework = 'v4.5'
        return $this
    }

    [MsBuild] Net452() {
        $this.targetFramework = 'v4.5.2'
        return $this
    }

    [MsBuild] Net46() {
        $this.targetFramework = 'v4.6'
        return $this
    }

    [MsBuild] Platform_x64() {
        $this.platform = 'x64'
        return $this
    }

    [MsBuild] Platform_x86() {
        $this.platform = 'x86'
        return $this
    }

    [MsBuild] Platform_AnyCPU() {
        $this.platform = '"Any CPU"'
        return $this
    }

    [MsBuild] Release() {
        $this.configuration = 'Release'
        return $this
    }

    [MsBuild] Debug() {
        $this.configuration = 'Debug'
        return $this
    }

    [MsBuild] Config([string] $configuration) {
        $this.configuration = $configuration
        return $this
    }

    [MsBuild] MaxCPU_Count([int] $numberOfCpu) {
        $this.maxCPU = $numberOfCpu
        return $this
    }


    [void] Build([string] $fileToBuild) {
        $args = $this.CreateArgs()
        $args += "/t:Build"
        $args += "$fileToBuild"
        & $this.msbuild $args|Out-Host
    }

    [void] Rebuild([string] $fileToBuild) {
        $args = $this.CreateArgs()
        $args += "/t:Rebuild"
        $args += "$fileToBuild"
        & $this.msbuild $args|Out-Host
    }

    hidden [string[]] CreateArgs() {
        $args = @()
        if($this.platform -ne $null) 
        {
            $args += "/p:Platform=$($this.platform)"
        }

        if($this.configuration -ne $null)
        {
            $args += "/p:Configuration=$($this.configuration)"
        }

        if($this.targetFramework -ne $null)
        {
            $args += "/p:TargetFrameworkVersion=$($this.targetFramework)"
        }

        if($this.maxCPU -ne $null)
        {
            $args += "/maxcpucount:$($this.maxCPU)"
        }
        return $args
    }
}

function CreateMsBuild()
{
    return [MsBuild]::new()
}

Export-ModuleMember -Function CreateMsBuild

<#
$build.MaxCPU_Count(2).Net46().Platform_AnyCPU().Release().Build('E:\Projects\Tests\GameOfLife\GameOfLife.sln')
#>