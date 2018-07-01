Param(
    [Parameter(Mandatory = $true)]
    [bool]$Setup
)

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$config = (Get-Content -Raw -Path "$scriptDir\winwpunit.json" | ConvertFrom-Json).config

# Prerequisites
# 1. Git
# 2. Bedrock
# 3. Composer

# Step 0: Prepare your plugin
# * Add composer.json
# * Add phpunit.xml
# * Add bootstrap.php
# * Add wp-tests-config.php (update DB information)

# Step 1: Fetch (if not running setup)
if($Setup -eq $false) {

    Set-Location "$($config.dir)\$($config.tasks.git.plugin.repoName)\tests"
    git pull origin
    Set-Location $scriptDir

}
else {

    # Step 1: Create the working directory
    Remove-Item -Path $config.dir -Recurse -Force
    New-Item -ItemType Directory -Force -Path $config.dir

    # Step 2: Clone your plugin
    git clone -b $config.tasks.git.plugin.branch "https://github.com/$($config.tasks.git.plugin.userName)/$($config.tasks.git.plugin.repoName).git" "$($config.dir)\$($config.tasks.git.plugin.repoName)"

    # Step 3: Run composer to install packages / dependencies for the plugin and unit tests
    Set-Location "$($config.dir)\$($config.tasks.git.plugin.repoName)"
    composer install
    composer to install packages / dependencies for the unit tests
    Set-Location "$($config.dir)\$($config.tasks.git.plugin.repoName)\tests"
    composer install
    Set-Location $scriptDir

    # Step 4: Copy wordpress-develop tests/phpunit folder for the bootstrap file
    svn export "https://github.com/WordPress/wordpress-develop/trunk/tests/phpunit" "$($config.dir)\$($config.tasks.git.plugin.repoName)\tests\phpunit"

    # Step 5: Install a fresh copy of WordPress
    composer create-project roots/bedrock "$($config.dir)\$($config.tasks.git.plugin.repoName)\tests\wp"

    # Step 6: Create an empty DB for WordPress
    & "$scriptDir\Cmdlets\New-MySqlDb.ps1" `
        -DbHost $config.tasks.mysql.dbHost `
        -DbUser $config.tasks.mysql.dbUser `
        -DbUserPw $config.tasks.mysql.dbUserPw `
        -DbName $config.tasks.mysql.dbName `
        -DbPrefix $config.tasks.mysql.dbPrefix

}

# Step 7: Run unit tests
Set-Location "$($config.dir)\$($config.tasks.git.plugin.repoName)\tests"
vendor\bin\phpunit
Set-Location $scriptDir

