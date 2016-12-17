Import-Module .\PSBuild.psm1 -Force
Import-Module .\MsBuild.psm1 -Force

$psBuild = CreatePsBuild
$msBuild = CreateMsBuild

$psBuild.Task('before', {
    write-host 'Before build'
})

$psBuild.Task('build',  {
    $msBuild.MaxCPU_Count(2).Net46().Platform_AnyCPU().Release().Rebuild('E:\Projects\Tests\GameOfLife\GameOfLife.sln')
})

$psBuild.Task('after', {
    write-host 'After build'
})

$psBuild.Task('default', @('before', 'build', 'after'), {})

RunTask $psBuild $args