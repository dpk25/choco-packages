$ErrorActionPreference = "Stop"

$TOOLS_DIR =    $(Split-Path -Parent $MyInvocation.MyCommand.Definition)
$INSTALL_DIR =  Join-Path $env:TEMP $PACKAGE
$PREINSTALL =   Join-Path $TOOLS_DIR 'preinstall.ps1'
$POSTINSTALL =  Join-Path $TOOLS_DIR 'postinstall.ps1'

$PACKAGE =      "{Package}"
$BUCKET =       "{Bucket}"
$INSTALLER =    "{Installer}"
$FILETYPE =     "{FileType}"
$ARGUMENTS =    "{Arguments}"
$VALID_CODES =  "{ValidCodes}"
$S3_URI =       "https://s3.amazonaws.com/$BUCKET/packages/$PACKAGE.zip"

Write-Output "Unzipping $PACKAGE From $S3_URI"
Install-ChocolateyZipPackage -PackageName $PACKAGE -Url $S3_URI -UnzipLocation $INSTALL_DIR

Write-Output "Running preinstall.ps1"
Invoke-Expression $PREINSTALL

$packageArgs = @{{
    packageName=$PACKAGE
    fileType=$FILETYPE
    file=$INSTALLER
    silentArgs=$ARGUMENTS
    validExitCodes=@($VALID_CODES) 
}}

Write-Output "Installing $PACKAGE With Args: $packageArgs"
Install-ChocolateyInstallPackage @packageArgs

Write-Output "Running postinstall.ps1"
Invoke-Expression $POSTINSTALL

Write-Output "$PACKAGE Install Complete!"

