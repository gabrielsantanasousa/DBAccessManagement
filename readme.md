DBAccessManagement.ps1

Programa para prover gestão de acessos a instâncias de baco de dados de forma automatizada com log de ações detalhadas para gestão de equipes.

O progama faz reflection de libs (.dll's) do SQL Server e clients do Oracle, Sybase ASE, MySQL para carregar as classes em memória e utilizar funções customizadas que trabalham com os métodos das classes carregadas de cada lib, através destas funções é possível atingir a qualidade de um programa de console do c#, porém, feito no powershell.

 - Microsoft SQL Server
 - SAP ASE 
 - Oracle
 - MySQL


Pré-requisitos

- .Net 4.5.x
- PowerShell 5 ou superior 
- Host Windows Client ou Server integrado a um domínio
- Clients e Lib
    - Oracle 19
    - SAP ASE 15.7 ou 16.0
    - MySQL 8
    - Banco de dados DBAccessManagement em uma instância SQL Server que é informada nos parâmetros globais
    - Editar os parâmetros globais a partir da linha 3042 para setar a instância que possui o DBAccessManagement e função que mapeia servidor e porta do SAP ASE.
        - Parâmetro DBAccessManagement:
            - $script:DBAccessManagement = "192.168.0.220\SQL2k17"
        - Função que mapeia servidor e porta dos servidores Sybase/SAP ASE:
                    
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
        - Oracle, Variável de escope de script que define parte do nome da ROLE usada para GRANT de alteração de dados
            - $script:OracleChangeRole = "GRAVACAO"

Conceito

O conceito do programa é orientar o utilizador a criar usuários nas instâncias de banco de dados baseado em conta de serivço (Senha que não expira) e conta nominal (Senha que expira ou é integrada com o Active Directory), e prover acessos ao banco de dados ou schemas da instância baseado no uso de roles.


Melhorias previstas / Entregas pendentes:
- DDL DbLoginAutomation e PBI com Dashs dos relatórios possíveis de serem visualizados
- Manual de utilização detalhado
- Integracao com Azure KeyVault para resgatar senhas dos produtos que não integram com LDAP/Active Directory
- Alterar libs para lib de packages do nuget.org para ficar client less e FULL compatível com PowerShell 7.x com .net6 Linux e MAC
- Automação para Azure SQL Single Database e Azure SQL Managed Instance
- Automação para PostGreSQL
