
$directory = $(Get-ChildItem -Path $(Get-Location))

foreach ($item in $directory) {
   Get-Acl $item   
}
