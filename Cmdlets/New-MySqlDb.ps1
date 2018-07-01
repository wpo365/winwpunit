Param(
    [Parameter(Mandatory = $true)]
    [string]$DbHost,
    [Parameter(Mandatory = $true)]
    [string]$DbUser,
    [Parameter(Mandatory = $false)]
    [string]$DbUserPw,
    [Parameter(Mandatory = $true)]
    [string]$DbName,
    [Parameter(Mandatory = $true)]
    [string]$DbPrefix
)

$ConnectionString = "server=" + $DbHost + ";port=3306;uid=" + $DbUser + ";pwd=" + $DbUserPw + ";SslMode=none"

$FullDbName = "$DbPrefix$DbName"

Try {
    [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
    $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $Connection.ConnectionString = $ConnectionString
    $Connection.Open()
    $Command = New-Object MySql.Data.MySqlClient.MySqlCommand
    $Command.Connection = $Connection

    # Drop if exists
    $Command.CommandText = "DROP DATABASE IF EXISTS $FullDbName;"
    $Result = $Command.ExecuteNonQuery()

    # Create new
    $Command.CommandText = "CREATE DATABASE $FullDbName;"
    $Result = $Command.ExecuteNonQuery()

    # Grant permissions
    # $Command.CommandText = "GRANT ALL PRIVILEGES ON $FullDbName.* TO "wordpressusername"@"hostname"
}
Catch {
    Write-Host "ERROR : Unable to run query $Error"
    $Error.clear()
}
Finally {
    $Connection.Close()
}