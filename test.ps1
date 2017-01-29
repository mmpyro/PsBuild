Import-Module .\PSBuild.psd1 -Force
Import-Module .\MsBuild.psd1 -Force
Import-Module .\SonarQube.psm1 -Force

$psBuild = CreatePsBuild
$msBuild = CreateMsBuild
$sonarQube = CreateSonarScanner('E:\sonar-scanner-msbuild-2.2.0.24')

$projectDir = 'E:\Projects\aspnet_core\test'

Push-Location
cd $projectDir

$psBuild.Task('before', {
    write-host 'Before build'
    $name = 'Core'
    $key = "org.sonarqube:$name"
    $sonarQube.BeginAnalitics($key, $name,'1.0')
})

$psBuild.Task('build',  {
#    $msBuild.MaxCPU_Count(2).Net46().Platform_AnyCPU().Release().Rebuild("$projectDir\test.csproj")
    $msBuild.Rebuild("test.csproj")
})

$psBuild.Task('after', {
    write-host 'After build'
    $sonarQube.EndAnalitics()
})

$psBuild.Task('default', @('before', 'build', 'after'), {})

#RunTask $psBuild $args
RunTask $psBuild 'default'

Pop-Location