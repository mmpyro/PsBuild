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
		$this.configuration = $null
        $this.maxCPU = 0
        $this.platform = $null
        $this.targetFramework = $null
    }

    [MsBuild] MsBuildPath([string] $path) {
        $this.msbuild = $path
        return $this
    }

    [MsBuild] Net4() {
        $this.targetFramework = 'v4.0'
        return $this
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

    [MsBuild] Net46() {
        $this.targetFramework = 'v4.6.1'
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
        Write-Host $args
        & $this.msbuild $args|Out-Host
    }

    hidden [string[]] CreateArgs() {
        $args = @()
        if([String]::IsNullOrEmpty($this.platform) -eq $false)  
        {
            $args += "/p:Platform=$($this.platform)"
        }

        if([String]::IsNullOrEmpty($this.configuration) -eq $false)
        {
            $args += "/p:Configuration=$($this.configuration)"
        }

        if([String]::IsNullOrEmpty($this.targetFramework) -eq $false)
        {
            $args += "/p:TargetFrameworkVersion=$($this.targetFramework)"
        }

        if($this.maxCPU -ne 0)
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