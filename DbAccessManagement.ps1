
#################################################### LOAD ASSEMBLY (DDL'S .NET 4.x) ####################################################

#### LOAD SYBASE ASE (Sybase.AdoNet4.AseClient.dll)

$validapath = Test-Path 'C:\Sybase\DataAccess\ADONET\dll\Sybase.AdoNet4.AseClient.dll'
if ($validapath -eq "true")
{
    $assemblyPath = 'C:\Sybase\DataAccess\ADONET\dll\Sybase.AdoNet4.AseClient.dll'
    $AsefullName = [System.Reflection.AssemblyName]::GetAssemblyName($assemblyPath).FullName
    [System.Reflection.Assembly]::Load($AsefullName)
}
else
{
    Write-host "LIB Sybase.AdoNet4.AseClient.dll NOT LOADED"
}

#### LOAD ORACLE (Oracle.DataAccess.dll)


$odpfile = Test-Path "C:\Oracle\product\19.0.0\client_1\ODP.NET\bin\4\Oracle.DataAccess.dll"
if ($odpfile -eq "true")
{
    Add-Type -Path "C:\Oracle\product\19.0.0\client_1\ODP.NET\bin\4\Oracle.DataAccess.dll"
}
else
{
    Write-Host "LIB Oracle.DataAccess.dll NOT LOADED"
}


######  LOAD MySQL 8.0 (MySql.Data.dll)
$validapath = Test-Path 'C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll'
if ($validapath -eq "true")
{
    $assemblyPath = 'C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll'
    $MySQLFullName = [System.Reflection.AssemblyName]::GetAssemblyName($assemblyPath).FullName
    [System.Reflection.Assembly]::Load($MySQLFullName)
}
else
{
    Write-Host "LIB MySql.Data.dll NOT LOADED"
}


#################################################### FUNCOES DE UTILITARIOS ####################################################

#### FUNCAO DE ARMAZEANAMENTO DE CREDENCIAL COM VARIAVEL DE SCOPO DE SCRIPT
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


Function credencial
{
    Write-Warning "CREDENCIAL DE PROPOSITOS GERAIS / EMAIL"
    $script:credencial = Get-Credential
}


#### FUNCAO DE GERACAO DE CARACTERES RANDOMICOS
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function Randomicos
{
    
    $array =  @{X = 'a','b','c','d','e','f','g','j','i','j','v','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'; 
                Y = 'Q','R','S','T','U','V','W','X','Y','Z','A','B','C','D','E','F','G','J','I','K','L','M','N','J','V','O','P'; 
                Z= 0,1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,0,6,5,4,7,8,9,3,2,1,7,4,1,2,5,8,9,6,3,1,4,6,8,4,3,5,7,1,5,9,6,5,4}
   
            
            $valorhash = $null
            for ($i=0; $i -le 3; $i++)
            {
                do {
                        Start-Sleep -Milliseconds "1$($i)"
                        $random1 = (get-date).ToString('fffffff') -split ""
                        $EixoX = $random1[1..7]
                        $EixoX = $EixoX[1..2] -join ""
                    } until ($EixoX -le 26)
                
                do {
                        Start-Sleep -Milliseconds "2$($i)"
                        $random1 = (get-date).ToString('fffffff') -split ""
                        $EixoY = $random1[1..7]
                        $EixoY = $EixoY[3..4] -join ""
                    } until ($EixoY -le 26)
                
                do {
                        Start-Sleep -Milliseconds "3$($i)"
                        $random1 = (get-date).ToString('fffffff') -split ""
                        $EixoZ = $random1[1..7]
                        $EixoZ = $EixoZ[5..6] -join ""
                    } until ($EixoZ -le 26)

                do {
                        Start-Sleep -Milliseconds "1$($i)"
                        $random1 = (get-date).ToString('fffffff') -split ""
                        $EixoX2 = $random1[1..7]
                        $EixoX2 = $EixoX2[2..3] -join ""
                    } until ($EixoX2 -le 26)
                

                $valorhash = "$($valorhash)$($array.X[$EixoX])$($array.Y[$EixoY])$($array.Z[$EixoZ])$($array.X[$EixoX2])"
            }
            
            write-output $valorhash
    

}

##################### EMAIL

#### FUNCAO DE QUE PARAMETRIZA O SMTP DO OFFICE365 PARA AUXILIAR NA EXECUÇÃO
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function EnviaEMailOffice
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
            [string]$destinatario,
            [string]$emailtitle,
            [string]$emailbody,
            [string]$anexo
         )
    $contaemail = $script:credencial.UserName
    if (!$anexo)
    {
        Send-MailMessage -To $destinatario -from $contaemail -Subject $emailtitle -Body $emailbody -Encoding ASCII -smtpserver smtp.office365.com -usessl -Credential $script:credencial -Port 587 
    }
    else
    {
        Send-MailMessage -To $destinatario -from $contaemail -Subject $emailtitle -Body $emailbody -Encoding ASCII -Attachments $anexo -smtpserver smtp.office365.com -usessl -Credential $script:credencial -Port 587 
    }
}

#################################################### MICROSOFT SQL SERVER FUNCOES .NET REUTILIZAVEIS ####################################################

### FUNCOES DE CONEXAO E QUERY MICROSOFT SQL COM .NET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


Function testeconnect-mssql
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
            [string]$instancia,
            [string]$banco
         )
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Data Source=$instancia;Initial Catalog=$banco;Integrated Security = True;"
    $sqlConnection.Open()
    $sqlConnection.State
    $sqlConnection.Close()
    $sqlConnection.State
}


### FUNCAO QUE NAO POSSUI DATASET PARA EXECUCAO DE DDL'S, DCL'S E DML'S NO MICROSOFT SQL COM .NET (NAO EXECUTA SELECT)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function change-mssql
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
            [string]$instancia,
            [string]$banco,
            [string]$dml
         )
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Data Source=$instancia;Initial Catalog=$banco;Integrated Security = True"
    $sqlConnection.Open()

    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlcmd.CommandText = $dml
    $sqlcmd.Connection = $sqlConnection
    $sqlcmd.ExecuteNonQuery()
    $sqlConnection.Close()
}

### FUNCAO QUE POSSUI DATASET PARA EXECUCAO DML'S DE SELECT NO MICROSOFT SQL COM .NET (EXECUTA SELECT)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function select-mssql
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
            [string]$instancia,
            [string]$banco,
            [string]$dml
         )
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Data Source=$instancia;Initial Catalog=$banco;Integrated Security = True;"
    $sqlConnection.Open()

    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlcmd.CommandText = $dml
    $sqlcmd.Connection = $sqlConnection

    $sqladapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $sqladapter.SelectCommand = $sqlcmd
    $DataSet = New-Object System.Data.DataSet
    $sqladapter.Fill($DataSet)
    $dataset.Tables
    $sqlConnection.Close()
}


### FUNCAO DE VALIDACAOO DO ALWAYS-ON
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


function MsSql-ValidaAlwaysON
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
            [string]$tipo,
            [string]$instancia,
            [string]$usuario,
            [string]$dominio
         )
    if ($tipo -eq "SQL")
    {
           $agname = (select-mssql -instancia $instancia -banco master -dml "select name from sys.availability_groups").name
           if (!$agname)
           {
                Write-Host "A INSTANCIA $instancia NAO POSSUI AVAILABILITY GROUPS"
           }
           else
           {
                
                Write-Warning "A INSTANCIA $instancia POSSUI O AVAILABILITY GROUP $agname"
                $replicaprimaria = (select-mssql -instancia $instancia -banco master -dml "select replica_server_name from sys.availability_replicas where replica_metadata_id is not null").replica_server_name
                write-host "REPLICA PRIMARIA: $replicaprimaria"
                $loginpri = (select-mssql -instancia $instancia -banco master -dml "select name, createdate from syslogins where name = '$usuario'").name
                if ($loginpri -eq "$usuario")
                {                 
        
                        Write-Host "SEGUE LOGIN $usuario na REPLICA PRIMARIA $replicaprimaria"
                        $loginpri
                        
                        $loginsidpri = sqlcmd -E -S $instancia -d master -Q "select sid from syslogins where name = '$usuario'"
                        $loginsidpri = $loginsidpri -split "/n"
                        $loginsidpri = $loginsidpri[2]
                        $loginsidpri

                        $loginpasswordpri = sqlcmd -E -S $instancia -d master -Q "select password_hash from sys.sql_logins where name = '$usuario'"
                        $loginpasswordpri = $loginpasswordpri -split "/n"
                        $loginpasswordpri = $loginpasswordpri[2]
        
                        $replicaecundaria = (select-mssql -instancia $instancia -banco master -dml "select replica_server_name from sys.availability_replicas where replica_metadata_id is null").replica_server_name
        
                        Write-Host "REPLICAS SECUNDARIAS: $replicaecundaria"
                        foreach ($replica in $replicaecundaria)
                        {    
                            $validaloginsecundaria = (select-mssql -instancia $replica -banco master -dml "select name from syslogins where name = '$usuario'").name
                            if (!$validaloginsecundaria)
                            {
                                Write-Warning "LOGIN $usuario NAO EXISTA NA REPLICA $replica EXECUTANDO CRIACAO"
                                sqlcmd -E -S $replica -d master -Q "create login $usuario with password = $loginpasswordpri hashed, sid = $loginsidpri"
              
                            }
                            else
                            {
                                Write-Warning "SEGUE LOGIN $usuario na REPLICA SECUNDï¿½RIA $replica"
                
                                select-mssql -instancia $replica -banco master -dml "select name, createdate from syslogins where name = '$usuario'"
                                $loginsidsec = sqlcmd -E -S $replica -d master -Q "select sid from syslogins where name = '$usuario'"
                                $loginsidsec = $loginsidsec -split "/n"
                                $loginsidsec = $loginsidsec[2]
                                $loginsidsec

                                $loginpasswordsec = sqlcmd -E -S $replica -d master -Q "select password_hash from sys.sql_logins where name = '$usuario'"
                                $loginpasswordsec = $loginpasswordsec -split "/n"
                                $loginpasswordsec = $loginpasswordsec[2]

                                if ($loginsidsec -ne $loginsidpri)
                                {
                                    Write-Warning "LOGIN $usuario COM SID DIFERENTE, REALIZANDO AJUSTES"
                                    sqlcmd -E -S $replica -d master -Q "drop login $usuario"
                                    sqlcmd -E -S $replica -d master -Q "create login $usuario with password = $loginpasswordpri hashed, sid = $loginsidpri"
                                }
                                else
                                {
                                    Write-Host "LOGIN $usuario POSSUI O MESMO SID DA REPLICA PRIMARIA"
                    
                                    if ($loginpasswordpri -ne $loginpasswordsec)
                                    {
                                        Write-Warning "LOGIN $usuario COM PASSWORD DIFERENTE, REALIZANDO AJUSTES"
                                        sqlcmd -E -S $replica -d master -Q "drop login $usuario"
                                        sqlcmd -E -S $replica -d master -Q "create login $usuario with password = $loginpasswordpri hashed, sid = $loginsidpri"
                                    }

                                    else
                                    {
                                        Write-Host "LOGIN $usuario POSSUI O MESMO PASSWORD DA REPLICA PRIMARIA"
                                    }
                                }

                            }
                        } 
                }
                else
                {
                    Write-Warning "LOGIN $usuario NAO EXISTE NA REPLICA PRIMARIA $replicaprimaria"
                }
            }
    }
    elseif ($tipo -eq "WINDOWS")
    {
        if (!$dominio)
        {
            Write-Warning "PARA LOGINS DO TIPO WINDOWS E NECESSARIO INFORMAR UM VALOR PARA VARIAVEL DOMINIO"
        }
        else
        {   
            $agname = (select-mssql -instancia $instancia -banco master -dml "select name from sys.availability_groups").name
            if (!$agname)
            {
                Write-Host "A INSTANCIA $instancia NAO POSSUI AVAILABILITY GROUPS"
            }
            else
            {
                Write-Warning "A INSTANCIA $instancia POSSUI O AVAILABILITY GROUP $agname"
                $replicaprimaria = (select-mssql -instancia $instancia -banco master -dml "select replica_server_name from sys.availability_replicas where replica_metadata_id is not null").replica_server_name
                write-host "REPLICA PRIMARIA: $replicaprimaria"
                $loginpri = (select-mssql -instancia $instancia -banco master -dml "select name, createdate from syslogins where name = '$dominio\$usuario'").name
                if ($loginpri -eq "$dominio\$usuario")
                {
                        Write-Host "SEGUE LOGIN [$dominio\$usuario] na REPLICA PRIMARIA $replicaprimaria"
                        Write-host $loginpri
                
                        $replicaecundaria = (select-mssql -instancia $instancia -banco master -dml "select replica_server_name from sys.availability_replicas where replica_metadata_id is null").replica_server_name
        
                        Write-Host "REPLICAS SECUNDARIAS: $replicaecundaria"
                        foreach ($replica in $replicaecundaria)
                        {    
                            $validaloginsecundaria = (select-mssql -instancia $replica -banco master -dml "select name from syslogins where name = '$dominio\$usuario'").name
                            if (!$validaloginsecundaria)
                            {
                                Write-Warning "LOGIN [$dominio\$usuario]  NAO EXISTA NA REPLICA $replica EXECUTANDO CRIACAO"
                                sqlcmd -E -S $replica -d master -Q "create login [$dominio\$usuario] from windows with default_database=[DBLOG]"
                                Start-Sleep -Seconds 5
                                Write-Host "LOGIN [$dominio\$usuario] CRIADO, SEGUE VALIDACAOO"
                                select-mssql -instancia $replica -banco master -dml "select name, createdate from syslogins where name = '$dominio\$usuario'"
                            }
                            else
                            {
                                Write-Host "LOGIN [$dominio\$usuario] EXISTE NA REPLICA $replica"
                            }
                        }
                }
                else
                {
                    Write-Warning "LOGIN [$dominio\$usuario] NAO EXISTE NA REPLICA PRIMARIA $replicaprimaria"
                }
            }
        }
    }
    elseif (!$tipo)
    {
        Write-Warning "A VARIAVEL TIPO DEVE TER OS VALORES SQL OU WINDOWS"
    }
    elseif ($tipo -ne "SQL" -or $tipo -ne "WINDOWS")
    {
        Write-Warning "A VARIAVEL TIPO DEVE TER OS VALORES SQL OU WINDOWS"
    }
}


### FUNCAO DE ATUALIZACAO DO BANCO DE DADOS DBAccessManagement
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function Update-DBAccessManagement
{
        [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$nmdatabases,
                [string]$nminstancia,
                [string]$Nusolicitacao,
                [string]$solicitante,
                [string]$logindb,
                [string]$descricao,
                [string]$ambiente,
                [string]$plataforma,
                [string]$tipo,
                [switch]$bypassconfirmation
             )
        $resultset = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "
        select 
                sol.Nusolicitacao,
                sol.solicitante,
                sol.executor,
                sol.DataExecucao
                from TbSolicitacao sol                
                where sol.Nusolicitacao = '$Nusolicitacao'"

    $solicitacao = $resultset.Nusolicitacao
    if (!$solicitacao)
    {
            $executor = $env:username
            $dataexecucao = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
            change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into TBSolicitacao values ('$Nusolicitacao','$solicitante','$executor','$dataexecucao','$descricao','$logindb','$ambiente','$plataforma','$tipo')"
                        
            $databases = $nmdatabases| ForEach-Object {$_ -replace " ",""} | ForEach-Object {$_ -split ","} 
            foreach ($nmdatabase in $databases)
            {
                $validadatabase = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nmdatabase, cddatabase from tbdatabase where nmdatabase = '$nmdatabase'"
                $nomebase = $validadatabase.nmdatabase
                if (!$nomebase)
                {
                    change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into TBDatabase values ('$nmdatabase')" 
                }
                else
                {
                    Write-Warning "$nomebase CADASTRADO NO DATABASE DE AUDITORIA"
                }
            }
            
            $validainstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nminstancia, cdinstancia from tbinstancia where nminstancia = '$nminstancia'"
            $Cdinstancia = $validainstancia.cdinstancia
            $instancia = $validainstancia.nminstancia
            if (!$instancia)
            {
                change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into TBInstancia values ('$nminstancia')"
            }
            else
            {
                Write-Warning "$instancia CADASTRADA NO DATABASE DE AUDITORIA"
            }
            
            $databases = $nmdatabases| ForEach-Object {$_ -replace " ",""} | ForEach-Object {$_ -split ","} 
            foreach ($nmdatabase in $databases)
            {
                $validadatabase = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nmdatabase, cddatabase from tbdatabase where nmdatabase = '$nmdatabase'"
                $cddatabase = $validadatabase.cddatabase
                
                $validainstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nminstancia, cdinstancia from tbinstancia where nminstancia = '$nminstancia'"
                $Cdinstancia = $validainstancia.cdinstancia
               
               $validatbdatabaseinstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select 1 from tbDatabaseInstancia where NuSolicitacao = '$Nusolicitacao' and cddatabase = $Cddatabase and cdinstancia = $Cdinstancia"
                if ($validatbdatabaseinstancia -eq 1)
                {
                    Write-Warning "RELACIONAMENTO CADASTRADO NO DATABASE DE AUDITORIA"
                    select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select 1 from tbDatabaseInstancia where NuSolicitacao = '$Nusolicitacao' and cddatabase = $Cddatabase and cdinstancia = $Cdinstancia"
                }
                else
                {
                    Write-host "EXECUTANDO CADASTRO DE RELACIONAMENTO"
                    change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into tbdatabaseinstancia values ($Cddatabase,$Cdinstancia,'$Nusolicitacao')"
                }
            }

        select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "
        select 
        sol.Nusolicitacao,
        sol.solicitante,
        sol.executor,
        sol.DataExecucao,
		db.nmdatabase,
        inst.nminstancia,
        db.cddatabase,
        inst.cdinstancia
        from tbdatabaseinstancia dbinstsol
        inner join tbsolicitacao sol on (dbinstsol.NuSolicitacao = sol.NuSolicitacao)
		inner join tbdatabase db on (dbinstsol.cddatabase = db.cddatabase)
        inner join tbinstancia inst on (dbinstsol.cdinstancia = inst.cdinstancia)
        where sol.Nusolicitacao = '$Nusolicitacao'" | Format-Table
    }
    else
    {
        Write-Warning "SOLICITACAO $solicitacao CADASTRADA NO DATABASE DE AUDITORIA"

        select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "
        select 
        sol.Nusolicitacao,
        sol.solicitante,
        sol.executor,
        sol.DataExecucao,
		db.nmdatabase,
        inst.nminstancia,
        db.cddatabase,
        inst.cdinstancia
        from tbdatabaseinstancia dbinstsol
        inner join tbsolicitacao sol on (dbinstsol.NuSolicitacao = sol.NuSolicitacao)
		inner join tbdatabase db on (dbinstsol.cddatabase = db.cddatabase)
        inner join tbinstancia inst on (dbinstsol.cdinstancia = inst.cdinstancia)
        where sol.Nusolicitacao = '$Nusolicitacao'" | Format-Table

            if ($bypassconfirmation)
            {
                $updateaudit = "S"
            }
            else
            {
                do {
                        $updateaudit = Read-Host "DESEJA ATUALIZAR OS DADOS DA SOLICITACAO $solicitacao (S OU N)"
                    } until ($updateaudit -eq "S" -or $updateaudit -eq "N")
            }

            if ($updateaudit -eq "S")
            {
                $executor = $env:username
                $dataexecucao = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
                change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "update TBSolicitacao set solicitante = '$solicitante', executor = '$executor', dataexecucao = '$dataexecucao', descricao = '$descricao', Usuario = '$logindb' , ambiente = '$ambiente', plataforma = '$plataforma', tipo = '$tipo' where Nusolicitacao = '$Nusolicitacao'"

                $databases = $nmdatabases| ForEach-Object {$_ -replace " ",""} | ForEach-Object {$_ -split ","} 
                foreach ($nmdatabase in $databases)
                {
                    $validadatabase = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nmdatabase, cddatabase from tbdatabase where nmdatabase = '$nmdatabase'"
                    $nomebase = $validadatabase.nmdatabase
                    if (!$nomebase)
                    {
                        change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into TBDatabase values ('$nmdatabase')" 
                    }
                    else
                    {
                        Write-Warning "$nomebase CADASTRADO NO DATABASE DE AUDITORIA"
                    }
                }
            
                $validainstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nminstancia, cdinstancia from tbinstancia where nminstancia = '$nminstancia'"
                $Cdinstancia = $validainstancia.cdinstancia
                $instancia = $validainstancia.nminstancia
                if (!$instancia)
                {
                    change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into TBInstancia values ('$nminstancia')"
                }
                else
                {
                    Write-Warning "$instancia CADASTRADA NO DATABASE DE AUDITORIA"
                }
            
                $databases = $nmdatabases| ForEach-Object {$_ -replace " ",""} | ForEach-Object {$_ -split ","} 
                foreach ($nmdatabase in $databases)
                {
                    $validadatabase = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nmdatabase, cddatabase from tbdatabase where nmdatabase = '$nmdatabase'"
                    $cddatabase = $validadatabase.cddatabase
                
                    $validainstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select nminstancia, cdinstancia from tbinstancia where nminstancia = '$nminstancia'"
                    $Cdinstancia = $validainstancia.cdinstancia
               
                   $validatbdatabaseinstancia = select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select 1 from tbDatabaseInstancia where NuSolicitacao = '$Nusolicitacao' and cddatabase = $Cddatabase and cdinstancia = $Cdinstancia"
                    if ($validatbdatabaseinstancia -eq 1)
                    {
                        Write-Warning "RELACIONAMENTO CADASTRADO NO DATABASE DE AUDITORIA"
                        select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "select 1 from tbDatabaseInstancia where NuSolicitacao = '$Nusolicitacao' and cddatabase = $Cddatabase and cdinstancia = $Cdinstancia"
                    }
                    else
                    {
                        Write-host "EXECUTANDO CADASTRO DE RELACIONAMENTO"
                        change-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "insert into tbdatabaseinstancia values ($Cddatabase,$Cdinstancia,'$Nusolicitacao')"
                    }
                }

            select-mssql -instancia $script:DBAccessManagement -banco DBAccessManagement -dml "
            select 
            sol.Nusolicitacao,
            sol.solicitante,
            sol.executor,
            sol.DataExecucao,
			db.nmdatabase,
            inst.nminstancia,
            db.cddatabase,
            inst.cdinstancia
            from tbdatabaseinstancia dbinstsol
            inner join tbsolicitacao sol on (dbinstsol.NuSolicitacao = sol.NuSolicitacao)
			inner join tbdatabase db on (dbinstsol.cddatabase = db.cddatabase)
            inner join tbinstancia inst on (dbinstsol.cdinstancia = inst.cdinstancia)
            where sol.Nusolicitacao = '$Nusolicitacao'" | Format-Table
            
        }
        elseif ($updateaudit -eq "N")
        {
            Write-Warning "DADOS DA SOLICITACAO $solicitacao MANTIDOS"
            $resultset
        }
    }   
}


#################################################### MICROSOFT SQL SERVER ON-PREMISES and VM with SQL Server ####################################################

### FUNCAO DE GERACAO DE DDL PARA LOGINS NO MSSQL (On-premises, VM with SQL Server, Failover, AlwaysOn, StandAlone)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


Function MSSql-LoginDDL
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$type,
                [string]$dominio,
                [string]$loginname
             )
   
    if ($type -eq "SERVICO")
    {
        
        write-output    "
        if exists (select name from sys.syslogins where name = '$loginname')
        begin
        print @@servername + ':' + ' LOGIN ' + '$loginname' + ' EXISTE NA INSTANCIA' + CHAR(13)+CHAR(10)
        end
        else
        begin
        print @@servername + ': ' + ' LOGIN ' + '$loginname' + ' NAO EXISTE, EXECUTANDO CREATE LOGIN' + CHAR(13)+CHAR(10)
        create login $loginname with password = '$senha',check_policy=off,check_expiration=off,default_database=tempdb
        end
        "
    }
    elseif ($type -eq "NOMINAL")
    {
        if (!$dominio)
        {
            Write-Warning 'NECESSARIO INFORMAR O DOMINIO'
        }
        else
        {
            Write-Output    "
            if exists (select name from sys.syslogins where name = '$dominio\$loginname')
            begin
            print @@servername + ':' + ' LOGIN ' + '$loginname' + ' EXISTE NA INSTANCIA' + CHAR(13)+CHAR(10)
            end
            else
            begin
            print @@servername + ':' + ' LOGIN ' + '$loginname' + ' NAO EXISTE, EXECUTANDO CREATE LOGIN' + CHAR(13)+CHAR(10)
            create login [$dominio\$loginname] from windows with default_database=tempdb
            end
            "
        }
    }
    elseif ($type -ne "NOMINAL" -or $type -ne "SERVICO")
    {
        Write-Warning "A VARIAVEL TYPE DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
    }
}

### FUNCAO DE GERACAO DE DDL PARA USUARIOS EM DATABASES NO MSSQL (On-premises, VM with SQL Server, Failover, AlwaysOn, StandAlone)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function MsSql-DatabaseUser
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$type,
                [string]$loginname,
                [string]$dominio,
                [string]$dbname,
                [string]$dbroles
             )

    if ($type -eq "NOMINAL")
    {
        $databaseroles = $dbroles | ForEach-Object {$_ -split ','} | ForEach-Object {$_ -replace ' ',''}
        $databasenames = $dbname | ForEach-Object {$_ -split ','} | ForEach-Object {$_ -replace ' ',''}
        foreach ($database in $databasenames)
        {
           Write-Output "
           use [$database]
           if not exists (select name from sys.sysusers where name = '$dominio\$loginname')
            begin
                print 'USUARIO ' + '$loginname ' + 'NAO EXISTE NO DATABASE ' + '$database, ' + 'EXECUTANDO CRIACAO' + CHAR(13)+CHAR(10)
                create user [$dominio\$loginname] from login [$dominio\$loginname]
            end
           "
                foreach ($userdbrole in $databaseroles)
                {
                    Write-Output   "
                   if exists (select name from sys.sysusers where name = '$userdbrole')
                    begin
	                    execute sp_addrolemember $userdbrole,[$dominio\$loginname]
                    end
                    "
                }
        }
    }
    elseif ($type -eq "SERVICO")
    {
        $databaseroles = $dbroles | ForEach-Object {$_ -split ','} | ForEach-Object {$_ -replace ' ',''}
        $databasenames = $dbname | ForEach-Object {$_ -split ','} | ForEach-Object {$_ -replace ' ',''}
        foreach ($database in $databasenames)
        {
           Write-Output "
           use [$database]
           if not exists (select name from sys.sysusers where name = '$loginname')
            begin
                print 'USUARIO ' + '$loginname ' + 'NAO EXISTE NO DATABASE ' + '$database, ' + 'EXECUTANDO CRIACAO' + CHAR(13)+CHAR(10)
                create user $loginname from login $loginname
            end
           "
                foreach ($userdbrole in $databaseroles)
                {
                    Write-Output   "
                   if exists (select name from sys.sysusers where name = '$userdbrole')
                    begin
	                    execute sp_addrolemember $userdbrole,$loginname
                    end
                    "
                }
        }
    }
    elseif ($type -ne "NOMINAL" -or $type -ne "SERVICO")
    {
        Write-Warning "A VARIAVEL TYPE DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
    }

}


function MsSql-HelpDbuser
{

    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$usuario
             )
    Write-Output "
    declare @nome nvarchar(160)
    declare @sqldml nvarchar(500)
    declare bancocursor cursor for
    select name from master..sysdatabases
    open bancocursor
    fetch next from bancocursor into @nome
    while @@FETCH_STATUS = 0
    begin
	    select @sqldml = 'use ' + '[' + @nome + ']' + char(10) + 'select user_name(role_principal_id) as role,' + char(10) + 'user_name(member_principal_id) as usuario,'  + char(10) + '''' + @@servername + '''' + ' as instancia,' + char(10) + '''' + @nome + '''' + 'as base' + char(10) + 'from sys.database_role_members where user_name(member_principal_id) = ' + '''' + '$usuario' + ''''
	    execute sp_executesql @sqldml
	    fetch next from bancocursor into @nome
    end
    close bancocursor
    deallocate bancocursor"

}


### FUNCAO QUE CORDENA A EXECUCAO DAS FUNCOES DE DO MICROSOFT SQL SERVER (Failover, AlwaysOn, StandAlone on-premises)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function MsSql-CreateLoginAndUserDB
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$solicitante,
                [string]$usuario,
                [string]$tipologin,
                [string]$nomedominio,
                [string]$bancosdedados,
                [string]$papeis,
                [string]$instancia,
                [string]$ambiente,
                [string]$destemail
             )
    if (!$chamado)
    {
        Write-Warning "E NECESSARIO INFROMAR UM VALOR INTEIRO PARA O CHAMADO"
    }
    else
    {
        $arquivo = Test-Path $env:USERPROFILE\UserDbAutomation\$usuario.log
        if ($arquivo -eq "true")
        {
            Remove-Item $env:USERPROFILE\UserDbAutomation\$usuario.log -Force -Verbose
        }
    
        if ($tipologin -eq "NOMINAL")
        {
            $Error.Clear()
            try
            {
                
                $bancos = $bancosdedados -replace " ","" -split ","
                foreach ($banco in $bancos)
                {
                    testeconnect-mssql -instancia $instancia -banco $banco
                    Write-HOST "VALIDADA CONEXAO $($instancia):$($banco)"
                }

                $comandologin = MSSql-LoginDDL -loginname $usuario -type $tipologin -dominio $nomedominio
                $comandousuario = MsSql-DatabaseUser -loginname $usuario -type $tipologin -dominio $nomedominio -dbname $bancosdedados -dbroles $papeis
                Write-Output $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                $sqldmlexec = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                change-mssql -instancia $instancia -banco master -dml "$sqldmlexec"
                Write-Output "Segue os acessos do usuario $($usuario) na instancia $($instancia)" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log
                $helplogins = MsSql-HelpDbuser -usuario "$nomedominio\$usuario"
                select-mssql -instancia $instancia -banco master -dml "$helplogins" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log
                
                MsSql-ValidaAlwaysON -tipo Windows -instancia $instancia -usuario $usuario -dominio $nomedominio
                Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SQL SERVER" -tipo "NOMINAL"
                
                $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql"
                Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                Start-Sleep -Seconds 3

                $tituloemail = "$($chamado) - CRIACAO DO USUARIO $($usuario) COM ACESSO AOS DATABASES $($instancia)"
                $corpoemail = "ATENDIMENTO DO CHAMADO $($chamado) PARA ACESSO AOS DATABASES $($instancia):$bancosdedados, NO ARQUIVO ANEXADO SEGUE O LOG DE CRIACAO DO USUARIO"
                EnviaEMailOffice -destinatario "$destemail" -emailtitle "$tituloemail" -emailbody "$corpoemail" -anexo $env:USERPROFILE\UserDbAutomation\$usuario.log
                Start-Sleep -Seconds 3
                Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -Verbose
                
            }
            catch
            {
                 Write-Warning "ERRO $($instancia)"
                 Write-Host $Error
                 pause
            }
        }
        elseif ($tipologin -eq "SERVICO")
        {
            $Error.Clear()
            try
                {
                    $bancos = $bancosdedados -replace " ","" -split ","
                    foreach ($banco in $bancos)
                    {
                        Write-HOST "VALIDADA CONEXAO $($instancia):$($banco)"
                        testeconnect-mssql -instancia $instancia -banco $banco
                    }

                    $contem_usuario = $NULL
                    $contem_usuario = select-mssql -instancia $instancia -banco master -dml "select name from syslogins where name = '$usuario'"
                    $contem_usuario = $contem_usuario.name
                    if (!$contem_usuario)
                    {
                        
                        $senha = Randomicos
                        $comandologin = MSSql-LoginDDL -loginname $usuario -type $tipologin
                        $comandousuario = MsSql-DatabaseUser -loginname $usuario -type $tipologin -dbname $bancosdedados -dbroles $papeis
                        $senhalogin =  'SENHA DO LOGIN ' + $usuario + ': ' + $senha
                        Write-Output $senhalogin | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log
                        Write-Output $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        $sqldmlexec = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        change-mssql -instancia $instancia -banco master -dml "$sqldmlexec"
                        Write-Output "Segue os acessos do usuario $($usuario) na instancia $($instancia)" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log
                        $helplogins = MsSql-HelpDbuser -usuario "$usuario"
                        select-mssql -instancia $instancia -banco master -dml "$helplogins" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log

                        MsSql-ValidaAlwaysON -tipo SQL -instancia $instancia -usuario $usuario -dominio $nomedominio
                        Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SQL SERVER" -tipo "SERVICO"
                
                        $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql"
                        Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                        $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                        Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                        Start-Sleep -Seconds 4

                        Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -Verbose

                    }
                    else
                    {
                        $comandologin = MSSql-LoginDDL -loginname $usuario -type $tipologin
                        $comandousuario = MsSql-DatabaseUser -loginname $usuario -type $tipologin -dbname $bancosdedados -dbroles $papeis
                        Write-Output $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        $sqldmlexec = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql
                        change-mssql -instancia $instancia -banco master -dml "$sqldmlexec"
                        Write-Output "Segue os acessos do usuario $($usuario) na instancia $($instancia)" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log
                        $helplogins = MsSql-HelpDbuser -usuario "$usuario"
                        select-mssql -instancia $instancia -banco master -dml "$helplogins" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$usuario.log

                        MsSql-ValidaAlwaysON -tipo SQL -instancia $instancia -usuario $usuario -dominio $nomedominio
                        Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SQL SERVER" -tipo "SERVICO"
                
                        $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_sqlserver_ddl.sql"
                        Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                        $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                        Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                        Start-Sleep -Seconds 4

                        Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -Verbose
                    }
                }
            catch
                {
                     Write-Warning "ERRO $($instancia)"
                     Write-Host $Error
                     pause
                }
        }
        elseif (!$tipologin)
        {
            Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
        }
        elseif ($tipologin -ne "NOMINAL" -or $tipologin -ne "SERVICO")
        {
            Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
        }
    }

}

###################################################### SAP/SYBASE ADAPTIVE SERVER ENTERPRISE (ASE)  ######################################################



### FUNCAO PARA EXECUCAO DE SELECT NO SAP ASE COM .NET ADONET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


Function select-sapase
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$banco,
                [string]$dml
             )
    SapAseIni -aseinstance $instancia
    $aseconnection = New-Object Sybase.Data.AseClient.AseConnection
    $aseconnection.ConnectionString = "Data Source=$($script:aseserver);Port=$($script:aseport);Database=$($banco);Uid='dba_admin';Pwd=$($script:asedbapss)"
    $aseconnection.Open()

    $asecmd = New-Object Sybase.Data.AseClient.AseCommand
    $asecmd.CommandText = $dml
    $asecmd.Connection  = $aseconnection

    $aseadapter = New-Object Sybase.Data.AseClient.AseDataAdapter
    $aseadapter.SelectCommand = $asecmd
    $AseDataSet = New-Object System.Data.DataSet
    $aseadapter.Fill($AseDataSet)
    $AseDataSet.Tables
    $aseconnection.close()
}


### FUNCAO PARA TESTE DE CONEXAO NO SAP ASE COM .NET ADONET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function testeconnect-sapase
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$servidor,
                [string]$porta,
                [string]$banco
             )
    $aseconnection = New-Object Sybase.Data.AseClient.AseConnection
    $aseconnection.ConnectionString = "Data Source=$($script:aseserver);Port=$($script:aseport);Database=$($banco);Uid='dba_admin';Pwd=$($script:asedbapss)"
    $aseconnection.Open()
    $aseconnection.State
    $aseconnection.Close()
    $aseconnection.State
}


### FUNCAO PARA GERACAO DE DDL DE CRIACAO DE LOGINS NO SAP ASE
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function SapAse-ServiceLogin
{

    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$type,
                [string]$loginname,
                [string]$defdatabase
             )
    if (!$type)
    {
        Write-Warning "A VARIAVEL TYPE DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
    }
    elseif ($type -eq "NOMINAL")
    {
        Write-Output "
-- DDL for Login '$loginname'
-- Criando o login $loginname Sybase ASE - Instancia  $instancia
-- $chamado
-----------------------------------------------------------------------------
use master
go

set replication off
go

PRINT '<<<<< CRIANDO o Login - $loginname >>>>>'
go 

IF EXISTS (SELECT 1 FROM master.dbo.syslogins WHERE name = '$loginname')
BEGIN    

PRINT 'O LOGIN $loginname EXISTE NO MASTER'

END
ELSE
BEGIN

PRINT 'O LOGIN $loginname NAO EXISTE NO MASTER. EXECUTANDO CRIACAO'

create login $loginname with password '$senha'
fullname '$($loginname) $chamado'
default database '$defdatabase'
default language 'us_english'
min password length 12
authenticate with 'ANY'
exempt inactive lock false

exec  sp_locklogin  '$loginname', 'unlock'

-- Definindo limites de recursos para o Login
exec  sp_add_resource_limit $loginname, NULL, 'at all times', io_cost, 4000000, 2, 4, 1

END
GO


----------------
            "
    }
    elseif ($type -eq "SERVICO")
    {
        Write-Output "
-- DDL for Login '$loginname'
-- Criando o login $loginname Sybase ASE - Instancia  $instancia
-- $($chamado)
-----------------------------------------------------------------------------
use master
go

set replication off
go

PRINT '<<<<< CRIANDO o Login - $loginname >>>>>'
go 

IF EXISTS (SELECT 1 FROM master.dbo.syslogins WHERE name = '$loginname')
BEGIN    

PRINT 'O LOGIN $loginname EXISTE NO MASTER'

END
ELSE
BEGIN

PRINT 'O LOGIN $loginname NAO EXISTE NO MASTER. EXECUTANDO CRIACAO'

create login $loginname with password '$senha'
fullname '$($loginname) $($chamado)'
default database '$defdatabase'
default language 'us_english'
min password length 12
authenticate with 'ANY'
exempt inactive lock false

exec  sp_locklogin  '$loginname', 'unlock'

-- Definindo limites de recursos para o Login
exec  sp_add_resource_limit $loginname, NULL, 'at all times', io_cost, 4000000, 2, 4, 1
ALTER login $loginname modify password expiration 0

END
GO

set replication on
go

----------------
            "
    }
    elseif ($type -ne "NOMINAL" -or $type -ne "SERVICO")
    {
        Write-Warning "A VARIAVEL TYPE DEVE TER O VALOR 'SERVICO' OU 'NOMINAL'"
    }
}


### FUNCAO PARA GERACAO DE DDL DE CRIACAO DE USUARIOS NOS COM ACESSO A GRUPO NOS DATABASES DO SAP ASE
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function SapAse-DatabaseUser ()
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$username,
                [string]$instancia,
                [string]$databases,
                [string]$grupo
             )
    if ($databases -eq "todos" -or $databases -eq "all" -and !$instancia)
    {
        Write-Warning "PARA UTILIZAR A FUNÇÃO TODOS OU ALL É NECESSÁRIO INFORMAR A INSTÂNCIA"
    }
    else
    {
        if ($databases -eq "todos" -or $databases -eq "all")
        {
            SapAseIni -aseinstance "$instancia"
            $databases_array = (select-sapase -banco master -dml "SELECT name FROM sysdatabases WHERE name NOT IN ('master','model','tempdb','sybsystemdb','sybsystemprocs','SYSTEMS_HELP')").name
        }
        else
        {
            $databases_array = $databases -replace " ","" -split ","
        }

        if ($grupo -eq "db_owner" -or $grupo -eq "owner")
        {
            foreach ($database in $databases_array)
            {
                Write-Output "   
-----------------------------------------------------------------------------
-- Cria usuario $username no $database
-----------------------------------------------------------------------------

use $database
go

set replication off
go

IF EXISTS (SELECT 1 FROM $database.dbo.sysusers WHERE name = '$username')
BEGIN    

PRINT 'USUARIO $username EXISTE NA BASE $database, ALTERANDO GRUPO DO USUARIO PARA $grupo'
exec sp_dropuser $username
exec sp_addalias '$username','dbo'

end
ELSE
BEGIN

PRINT 'USUARIO $username NAO EXISTE NA BASE $database, CRIANDO USUARIO COM GRUPO $grupo'
exec sp_addalias '$username','dbo'

end
go

set replication on
go

----------------
                        "
            }
        }
        else
        {
            foreach ($database in $databases_array)
            {
                Write-Output "   
-----------------------------------------------------------------------------
-- Cria usuario $username no $database
-----------------------------------------------------------------------------

use $database
go

set replication off
go

IF EXISTS (SELECT 1 FROM $database.dbo.sysusers WHERE name = '$username')
BEGIN    

PRINT 'USUARIO $username EXISTE NA BASE $database, ALTERANDO GRUPO DO USUARIO PARA $grupo'
exec sp_changegroup '$grupo', $username

end
ELSE
BEGIN

PRINT 'USUARIO $username NAO EXISTE NA BASE $database, CRIANDO USUARIO COM GRUPO $grupo'
exec sp_adduser '$username','$username','$grupo'

end
go

set replication on
go

----------------
                        "
            }
        }
    }
}


### FUNCAO DE RESET DE SENHA NO SAP ASE
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function SapAse-ResetdeSenha ()
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$instancia,
                [string]$usuario,
                [string]$destemail
             )
    $Error.Clear()
    try
        {
            SapAseIni -aseinstance $instancia
            testeconnect-sapase -servidor $script:aseserver -porta $script:aseport
            $senha = Randomicos
            $validastring = Valida-String -valor $senha
            if ($validastring -eq "True")
            {
                Write-Host "SENHA: $senha ATENDE AO CRITERIO DE COMPLEXIDADE"
            }

            Write-Output "sp_password '$script:asedbapss','$senha', $usuario" | Out-File -Encoding oem -Append $env:USERPROFILE\UserDbAutomation\asereset_$usuario.sql
            Write-Output "go"  | Out-File -Encoding oem -Append $env:USERPROFILE\UserDbAutomation\asereset_$usuario.sql
                
            Start-Process isql.exe -ArgumentList "-S $instancia -U dba_admin -P $script:asedbapss -D master -i $env:USERPROFILE\UserDbAutomation\asereset_$usuario.sql -o $env:USERPROFILE\UserDbAutomation\asereset_$usuario.log"
            Start-Sleep -Seconds 3
            $tituloemail = "$($chamado) - RESET DE SENHA DO USUARIO $($usuario) INSTANCIA: $($instancia)"
            $corpoemail = "INSTANCIA: $($instancia), SENHA DO USUARIO $($usuario) = $($senha)" 
            Start-Process notepad++.exe -ArgumentList "$env:USERPROFILE\UserDbAutomation\asereset_$usuario.log"
            EnviaEMailOffice -destinatario "$destemail" -emailtitle "$tituloemail" -emailbody "$corpoemail" -anexo $env:USERPROFILE\UserDbAutomation\asereset_$usuario.log
            Remove-Item -Force $env:USERPROFILE\UserDbAutomation\asereset_$usuario.sql
            Remove-Item -Force $env:USERPROFILE\UserDbAutomation\asereset_$usuario.log
            Start-Sleep -Seconds 3

        }
    catch
        {
            $Error
            pause
        }

}



### FUNCAO QUE ORQUESTRA A EXECUCAO AS FUNCOES SapAseIni, testeconnect-sapase, SapAse-ServiceLogin e SapAse-DatabaseUser
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function SapAse-CreateLoginAndUserDB
{
     [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$solicitante,
                [string]$instancia,
                [string]$usuario,
                [string]$tipologin,
                [string]$bancopadrao,
                [string]$bancosdedados,
                [string]$grupo,
                [string]$destemail,
                [string]$ambiente
             )
     if (!$tipologin)
     {
        Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER OS VALORES 'SERVICO' ou 'NOMINAL'"
     }
     elseif ($tipologin -eq "SERVICO")
     {
        if (!$chamado)
        {
            Write-Warning "A VARIAVEL CHAMADO DEVE SER PREENCHIDA"
        }
        else
        {
            $Error.Clear()
            try
            {
                SapAseIni -aseinstance $instancia
                if ($bancosdedados -eq "todos" -or $bancosdedados -eq "all")
                {
                    $bancos = (select-sapase -banco master -dml "SELECT name FROM sysdatabases WHERE name NOT IN ('master','model','tempdb','sybsystemdb','sybsystemprocs','SYSTEMS_HELP')").name
                }
                else
                {
                    $bancos = $bancosdedados -replace " ","" -split ","
                }

                foreach ($banco in $bancos)
                {
                    Write-Host "VALIDA CONEXAO INSTANCIA:$($instancia) BANCO:$($banco)"
                    testeconnect-sapase -servidor $script:aseserver -porta $script:aseport -banco $banco                
                }

                
                $valida = select-sapase -banco master -dml "select name from dbo.syslogins where name = '$usuario'"
                $valida = $valida.name
                if (!$valida)
                {
                    $senha = Randomicos

                    $senhalogin =  'SENHA DO LOGIN ' + $usuario + ' = ' + $senha
                    Write-Output $senhalogin | Out-File -Append $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    Write-Output "SEGUE LOG DE CRIACAO DO $usuario" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $comandologin = SapAse-ServiceLogin -chamado "$chamado" -type $tipologin -loginname $usuario -defdatabase $bancopadrao
                    $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    $comandousuario = SapAse-DatabaseUser -instancia $instancia -username $usuario -databases "$bancosdedados" -grupo $grupo
                    $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    Start-Process isql.exe -ArgumentList "-S $instancia -U dba_admin -P $script:asedbapss -i $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql -o $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log"
                    Start-Sleep -Seconds 14
                    $loglogin = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log
                    Write-Output $loglogin | Out-File -Append -FilePath  $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql"
                    Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                    $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log"
                    Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 3
                    $bancosdml = $bancos -join ","
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SYBASE ASE" -tipo "SERVICO"

                    Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -ErrorAction SilentlyContinue
                    
                }
                else
                {
                    $senha = $null
                    $comandologin = SapAse-ServiceLogin -chamado "$chamado" -type $tipologin -loginname $usuario -defdatabase $bancopadrao
                    $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    $comandousuario = SapAse-DatabaseUser -instancia $instancia -username $usuario -databases "$bancosdedados" -grupo $grupo
                    $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    Start-Process isql.exe -ArgumentList "-S $instancia -U dba_admin -P $script:asedbapss -i $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql -o $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log"
                    Start-Sleep -Seconds 14
                    $loglogin = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log
                    Write-Output $loglogin | Out-File -Append -FilePath  $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql"
                    Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                    $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log"
                    Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 3

                    $bancosdml = $bancos -join ","
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SYBASE ASE" -tipo "SERVICO"
                    Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -ErrorAction SilentlyContinue

                }
            }
            catch
            {
                Write-Warning "CONEXAO COM A INSTANCIA $($instancia)/$($banco) FALHOU"
                $Error
                pause
            }
        }
     }
     elseif ($tipologin -eq "NOMINAL")
     {
        if (!$chamado)
        {
            Write-Warning "A VARIAVEL CHAMADO DEVE SER PREENCHIDA"
        }
        else
        {
            $error.Clear()
            try
            {
                SapAseIni -aseinstance $instancia
                if ($bancosdedados -eq "todos" -or $bancosdedados -eq "all")
                {
                    $bancos = (select-sapase -banco master -dml "SELECT name FROM sysdatabases WHERE name NOT IN ('master','model','tempdb','sybsystemdb','sybsystemprocs','SYSTEMS_HELP')").name
                }
                else
                {
                    $bancos = $bancosdedados -replace " ","" -split ","
                }

                foreach ($banco in $bancos)
                {
                    Write-Host "VALIDA CONEXAO INSTANCIA:$($instancia) BANCO:$($banco)"
                    testeconnect-sapase -servidor $script:aseserver -porta $script:aseport -banco $banco                
                }

                
                $valida = select-sapase -banco master -dml "select name from dbo.syslogins where name = '$usuario'"
                $valida = $valida.name
                if (!$valida)
                {
                    $senha = Randomicos

                    $senhalogin =  'SENHA DO LOGIN ' + $usuario + ' = ' + $senha
                    Write-Output $senhalogin | Out-File -Append $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    Write-Output "SEGUE LOG DE CRIACAO DO $usuario" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $comandologin = SapAse-ServiceLogin -chamado "$chamado" -type $tipologin -loginname $usuario -defdatabase $bancopadrao
                    $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    $comandousuario = SapAse-DatabaseUser -instancia $instancia -username $usuario -databases "$bancosdedados" -grupo $grupo
                    $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    Start-Process isql.exe -ArgumentList "-S $instancia -U dba_admin -P $script:asedbapss -i $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql -o $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log"
                    Start-Sleep -Seconds 14
                    $loglogin = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log
                    Write-Output $loglogin | Out-File -Append -FilePath  $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql"
                    Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                    $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log"
                    Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 3

                    $bancosdml = $bancos -join ","
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SYBASE ASE" -tipo "NOMINAL"
                    $tituloemail = "$($chamado) - CRIACAO DO USUARIO $($usuario) COM ACESSO AOS DATABASES $($instancia)"
                    $corpoemail = "ATENDIMENTO DO CHAMADO $($chamado) PARA ACESSO NOS DATABASES $($instancia):$bancosdedados, NO ARQUIVO SEGUE O LOG DE CRIACAO DO USUARIO"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "$tituloemail" -emailbody "$corpoemail" -anexo $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    Start-Sleep -Seconds 3
                    Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -ErrorAction SilentlyContinue
                    
                }
                else
                {
                    $senha = $null
                    Write-Output "SEGUE LOG DE CRIACAO DO $usuario" | Out-File -Append $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $comandologin = SapAse-ServiceLogin -chamado "$chamado" -type $tipologin -loginname $usuario -defdatabase $bancopadrao
                    $comandologin | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    $comandousuario = SapAse-DatabaseUser -instancia $instancia -username $usuario -databases "$bancosdedados" -grupo $grupo
                    $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql
                    Start-Process isql.exe -ArgumentList "-S $instancia -U dba_admin -P $script:asedbapss -i $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql -o $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log"
                    Start-Sleep -Seconds 14
                    $loglogin = Get-Content $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.log
                    Write-Output $loglogin | Out-File -Append -FilePath  $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    $databaseddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE_ddl.sql"
                    Write-Output $databaseddl | Out-GridView -Title "$chamado DDL"
                    $databaselog = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log"
                    Write-Output $databaselog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 3

                    $bancosdml = $bancos -join ","
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "SYBASE ASE" -tipo "NOMINAL"
                    $tituloemail = "$($chamado) - CRIACAO DO USUARIO $($usuario) COM ACESSO AOS DATABASES $($instancia)"
                    $corpoemail = "ATENDIMENTO DO CHAMADO $($chamado) PARA ACESSO NOS DATABASES $($instancia):$bancosdedados, NO ARQUIVO SEGUE O LOG DE CRIACAO DO USUARIO"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "$tituloemail" -emailbody "$corpoemail" -anexo $env:USERPROFILE\UserDbAutomation\$($usuario)_ASE.log
                    Start-Sleep -Seconds 3
                    Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)* -ErrorAction SilentlyContinue
                }
            }
            catch
            {
                Write-Warning "CONEXAO COM A INSTANCIA $($instancia)/$($banco) FALHOU"
                $Error
                pause
            }
        }
     }
}


###################################################### ORACLE  ######################################################


### FUNCAO PARA SELECT NO ORACLE COM .NET ADONET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function select-oracle
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$instancia,
                [string]$dml
             )
    $oracleconnection = New-Object Oracle.DataAccess.Client.OracleConnection
    $oracleconnection.ConnectionString = "User Id=dba_admin;Password=$script:orapss;Data Source=$instancia"
    $oracleconnection.Open()

    $oraclecmd = new-object Oracle.DataAccess.Client.OracleCommand
    $oraclecmd.CommandText = $dml
    $oraclecmd.Connection = $oracleconnection

    $oracleadapter = new-object Oracle.DataAccess.Client.OracleDataAdapter
    $oracleadapter.SelectCommand = $oraclecmd
    $oracleDataSet = New-Object System.Data.DataSet
    $oracleadapter.Fill($oracleDataSet)
    $oracleDataSet.Tables
    $oracleconnection.Close()
}


### FUNCAO PARA TESTE DE CONEXAO NO ORACLE COM .NET ADONET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function testeconnect-oracle
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$instancia
             )
    $oracleconnection = New-Object Oracle.DataAccess.Client.OracleConnection
    $oracleconnection.ConnectionString = "User Id=dba_admin;Password=$script:orapss;Data Source=$instancia"
    $oracleconnection.Open()
    $oracleconnection.State
    $oracleconnection.Close()
    $oracleconnection.State
}

### FUNCAO QUE GERA A DDL PARA CRIACAO DE USUARIOS NO ORACLE, PROFILE SERVICO (senha não expira) ou Profile NOMINAL (Senha expira)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function oracle-createuser ()
{

    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$usuario,
                [string]$tipo,
                [string]$senha,
                [string]$instancia,
                [string]$chamado
             )
    if ($tipo -eq "SERVICO")
    {

        Write-Output @"
        -----------------------------------------------------------------------------
        -- Criando o Login Oracle: '$usuario' - Instancia: $instancia
        -- $chamado
        -----------------------------------------------------------------------------

        CREATE 
	        USER "$usuario" 
	        PROFILE "SERVICO"
	        IDENTIFIED BY "$senha"
	        DEFAULT TABLESPACE "USERS" 
	        TEMPORARY TABLESPACE "TEMP" 
	        ACCOUNT UNLOCK;
        GRANT "CONNECT" TO "$usuario";
"@
    }
    elseif ($tipo -eq "NOMINAL")
    {
        Write-Output @"
        -----------------------------------------------------------------------------
        -- Criando o Login Oracle: '$usuario' - Instancia: $instancia
        -- $chamado
        -----------------------------------------------------------------------------

        CREATE 
	        USER "$usuario" 
	        PROFILE "NOMINAL"
	        IDENTIFIED BY "$senha"
	        DEFAULT TABLESPACE "USERS" 
	        TEMPORARY TABLESPACE "TEMP" 
	        ACCOUNT UNLOCK;
        GRANT "CONNECT" TO "$usuario";
"@
    }
    elseif ($tipo -ne "SERVICO" -or $tipo -ne "NOMINAL")
    {
        Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER OS VALORES 'SERVICO' OU 'NOMINAL'"
    }

}


### FUNCAO QUE GERA A DDL PARA ATRIBUIR GRANT DE ROLES A USUARIOS DO ORACLE
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function oracle-roles
{

    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$usuario,
                [string]$roles,
                [string]$instancia
             )


    $roles_array = $roles -replace " ","" -split ","
    foreach ($role in $roles_array)
    {
        Write-Output @"
        GRANT "$role" TO "$usuario";
"@
    }
    foreach ($role in $roles_array)
    {
        if ($role -clike "*$($script:OracleChangeRole)*")
        {
            $roletablespace = $script:OracleChangeRole  -replace " ","" -split "_"
            $tablespaces = (select-oracle -instancia $instancia -dml "select TABLESPACE_NAME from DBA_TABLESPACES where TABLESPACE_NAME not in ('SYSTEM','SYSAUX','USERS','UNDOTBS1','UNDOTBS2') and TABLESPACE_NAME like '%$roletablespace%'").TABLESPACE_NAME
            foreach ($tablespace in $tablespaces)
            {
                Write-Output @"
                alter user "$usuario" quota unlimited on "$tablespace";
"@
            }
        }
    }


    Write-Output @"
    GRANT "CONNECT" TO "$usuario";
"@
    Write-Output "exit;"
}


### FUNCAO DE RESET DE SENHA NO ORACLE
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function oracle-resetpass
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$instancias,
                [string]$usuario,
                [string]$destemail,
                [switch]$manualpass
             )
    $usuario = $usuario.ToUpper()
    if ($manualpass)
    {
        $senha = Read-Host "INFORME A SENHA"
    }
    else
    {
        $senha = Randomicos
        $validastring = Valida-String -valor $senha
        if ($validastring -eq "True")
        {
	        Write-Host "SENHA: $senha ATENDE AO CRITERIO DE COMPLEXIDADE"
        }
        else
        {
	        Write-Host "SENHA: $senha NAO ATENDE AO CRITERIO DE COMPLEXIDADE, EXECUTANDO AJUSTE..:"
	        $randomico = String-Randomica
	        $senha = "$($senha)$($randomico)"
	        $senha
        }
    }

    Write-Output @"
    ALTER USER "$usuario" IDENTIFIED BY "$senha";
"@ |  Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql
    Write-Output @"
ALTER USER "$usuario" ACCOUNT UNLOCK;
"@ | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql
    Write-Output "exit;" | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql
    
    $instanciasN = $instancias -replace " ","" -split ","
    foreach ($instancia in $instanciasN)
    {
        Start-Process sqlplus.exe -ArgumentList "dba_admin/$($script:orapss)@$($instancia) @$env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql"
        Start-Sleep -Seconds 3
    }
    
    Start-Process notepad++.exe -ArgumentList "Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql"
    Start-Sleep -Seconds 2
    $tituloemail = "$($chamado) - RESET DE SENHA DO USUARIO $($usuario) NAS INSTANCIAS:$($instancias)"
    $corpoemail = "SENHA DO USUARIO $($usuario) = $($senha)"
    EnviaEMailOffice -destinatario "$destemail" -emailtitle "$tituloemail" -emailbody "$corpoemail" -anexo $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql
    Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($usuario)_resetpass.sql
    
}



### FUNCAO QUE ORQUESTRA A EXECUCAO DAS FUNCOES testeconnect-oracle, select-oracle, oracle-createuser, oracle-roles
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function Oracle-UserAndRoles
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$solicitante,
                [string]$instancia,
                [string]$usuario,
                [string]$tipologin,
                [string]$bancosdedados,
                [string]$roles,
                [string]$destemail,
                [string]$ambiente,
                [switch]$bypassconfirmation
             )
    if (!$chamado)
    {
        Write-Warning "A VARIAVEL CHAMADO DEVE SER INFROMADA"
    }
    elseif ($tipologin -eq "SERVICO")
    {
        $error.Clear()
        try
            {
                
                $usuario = $usuario.ToUpper()
                testeconnect-oracle -instancia $instancia
                $validalogin = (select-oracle -instancia $instancia -dml "select username from dba_users where username = '$usuario'").username
                if (!$validalogin)
                {
                    $senha = Randomicos

                    Write-Output "CRIACAO DO $($usuario) NA INSTANCIA $($instancia)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SENHA DO USUARIO $($usuario) = $($senha)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SEGUEM AS ROLES DO $($usuario):" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    
                    $comandousuario = oracle-createuser -chamado "$chamado" -usuario $usuario -tipo $tipologin -senha $senha -instancia $instancia
                    Write-Output $comandousuario | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    $comandorole = oracle-roles -instancia $instancia -usuario $usuario -roles $roles
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    Start-Process sqlplus.exe -ArgumentList "dba_admin/$($script:orapss)@$($instancia) @$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Start-Sleep -Seconds 10
                    
                    $resultset = select-oracle -instancia $instancia -dml "select grantee,granted_role,default_role from dba_role_privs where grantee = '$usuario'"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "DDL $chamado"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "LOG $chamado"
                    Start-Sleep -Seconds 2
               
                    $bancosdml = $bancosdedados
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdml) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "ORACLE" -tipo "SERVICO"
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -Verbose -ErrorAction SilentlyContinue
                }
                else
                {
                    Write-Warning "USUARIO $usuario JA ESTA CRIADO NA INSTANCIA $instancia"
                    Write-Output "USUARIO $($usuario) EXISTE NA INSTANCIA $($instancia), ATRIBUINDO ROLES $($roles)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    
                    $comandorole = oracle-roles -instancia $instancia -usuario $usuario -roles $roles
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    Start-Process sqlplus.exe -ArgumentList "dba_admin/$($script:orapss)@$($instancia) @$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Start-Sleep -Seconds 10
                    
                    $resultset = select-oracle -instancia $instancia -dml "select grantee,granted_role,default_role from dba_role_privs where grantee = '$usuario'"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "DDL $chamado"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "LOG $chamado"
                    Start-Sleep -Seconds 2
                    
                    $bancosdml = $bancosdedados
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdml) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "ORACLE" -tipo "SERVICO"
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -Verbose -ErrorAction SilentlyContinue
                }
            }
        catch
            {
                Write-Warning "ERRO DE CONEXAO COM A INSTANCIA $instancia"
                $error
                pause
            }
    }
    elseif ($tipologin -eq "NOMINAL")
    {
       $error.Clear()
       try
            {
                
                $usuario = $usuario.ToUpper()
                testeconnect-oracle -instancia $instancia
                $validalogin = (select-oracle -instancia $instancia -dml "select username from dba_users where username = '$usuario'").username
                if (!$validalogin)
                {
                    $senha = Randomicos

                    Write-Output "CRIACAO DO $($usuario) NA INSTANCIA $($instancia)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SENHA DO USUARIO $($usuario) = $($senha)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SEGUEM AS ROLES DO $($usuario):" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log

                    
                    $comandousuario = oracle-createuser -chamado "$chamado" -usuario $usuario -tipo $tipologin -senha $senha -instancia $instancia
                    Write-Output $comandousuario | Out-File -Encoding oem -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    $comandorole = oracle-roles -instancia $instancia -usuario $usuario -roles $roles
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    Start-Process sqlplus.exe -ArgumentList "dba_admin/$($script:orapss)@$($instancia) @$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Start-Sleep -Seconds 10
                    
                    $resultset = select-oracle -instancia $instancia -dml "select grantee,granted_role,default_role from dba_role_privs where grantee = '$usuario'"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "DDL $chamado"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "LOG $chamado"
                    Start-Sleep -Seconds 2
                    
                    $bancosdml = $bancosdedados
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdml) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "ORACLE" -tipo "NOMINAL"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "Atendimento $chamado - Usuario $usuario" -emailbody "Segue detalhes do usuario criado no arquivo anexado" -anexo $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -Verbose -ErrorAction SilentlyContinue
                }
                else
                {
                    Write-Warning "USUARIO $usuario JA ESTA CRIADO NA INSTANCIA $instancia"
                    Write-Output "USUARIO $($usuario) EXISTE NA INSTANCIA $($instancia), ATRIBUINDO ROLES $($roles)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    
                    $comandorole = oracle-roles -instancia $instancia -usuario $usuario -roles $roles
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql
                    Start-Process sqlplus.exe -ArgumentList "dba_admin/$($script:orapss)@$($instancia) @$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Start-Sleep -Seconds 10
                    
                    $resultset = select-oracle -instancia $instancia -dml "select grantee,granted_role,default_role from dba_role_privs where grantee = '$usuario'"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ora_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "DDL $chamado"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "LOG $chamado"
                    Start-Sleep -Seconds 2
                    
                    $bancosdml = $bancosdedados
                    Update-DBAccessManagement -nmdatabases "$bancosdml" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdml) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "ORACLE" -tipo "NOMINAL"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "Atendimento $chamado - Usuario $usuario" -emailbody "Segue detalhes do usuario criado no arquivo anexado" -anexo $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -Verbose -ErrorAction SilentlyContinue
                }
            }
        catch
            {
                Write-Warning "ERRO DE CONEXAO COM A INSTANCIA $instancia"
                $error
                pause
            }
    }
    elseif ($tipologin -ne "SERVICO" -or $tipologin -ne "NOMINAL")
    {
        Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER OS VALORES 'SERVICO' OU 'NOMINAL'"
    }
}


###################################################### MySQL ######################################################



### FUNCAO QUE POSSUI DATASET PARA EXECUCAO DE DML'S DO TIPO SELECT NO MYSQL COM .NET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function select-Mysql
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$instancia,
                [string]$dml
             )
    $mysqlconn = New-Object MySql.Data.MySqlClient.MySqlConnection
    $mysqlconn.ConnectionString = "Uid=dba_admin;Pwd=$script:mysqlpass;server=$($instancia)"
    $mysqlconn.Open()

    $mysqlcmd = New-Object MySql.Data.MySqlClient.MySqlCommand
    $mysqlcmd.CommandText = "$dml"
    $mysqlcmd.Connection  = $mysqlconn

    $mysqladapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
    $mysqladapter.SelectCommand = $mysqlcmd
    $mysqldataset = New-Object System.Data.DataSet
    $mysqladapter.Fill($mysqldataset)
    $mysqldataset.Tables
    $mysqlconn.Close()
}



### FUNCAO QUE NAO POSSUI DATASET PARA EXECUCAO DE DDL'S, DCL'S E DML'S NO MYSQL COM .NET (NAO EXECUTA SELECT)
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function change-Mysql
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$instancia,
                [string]$banco,
                [string]$dml
             )
    $mysqlconn = New-Object MySql.Data.MySqlClient.MySqlConnection
    $mysqlconn.ConnectionString = "Uid=dba_admin;Pwd=$script:mysqlpass;server=$($instancia);database=$banco"
    $mysqlconn.Open()

    $mysqlcmd = New-Object MySql.Data.MySqlClient.MySqlCommand
    $mysqlcmd.CommandText = $dml
    $mysqlcmd.Connection = $mysqlconn
    $mysqlcmd.ExecuteNonQuery()
    $mysqlconn.Close()
}


##### FUNCAO PARA TESTE DE CONEXAO NO MYSQL COM .NET
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function testeconnect-Mysql
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$instancia,
                [string]$banco
             )
    $mysqlconn = New-Object MySql.Data.MySqlClient.MySqlConnection
    $mysqlconn.ConnectionString = "Uid=dba_admin;Pwd=$script:mysqlpass;server=$($instancia);database=$banco"
    $mysqlconn.Open()
    $mysqlconn.State
    $mysqlconn.close()
    $mysqlconn.State
}

##### FUNCAO PARA CRIACAO DE USUARIOS NO MYSQL
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function MySQL-Createuser
{

    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$instancia,
                [string]$usuario,
                [string]$tipo,
                [string]$senha
             )
    if ($tipo -eq "NOMINAL")
    {
        Write-Output "
        -- LOGIN MYSQL $($tipo): '$usuario' - INSNTANCIA: $instancia
        -- $chamado
        CREATE USER $usuario IDENTIFIED BY '$senha'
          PASSWORD EXPIRE INTERVAL 42 DAY;
        "
    }
    elseif ($tipo -eq "SERVICO")
    {
        Write-Output "
        -- LOGIN MYSQL $($tipo): '$usuario' - INSNTANCIA: $instancia
        -- $chamado
        CREATE USER $usuario IDENTIFIED BY '$senha';
        "
    }
    elseif ($tipo -ne "SERVICO" -or $tipo -ne "NOMINAL")
    {
        Write-Warning "E NECESSARIO INFORMAR O TIPO SERVICO OU NOMINAL NA VARIAVEL TIPO"
    }
}

##### FUNCAO PARA CONCESSAO DE USUARIOS NO MYSQL
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

Function MySQL-Grants
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$usuario,
                [string]$tipo,
                [string]$bancosdedados
             )
    Write-Output "GRANT SHOW DATABASES, SHOW SCHEMAS, USAGE ON *.* TO $($usuario);"
    $bancos = $bancosdedados -replace " ","" -split ","
    foreach ($banco in $bancos)
    {
        if ($tipo -eq "CONSULTA")
        {
            Write-Output "GRANT USAGE, SELECT ON $($banco).* TO $($usuario);"
        }
        elseif ($tipo -eq "ALTERACAO")
        {
            Write-Output "GRANT USAGE, SELECT, EXECUTE, INSERT, DELETE, UPDATE, CREATE TEMPORARY TABLES ON $($banco).* TO $($usuario);"
        }
        elseif ($tipo -eq "OWNER")
        {
            Write-Output "GRANT ALL PRIVILEGES ON $($banco).* TO $($usuario);"
        }
        elseif ($tipo -ne "CONSULTA" -or $tipo -ne "ALTERACAO" -or $tipo -ne "OWNER")
        {
            Write-Warning "E NECESSARIO INFORMAR O TIPO CONSULTA, ALTERACAO OU OWNER NA VARIAVEL TIPO"
        }
    }
}


##### FUNCAO QUE ORQUESTRA A EXECUCAO DAS FUNCOES select-MySQL, Change-Mysql, testeconnect-mysql, MySQL-Createuser, MySQL-Grants
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)

function MySQL-UserAndRoles
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$chamado,
                [string]$solicitante,
                [string]$instancia,
                [string]$usuario,
                [string]$tipologin,
                [string]$bancosdedados,
                [string]$roles,
                [string]$destemail,
                [string]$ambiente
             )
    if (!$chamado)
    {
        Write-Warning "A VARIAVEL CHAMADO DEVE SER INFROMADA"
    }
    elseif ($tipologin -eq "SERVICO")
    {
        $error.Clear()
        try
            {
                
                $bancos = $bancosdedados -replace " ","" -split ","
                foreach ($banco in $bancos) 
                {
                    write-host "VALIDA CONEXAO $($instancia): $($banco)"
                    testeconnect-Mysql -instancia $instancia -banco $banco
                }

                $validalogin = (select-Mysql -instancia $instancia -dml "select user from mysql.user where user = '$usuario';").user
                if (!$validalogin)
                {
                    $senha = Randomicos
                    $validastring = Valida-String -valor $senha
                    if ($validastring -eq "True")
                    {
                        Write-Host "SENHA: $senha ATENDE AO CRITERIO DE COMPLEXIDADE"
                    }

                    Write-Output "CRIACAO DO $($usuario) NA INSTANCIA $($instancia)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SENHA DO USUARIO $($usuario) = $($senha)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SEGUEM AS ROLES DO $($usuario):" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log

                    $comandousuario = mysql-Createuser -chamado "$chamado" -usuario $usuario -tipo $tipologin -senha $senha -instancia $instancia
                    change-Mysql -instancia $instancia -dml "$comandousuario"
                    $comandorole = mysql-Grants -usuario $usuario -tipo $roles -bancosdedados $bancosdedados
                    change-Mysql -instancia $instancia -dml "$comandorole"
                    
                    $resultset = select-Mysql -instancia $instancia -dml "show grants for $usuario;"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "$chamado DDL"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 2
                    Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "MySQL" -tipo "SERVICO"
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -ErrorAction SilentlyContinue
                }
                else
                {
                    Write-Warning "USUARIO $usuario JA ESTA CRIADO NA INSTANCIA $instancia"
                    Write-Output "USUARIO $($usuario) EXISTE NA INSTANCIA $($instancia), ATRIBUINDO ROLES $($roles)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    $comandorole = mysql-Grants -usuario $usuario -tipo $roles -bancosdedados $bancosdedados
                    change-Mysql -instancia $instancia -dml "$comandorole"
                    
                    $resultset = select-Mysql -instancia $instancia -dml "show grants for $usuario;"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "$chamado DDL"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "$chamado LOG"
                    Start-Sleep -Seconds 2
                    Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "MySQL" -tipo "SERVICO"
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -ErrorAction SilentlyContinue
                    
                }
            }
        catch
            {
                Write-Warning "ERRO DE INSTANCIA $instancia"
                $error
                pause
            }
    }
    elseif ($tipologin -eq "NOMINAL")
    {
       $error.Clear()
       try
            {
                
                $bancos = $bancosdedados -replace " ","" -split ","
                foreach ($banco in $bancos) 
                {
                    write-host "VALIDA CONEXAO $($instancia): $($banco)"
                    testeconnect-Mysql -instancia $instancia -banco $banco
                }

                $validalogin = (select-Mysql -instancia $instancia -dml "select user from mysql.user where user = '$usuario';").user
                if (!$validalogin)
                {
                    $senha = Randomicos
                    $validastring = Valida-String -valor $senha
                    if ($validastring -eq "True")
                    {
                        Write-Host "SENHA: $senha ATENDE AO CRITERIO DE COMPLEXIDADE"
                    }

                    Write-Output "CRIACAO DO $($usuario) NA INSTANCIA $($instancia)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SENHA DO USUARIO $($usuario) = $($senha)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output "SEGUEM AS ROLES DO $($usuario):" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log

                    
                    $comandousuario = mysql-Createuser -chamado "$chamado" -usuario $usuario -tipo $tipologin -senha $senha -instancia $instancia
                    change-Mysql -instancia $instancia -dml "$comandousuario"
                    $comandorole = mysql-Grants -usuario $usuario -tipo $roles -bancosdedados $bancosdedados
                    change-Mysql -instancia $instancia -dml "$comandorole"
                    
                    $resultset = select-Mysql -instancia $instancia -dml "show grants for $usuario;"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "$chamado DDL"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "$chamado LOG"
                    Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "MySQL" -tipo "NOMINAL"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "Atendimento $chamado - Usuario $usuario" -emailbody "Segue detalhes do usuario no arquivo anexado" -anexo $env:USERPROFILE\UserDbAutomation\$($usuario).log
                    Start-Sleep -Seconds 2
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -ErrorAction SilentlyContinue
                }
                else
                {
                    Write-Warning "USUARIO $usuario JA ESTA CRIADO NA INSTANCIA $instancia"
                    Write-Output "USUARIO $($usuario) EXISTE NA INSTANCIA $($instancia), ATRIBUINDO ROLES $($roles)" | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    
                    $comandorole = mysql-Grants -usuario $usuario -tipo $roles -bancosdedados $bancosdedados
                    change-Mysql -instancia $instancia -dml "$comandorole"
                    
                    $resultset = select-Mysql -instancia $instancia -dml "show grants for $usuario;"
                    Write-Output $resultset | Out-File -Append -FilePath $env:USERPROFILE\UserDbAutomation\$usuario.log
                    Write-Output $comandousuario | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    Write-Output $comandorole | Out-File -Encoding oem -Append -FilePath $env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql
                    
                    $userddl = Get-Content "$env:USERPROFILE\UserDbAutomation\$($usuario)_ddl.sql"
                    Write-Output $userddl | Out-GridView -Title "$chamado DDL"
                    $userlog = Get-Content "$env:USERPROFILE\UserDbAutomation\$usuario.log"
                    Write-Output $userlog | Out-GridView -Title "$chamado LOG"

                    Update-DBAccessManagement -nmdatabases "$bancosdedados" -nminstancia "$instancia" -Nusolicitacao "$chamado" -solicitante "$solicitante" -logindb "$usuario" -descricao "ACESSO DO USUARIO $($usuario) AOS DATABASES $($bancosdedados) INSTANCIA $($instancia)" -ambiente $ambiente -plataforma "MySQL" -tipo "NOMINAL"
                    EnviaEMailOffice -destinatario "$destemail" -emailtitle "Atendimento $chamado - Usuario $usuario" -emailbody "Segue detalhes do usuario no arquivo anexado" -anexo $env:USERPROFILE\UserDbAutomation\$($usuario).log
                    Start-Sleep -Seconds 2
                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($usuario)* -Force -ErrorAction SilentlyContinue
                }
            }
        catch
            {
                Write-Warning "ERRO INSTANCIA $instancia"
                $error
                pause
            }
    }
    elseif ($tipologin -ne "SERVICO" -or $tipologin -ne "NOMINAL")
    {
        Write-Warning "A VARIAVEL TIPOLOGIN DEVE TER OS VALORES 'SERVICO' OU 'NOMINAL'"
    }
}


###################################### MENU ######################################


function Menu_AccessManagement
{
        do
        {
            Clear-Host
            Clear-Host
            Write-Host "AUTOMACAO DE GESTAO DE ACESSO PARA BANCO DE DADOS"
            Write-Host "FEATURES: EMAIL, AUTENTICACAO INTEGRADA ACTIVE DIRECTORY, Microsoft SQL SERVER, SYBASE ASE, ORACLE, MySQL"
            Write-Host " 1 - MICROSOFT SQL SERVER"
            Write-Host " 2 - SAP ASE"
            Write-Host " 3 - ORACLE"
            Write-Host " 4 - MYSQL"
            Write-Host 'DIGITE UMA DAS OPCOES OU SAIR'
            $menu = Read-Host "INFORME UMA DAS OPCOES"

            switch ($menu)
            {
                1{
                    DO {
                            Clear-Host
                            Write-Host "MICROSOFT SQL SERVER"
                            Write-Host "1 - SQL SERVER SERVICE ACCOUNT"
                            Write-Host "2 - SQL SERVER NOMINAL ACCOUNT"
                            Write-Host "DIGITE UMA DAS OPCOES OU SAIR"
                            $menu2 = Read-Host "INFORME UMA DAS OPCOES"
                        } until ($menu2 -eq 1 -or $menu2 -eq 2 -or $menu2 -eq "SAIR")
                    
                    switch($menu2)
                    {

                            1{
                                Clear-Host
                                Write-Host "MSSQL SERVER SERVICE ACCOUNT"
                                $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                $menu_os = Read-Host "CASO SEJA GMUD, INFORME O NUMERO DA OS"
                                $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                $menu_nomedatabases = Read-Host "INFORME O NOME DOS DATABASES SEPARADOS POR VIRGULA"
                                $menu_papeis = Read-Host "INFORME O NOME DAS ROLES SEPARADOS POR VIRGULA"
                                $menu_instancia = Read-Host "INFORME A INSTANCIA"

                                if (!$menu_os)
                                {
                                    $menu_chamado = "SOL#$($menu_chamado)"
                                }
                                else
                                {
                                    $menu_chamado = "GMUD#$($menu_chamado)OS#$($menu_os)"
                                }
                     
                                MsSql-CreateLoginAndUserDB -chamado "$menu_chamado" -solicitante $menu_solicitante -usuario $menu_nomeusuario -tipologin SERVICO -bancosdedados "$menu_nomedatabases" -papeis "$menu_papeis" -instancia "$menu_instancia" -destemail "$menu_destemail" -ambiente "$menu_ambiente"
                                write-host 'FINALIZADO'
                                Remove-Item -Force  $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -ErrorAction SilentlyContinue -Verbose
                            }
                            2{
                                Clear-Host
                                Write-Host "MSSQL SERVER NOMINAL ACCOUNT"
                                $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                $menu_nomedatabases = Read-Host "INFORME O NOME DOS DATABASES SEPARADOS POR VIRGULA"
                                $menu_papeis = Read-Host "INFORME O NOME DAS ROLES SEPARADOS POR VIRGULA"
                                $menu_instancia = Read-Host "INFORME A INSTANCIA"
                                $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                    
                                $menu_chamado = "SOL#$($menu_chamado)"

                                MsSql-CreateLoginAndUserDB -chamado "$menu_chamado" -solicitante $menu_solicitante -usuario $menu_nomeusuario -tipologin NOMINAL -nomedominio $env:USERDOMAIN -bancosdedados "$menu_nomedatabases" -papeis "$menu_papeis" -instancia "$menu_instancia" -destemail "$menu_destemail" -ambiente "$menu_ambiente"
                                write-host 'FINALIZADO'
                                Remove-Item -Force  $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -ErrorAction SilentlyContinue -Verbose
                            }
                    }
                }
                2{
                    DO {
                            Clear-Host
                            Write-Host "SAP ASE"
                            Write-Host "1 - SAP ASE SERVICE ACCOUNT"
                            Write-Host "2 - SAP ASE NOMINAL ACCOUNT"
                            Write-Host "3 - SAP ASE RESET PASSWORD"
                            Write-Host "DIGITE UMA DAS OPCOES OU SAIR"
                            $menu2 = Read-Host "INFORME UMA DAS OPCOES"
                        } until ($menu2 -eq 1 -or $menu2 -eq 2 -or $menu2 -eq 3 -or $menu2 -eq "SAIR")
                    
                    switch($menu2)
                    {
                            1{
                                Clear-Host
                                Write-Host "SAP ASE SERVICE ACCOUNT"
                                $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                $menu_os = Read-Host "CASO SEJA GMUD, INFORME O NUMERO DA OS"
                                $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                $menu_nomedatabases = Read-Host "INFORME O NOME DOS DATABASES SEPARADOS POR VIRGULA"
                                $menu_papeis = Read-Host "INFORME O NOME DO GRUPO"
                                $menu_instancia = Read-Host "INFORME A INSTANCIA"
                    
                                if (!$menu_os)
                                {
                                    $menu_chamado = "SOL#$($menu_chamado)"
                                }
                                else
                                {
                                    $menu_chamado = "GMUD#$($menu_chamado)OS#$($menu_os)"
                                }

                                SapAse-CreateLoginAndUserDB -chamado "$menu_chamado" -solicitante $menu_solicitante -instancia $menu_instancia -usuario $menu_nomeusuario -tipologin SERVICO -bancopadrao tempdb -bancosdedados "$menu_nomedatabases" -grupo $menu_papeis -destemail $menu_destemail -ambiente "$menu_ambiente"
                                write-host 'FINALIZADO'
                                Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -ErrorAction SilentlyContinue
                                
                            }
                            2{
                                Clear-Host
                                Write-Host "SAP ASE NOMINAL ACCOUNT"
                                $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                $menu_nomedatabases = Read-Host "INFORME O NOME DOS DATABASES SEPARADOS POR VIRGULA"
                                $menu_papeis = Read-Host "INFORME O NOME DO GRUPO"
                                $menu_instancia = Read-Host "INFORME A INSTANCIA"
                                $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                    
                                $menu_chamado = "SOL#$($menu_chamado)"

                                SapAse-CreateLoginAndUserDB -chamado "$menu_chamado" -solicitante $menu_solicitante -instancia $menu_instancia -usuario $menu_nomeusuario -tipologin NOMINAL -bancopadrao tempdb -bancosdedados "$menu_nomedatabases" -grupo $menu_papeis -destemail $menu_destemail -ambiente "$menu_ambiente"
                                write-host 'FINALIZADO'
                                Remove-Item -Force $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -ErrorAction SilentlyContinue
                            }
                            3{
                                Clear-Host
                                Write-Host "SAP ASE RESET PASSWORD"
                                $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO"
                                $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                $menu_instancia = Read-Host "INFORME A INSTANCIA"
                                $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"

                                SapAse-ResetdeSenha -chamado "$menu_chamado" -instancia $menu_instancia -usuario $menu_nomeusuario -destemail $menu_destemail

                            }
                    }
                }
                3{
                        DO {
                                Clear-Host
                                Write-Host "ORACLE"
                                Write-Host "1 - ORACLE SERVICE ACCOUNT"
                                Write-Host "2 - ORACLE NOMINAL ACCOUNT"
                                Write-Host "3 - ORACLE RESET PASSWORD"
                                Write-Host "4 - ORACLE NOMINAL ACCOUNT CASCADE (N INSTANCES)"
                                Write-Host "DIGITE UMA DAS OPCOES OU SAIR"
                                $menu2 = Read-Host "INFORME UMA DAS OPCOES"
                            } until ($menu2 -eq 1 -or $menu2 -eq 2 -or $menu2 -eq 3 -or $menu2 -eq 4 -or $menu2 -eq "SAIR")
                    
                        switch($menu2)
                        {
                                    1{
                                        Clear-Host
                                        Write-Host "ORACLE SERVICE ACCOUNT"
                                        $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                        $menu_os = Read-Host "CASO SEJA GMUD, INFORME O NUMERO DA OS"
                                        $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                        $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                        $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                        $menu_nomedatabases = Read-Host "INFORME O NOME DOS SCHEMAS/OWNERS SEPARADOS POR VIRGULA"
                                        $menu_papeis = Read-Host "INFORME O NOME DAS ROLES"
                                        $menu_instancia = Read-Host "INFORME A INSTANCIA"
                    
                                        if (!$menu_os)
                                        {
                                            $menu_chamado = "SOL#$($menu_chamado)"
                                        }
                                        else
                                        {
                                            $menu_chamado = "GMUD#$($menu_chamado)OS#$($menu_os)"
                                        }

                                        Oracle-UserAndRoles -chamado $menu_chamado -solicitante $menu_solicitante -instancia $menu_instancia -usuario $menu_nomeusuario -tipologin "SERVICO" -bancosdedados "$menu_nomedatabases" -roles "$menu_papeis" -destemail $menu_destemail -ambiente "$menu_ambiente"
                                        write-host 'FINALIZADO'
                                        Remove-Item $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -Force -Verbose -ErrorAction SilentlyContinue
                                        Start-Sleep -Seconds 3
                                    }
                                   2{
                                        Clear-Host
                                        Write-Host "ORACLE NOMINAL ACCOUNT"
                                        $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                        $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                        $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                        $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                        $menu_nomedatabases = Read-Host "INFORME O NOME DOS SCHEMAS/OWNERS SEPARADOS POR VIRGULA"
                                        $menu_papeis = Read-Host "INFORME O NOME DAS ROLES"
                                        $menu_instancia = Read-Host "INFORME A INSTANCIA"
                                        $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                    
                                        $menu_chamado = "SOL#$($menu_chamado)"

                                        Oracle-UserAndRoles -chamado "$menu_chamado" -solicitante $menu_solicitante -instancia $menu_instancia -usuario $menu_nomeusuario -tipologin "NOMINAL" -bancosdedados "$menu_nomedatabases" -roles "$menu_papeis" -destemail $menu_destemail -ambiente "$menu_ambiente"
                                        write-host 'FINALIZADO'
                                        Remove-Item $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -Force -Verbose -ErrorAction SilentlyContinue
                                        Start-Sleep -Seconds 3
                                    }
                                   3{
                                        Clear-Host
                                        Write-Host "ORACLE RESET PASSWORD"
                                        $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO"
                                        $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                        $menu_instancia = Read-Host "INFORME AS INSTANCIAS SEPARADAS POR VIRGULA"
                                        do {$menu_senhamanual = Read-Host "SENHA MANUAL (S OU N)"} until ($menu_senhamanual -eq "S" -or $menu_senhamanual -eq "N" )
                                        $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                                        if ($menu_senhamanual -eq "S")
                                        {
                                            oracle-resetpass -chamado $menu_chamado -instancias $menu_instancia -usuario $menu_nomeusuario -destemail $menu_destemail -manualpass
                                        }
                                        else
                                        {
                                            oracle-resetpass -chamado $menu_chamado -instancias $menu_instancia -usuario $menu_nomeusuario -destemail $menu_destemail
                                        }

                                    }
                                   4{
                                        Clear-Host
                                        Write-Host "ORACLE NOMINAL ACCOUNT CASCADE (N INSTANCES)"
                                        $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO"
                                        $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                        $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                        $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                        $menu_nomedatabases = "TODOS"
                                        $menu_papeis = Read-Host "INFORME TODOS_CONSULTA, TODOS_MANUT OU TODOS_OWNER"
                                        $menu_instancia = Read-Host "INFORME AS INSTANCIAS SEPARADAS POR VIRGULA"
                                        $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                    
                                        $menu_chamado = "SOL#$($menu_chamado)"

                                        $instancias_N = $menu_instancia -replace " ","" -split ","
                                        foreach ($instancia in $instancias_N)
                                        {
                                            Oracle-UserAndRoles -chamado "$menu_chamado" -solicitante $menu_solicitante -instancia $instancia -usuario $menu_nomeusuario -tipologin "NOMINAL" -bancosdedados "$menu_nomedatabases" -roles "$menu_papeis" -destemail $menu_destemail -ambiente "$menu_ambiente" -bypassconfirmation
                                            $arquivo = Test-Path $env:USERPROFILE\UserDbAutomation\$menu_nomeusuario.log
                                            if ($arquivo -eq "true")
                                            {
                                                Remove-Item $env:USERPROFILE\UserDbAutomation\$menu_nomeusuario.log -Force -Verbose
                                            }
                                            Start-Sleep -Seconds 3
                                            }
                                            write-host 'FINALIZADO'
                                    }
                        }
                }
                4{
                        DO {
                                Clear-Host
                                Write-Host "MySQL"
                                Write-Host "1 - MySQL SERVICE ACCOUNT"
                                Write-Host "2 - MySQL NOMINAL ACCOUNT"
                                Write-Host "DIGITE UMA DAS OPCOES OU SAIR"
                                $menu2 = Read-Host "INFORME UMA DAS OPCOES"
                            } until ($menu2 -eq 1 -or $menu2 -eq 2 -or $menu2 -eq "SAIR")
                    
                        switch($menu2)
                        {
                                1{
                                    Clear-Host
                                    Write-Host "MYSQL SERVICE ACCOUNT"
                                    $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                    $menu_os = Read-Host "CASO SEJA GMUD, INFORME O NUMERO DA OS"
                                    $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                    $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                    $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                    $menu_nomedatabases = Read-Host "INFORME O NOME DOS SCHEMAS/BANCOS SEPARADOS POR VIRGULA"
                                    $menu_papeis = Read-Host "INFORME OS ACESSOS (CONSULTA, ALTERACAO OU OWNER)"
                                    $menu_instancia = Read-Host "INFORME A INSTANCIA"
                    
                                    if (!$menu_os)
                                    {
                                        $menu_chamado = "SOL#$($menu_chamado)"
                                    }
                                    else
                                    {
                                        $menu_chamado = "GMUD#$($menu_chamado)OS#$($menu_os)"
                                    }

                                    MySQL-UserAndRoles -chamado "$menu_chamado" -solicitante "$menu_solicitante" -instancia $menu_instancia -usuario  $menu_nomeusuario -tipologin SERVICO -bancosdedados "$menu_nomedatabases"  -roles "$menu_papeis" -destemail "$menu_destemail" -ambiente "$menu_ambiente"
                                    write-host 'FINALIZADO'
                                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -Force -Verbose -ErrorAction SilentlyContinue
                                    
                                    Start-Sleep -Seconds 3
                                }
                                2{
                                    Clear-Host
                                    Write-Host "MYSQL NOMINAL ACCOUNT"
                                    $menu_chamado = Read-Host "INFORME O NUMERO DA SOLICITACAO OU GMUD"
                                    $menu_solicitante = Read-Host "INFORME O NOME DO SOLICITANTE POR EXTENSO"
                                    $menu_ambiente = Read-Host "INFORME O AMBIENTE (DES, QA, UAT OU PRD)"
                                    $menu_nomeusuario = Read-Host "INFORME O NOME DO USUARIO"
                                    $menu_nomedatabases = Read-Host "INFORME O NOME DOS SCHEMAS/BANCOS SEPARADOS POR VIRGULA"
                                    $menu_papeis = Read-Host "INFORME OS ACESSOS (CONSULTA, ALTERACAO OU OWNER)"
                                    $menu_instancia = Read-Host "INFORME A INSTANCIA"
                                    $menu_destemail = Read-Host "INFORME O DESTINATORIO DO EMAIL"
                    
                                    $menu_chamado = "SOL#$($menu_chamado)"

                                    MySQL-UserAndRoles -chamado "$menu_chamado" -solicitante "$menu_solicitante" -instancia $menu_instancia -usuario  $menu_nomeusuario -tipologin NOMINAL -bancosdedados "$menu_nomedatabases"  -roles "$menu_papeis" -destemail "$menu_destemail" -ambiente "$menu_ambiente"
                                    write-host 'FINALIZADO'
                                    Remove-Item $env:USERPROFILE\UserDbAutomation\$($menu_nomeusuario)* -Force -Verbose -ErrorAction SilentlyContinue
                                    Start-Sleep -Seconds 3
                                }
                        }
                    }
                SAIR{
                        Write-Host "ATE LOGO"
                        Start-Sleep -Seconds 3
                    }
                default{
                        Write-Host "VOLTANDO AO MENU DE OPCOES"
                        Start-Sleep -Seconds 3
                    } 
       
            }

        } until ($menu -eq "SAIR")
}


###################################### PARAMETROS GLOBAIS ######################################


###### EXECUTA FUNCAO PARA ARMAZENZAR CREDENCIAL DO USUARIO PARA ENVIO DE E-MAIL
credencial


###### CREDENCIAS NÃO INTEGRADAS AO ACTIVE DIRECTORY / LDAP
$script:asedbapss = Read-Host "Informe a senha dos produtos SAP/Sybase"
$script:orapss = Read-Host "Informe a senha do Oracle Database"
$script:mysqlpass = Read-Host "Informe a senha do MySQL"

##### INSTANCIA DBAccessManagement

$script:DBAccessManagement = "192.168.0.220\SQL2k17"

### FUNCAO PARA MAEPAR SERVIDOR E PORTA DO SYBASE COMO VARIAVEIS DE ESCOPO DE SCRIPT
### GABRIEL SANTANA DE SOUSA (CRIACAO E MANUTENCAO)


Function SapAseIni
{
    [CmdletBinding(SupportsShouldProcess)]
        Param(
                [string]$aseinstance
             )

    switch -Wildcard ($aseinstance)
    {
        '*DES'{$script:aseserver = 'SYBASEDES'
                    $script:aseport = 3500
                    }
        '*HML'{$script:aseserver = 'SYBASEHML'
                    $script:aseport = 4500
                    }
        '*PRD'{$script:aseserver = 'SYBASEPRD'
                    $script:aseport = 5500
                    }
        
    }
}



####### PARAMETRO ORACLE

<#
    AS ROLES DO ORACLE DEVEM SER DEFINIDAS COMO NOMEROLE_SCHEMA (TER O UNDERSCORE SEPARANDO O NOME DO SCHEMA), O PROGRAMA FAZ SPLIT DO _ PARA PEGAR O NOME DO SCHEMA
    CASO O PROGRAMA IDENTIFIQUE A ROLE DE GRANÇÃO DE DADOS, USA O NOME DO SCHEMA PARA FAZER UMA QUERY PARA PEGAR AS TABLESPACES COM O NOME DO SCHEMA
#>

###### ORACLE, VARIAVEL DE ESCOPO DE SCRIPT QUE DEFINE PARTE DO NOME DA ROLE USADA PARA GRANT DE ALTERACAO DE DADOS

$script:OracleChangeRole = "GRAVACAO"

<#
    Pesquisa nome da role com -clike no valor informada pela variável $script:OracleChangeRole
        
        if ($role -clike "*$($script:OracleChangeRole)*")
        {
            $roletablespace = $script:OracleChangeRole  -replace " ","" -split "_"
            $tablespaces = (select-oracle -instancia $instancia -dml "select TABLESPACE_NAME from DBA_TABLESPACES where TABLESPACE_NAME not in ('SYSTEM','SYSAUX','USERS','UNDOTBS1','UNDOTBS2') and TABLESPACE_NAME like '%$roletablespace%'").TABLESPACE_NAME
            foreach ($tablespace in $tablespaces)
            {
                Write-Output @"
                alter user "$usuario" quota unlimited on "$tablespace";
"@
            }
#>


###### VALIDA DIRETORIO DE EXECUCAO DO USUARIO
$dirfiles = Test-Path $env:USERPROFILE\UserDbAutomation
if ($dirfiles -eq "True")
{
    Write-Host "$env:USERPROFILE\UserDbAutomation OK"
}
else
{
    mkdir $env:USERPROFILE\UserDbAutomation -Verbose
}


###### EXECUTA MENU E INICIA PROGRAMA
Menu_AccessManagement
