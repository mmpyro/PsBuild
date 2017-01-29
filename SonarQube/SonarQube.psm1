class SonarScanner
{
    hidden [string] $scanner 

    SonarScanner([string] $path) {
        $this.scanner = [System.IO.Path]::Combine($path,"SonarQube.Scanner.MSBuild.exe")
    }

    [void] BeginAnalitics([string] $key, [string] $projectName, [string]$version) {
        if( [String]::IsNullOrEmpty($key) -or [String]::IsNullOrEmpty($projectName)) {
            throw "Project name or key are null. These values are mandatory."
        }
        $args = @("begin", "/k:""$key""","/n:""$projectName""","/v:""$version""")
        & $this.scanner $args|Out-Host
    }

    [void] EndAnalitics() {
        $args = @('end')
        & $this.scanner $args|Out-Host
    }
}

function CreateSonarScanner([string] $path) {
    if([string]::IsNullOrEmpty($path)) {
        throw 'Path to Sonarqube scanner for msbuild cannot be null or empty.'
    }
    return [SonarScanner]::new($path)
}

Export-ModuleMember -Function CreateSonarScanner