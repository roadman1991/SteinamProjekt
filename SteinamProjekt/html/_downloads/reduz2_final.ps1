Set-ExecutionPolicy Unrestricted
$ErrorActionPreference="SilentlyContinue"
#$DebugPreference="SilentlyContinue" #Keine Ausgabe von Write-Debug
$DebugPreference="Continue"          #Write-Debug wird ausgegeben

class User
{
    [string]$Name

    $Reports = [System.Collections.ArrayList]::New()
    [Computer]$pc

    User([string]$uname)
    {
      #für getData erstmal rausgenommen   
      #  $this.Name = $uname
      #  $this.pc = [Computer]::new()
    }
}


class Report
{
    [string]$ReportID
    [int]$ReportType
    [string]$EventType
    [string]$EventTime
    [string]$BucketID
    [string]$Appname

    Report($repid, $repType, $evType, $evTime, $buckId, $appnam)
    {
        $this.ReportID = $repid
        $this.ReportType = $repType
        $this.EventType = $evTime
        $this.EventTime = $evTime
        $this.BucketID = $buckId
        $this.Appname = $appnam
    }
}


class Computer
{
    [string]$mac
    [string]$OpSys
    [string]$Name

    Computer()
    {
	    $macadresse = get-wmiobject -class "Win32_NetworkAdapterConfiguration" | Where {$_.IpEnabled -Match "True"} | Select MacAddress
	    $this.mac = $macadresse[0].MacAddress
	    $this.OpSys = (Get-WmiObject Win32_OperatingSystem).Name
	    $this.Name = (Get-WmiObject Win32_OperatingSystem).CSName
    }
}


function GetReportData($Benutzer)
{
    #Wegen Problemen mit Rückgabe von ArrayListen wird eine eigene erzeugt und der aufgerufenen Funktion GetUsers mit übergeben.
    GetUsers $Benutzer

  #[System.Collections.ArrayList]$_users = GetUsers ;
	#foreach($_user in $_users) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
	foreach($_user in $Benutzer)
    {
		$paths = GetWERPath $_user.Name;
		foreach($_path in $paths) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
		{
			if($_path -ne $null)
			{
				$_reportid = GetReportInnerData $_path "ReportIdentifier";
				$_reporttype = GetReportInnerData $_path "ReportType";
				$_eventtype = GetReportInnerData $_path "EventType"; # z.B AppCrash
				$_eventtime = GetReportInnerData $_path "EventTime";
				$_bucketid = GetReportInnerData $_path "Response.BucketId";
				$_appname = GetReportInnerData $_path "AppName";


        [Report]$rep = [Report]::new($_reportid, $_reporttype, $_eventtype, $_eventtime, $_bucketid, $_appname)
        $_user.Reports += $rep
			}
		}
	}
    return $Benutzer
}

function GetReportInnerData($_path,$_methode)
{
<#
    .SYNOPSIS

    Sucht in einer übergebenen Datei (Pfad einer Report.Wer-Datei
    nach einen übergebenen Schlüsselwort, spaltet es am = - Zeichen auf
    und gibt den Wert zurück

    .PARAMETER PATH

        Pfadname zur report-wer-Datei

    .PARAMETER Methode

        Schlüsselwort, nach dem gesucht wird.

#>

	$reportid= Select-String -Encoding Unicode -Path $_path -AllMatch "$_methode" | select line # sucht nach dem Stichpunkten welche in Methode übegeben werden im Path welcher über &_path kommt
	if ($reportid.Line -ne $null)
	{
		$reportidResult = $reportid.Line.Split("=");
	 	$reportid = $reportidResult[1];
		return $reportid;
	 	#### $reportid enthält die report ID
	}
	else
	{
        #Wa macht diese zeile ??
		$reportidResult = $reportid[1].Line.Split("=");
		$reportid = $reportidResult[1];
		return $reportid;
		#### $reportid enthält die report ID
	}
}

function GetWERPath($_user)
{
<#
    .Synopsis

        Gibt die Pfadnamen aller Report.wer - Dateien eines Users zurück
        Es schaut dazu in die beiden möglichen Unterordner ReportArchive
        und ReportQueue

        Returns $WERDATA as String-Array

    .Parameter UserName

        UserName
#>

	$_ordner = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportArchive";

	[array]$werdata = $NULL;

	if((Test-Path -path $_ordner) -eq $true) # Testen ob es den Ordner gibt
	{
		$_ordner = Get-ChildItem $_ordner | Where-Object {$_.mode -match "d"} ;# Holt die Ordner aus dem Verzeichnis
		if($_ordner -ne $null) # Prüfen ob es unterordner gibt !!!!!!!!
		{
			foreach($_reportarch in $_ordner)
			{
				$_tempreportarch = $_reportarch.Name; # Namen wieder Temporär selektieren
				$_ordner2 = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportArchive\$_tempreportarch";
				if((Test-Path $_ordner2) -eq $true)# Testen ob es den Ordner gibt
				{
					$_unterordner = Get-ChildItem $_ordner2 | Where-Object {$_.name -eq "Report.wer"}; # nur Dateien welche Report.wer heisen werden angezeigt
					foreach($_error in $_unterordner)
					{
						$werdata += "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportArchive\$_tempreportarch\$_error";
					}
				}
			}
		}
	}

	$_ordner = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportQueue";
	if((Test-Path $_ordner) -eq $true) # Testen ob es den Ordner gibt
	{
		$_ordner = Get-ChildItem $_ordner | Where-Object {$_.mode -match "d"};
		if($_ordner -ne $null) # Prüfen ob es unterordner gibt !!!!!!!!
		{
			foreach($_reportarch in $_ordner)
			{
				$_tempreportarch = $_reportarch.Name; # Namen wieder Temporär selektieren
				$_ordner2 = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportQueue\$_tempreportarch";
				if((Test-Path $_ordner2) -eq $true)# Testen ob es den Ordner gibt
				{
					$_unterordner = Get-ChildItem $_ordner2 | Where-Object {$_.name -eq "Report.wer"}; # nur Dateien welche Report.wer heisen werden angezeigt
					foreach($_error in $_unterordner)
					{
						$werdata += "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportQueue\$_tempreportarch\$_error";
					}
				}
			}
		}
	}
	return $werdata;
}


function GetUsers($Benutzer)
{
<#

    .Synopsis

        Erstellt aus dem Ordnernamen unterhalb von C:\Users eigen-
        ständige User-Objekte und weist Sie einer ArrayList zu.
#>

    #Generische Liste geht nicht so richtig
    #Liste.Add($user) wirft einen Fehler
    # Workaround: $users2 += ist nicht schön
    # $Users2 = [System.Collections.Generic.List[User]]::New()
    # [User]$u = [User]::New($username.Name)
    # $Users2 += $u

    #nehmen wir eben eine ArrayList
   # $Users = [System.Collections.ArrayList]::New()


    $tempUser = Get-ChildItem "C:\Users" | Select-Object Name

    foreach($username in $tempUser)
    {
       #Uername ist ein Objekt mit der Eigenschaft Name

        [User]$u = [User]::New($username.Name)
       # $Users.Add("steinM")
        $Benutzer.Add($u)
    }
}


####################################
#mysql_model.ps1
cls
#Datenbankverbindung öffnen und Datenübertragung vorbereiten
#Bibliothek zur Datenbankeinbindung einbinden
[void][system.reflection.Assembly]::LoadFrom("c:\Program Files (x86)\MySQL\Connector.NET 6.9\Assemblies\v4.0\MySql.Data.dll");

#Skriptweite Variablen deklarieren
#Connectionvariable
$connstring = "Server=localhost;Uid=watson;Pwd='watson';Database=watson_11FI3"
$con = New-Object Mysql.Data.MysqlClient.MysqlConnection;
#$con.connectionstring = $connstring


#Commandobjekt
$command = New-Object MySql.Data.MySqlClient.MySqlCommand;


function open()
{
    #Funktion zum Öffnen der Datenbankverbindung
    try
    {
	    $con.ConnectionString = $connstring;
	    $con.Open();
	    Write-Debug "Datenbankverbindung geöffnet"
    }
    catch
    {
	    Write-Debug "Achtung Fehler: $_.ExceptionMessage"
	    Write-Debug "Daten müssen später übertragen werden"
    }
}


function close()
{
    #Funktion zum Öffnen der Datenbankverbindung
    try
    {
	    $con.Close();
	    Write-Debug "Datenbankverbindung geschlossen"
    }
    catch
    {
	    Write-Debug "Achtung Fehler: $_.ExceptionMessage"
	    Write-Debug "Daten müssen später übertragen werden"
    }
}

function saveData($Users)
{
    open
    foreach($u in $Users)
    {
        write-debug $u.Name
        setUser $u
        setReports $u
    }
    close
}


function setUser($user)
{
    $name = $user.Name
    [string]$sql = "replace into User(Anmeldename) values ('$name');"
    $command.CommandText = $sql
    $command.Connection = $con;
    $command.ExecuteNonQuery()
}


function setReports($u)
{
    $m = $u.pc.mac
    $uname  = $u.Name

    foreach($rep in $u.Reports)
    {
        $repid = $rep.ReportID
        $repType = $rep.ReportType
        $evTime = $rep.EventTime
        $evType = $rep.EventType
        $buckID = $rep.BucketID
        $app = $rep.Appname

        [string]$sql = "insert into report(ReportID, Appname, EventTime, BucketID, ReportType, User, Computer) "
        $sql += "values('$repid', '$app', '$evTime', '$buckID', '$repType', '$uname', '$m');"

        $command.CommandText = $sql
        $command.Connection = $con;

        $command.ExecuteNonQuery()
    }
}


function setComputer([Computer]$c)
{

    $m = $c.mac
    $sys = $c.OpSys
    $n = $c.Name

    [string]$sql = "replace into computer(MAC, OSName, HostName) values ('$m', '$sys','$n');"
    #[string]$sql = "Replace into computer values ($c.'mac', $c.'OpSys',$c.'Name');"

    $command.CommandText = $sql
    $command.Connection = $con;

    open
        $command.ExecuteNonQuery()
    close
}


function getData($model)
{
    
    [string]$sql = "select Anmeldename from User;"
    $command.CommandText = $sql
    $command.Connection = $con;
    
    Open
    $reader = $command.ExecuteReader()
    
    while ($reader.Read()) {
          #Zugriff über die Spalten eines Datensatzes
          for ($i= 0; $i -lt $reader.FieldCount; $i++) {
              write-debug $reader.GetValue($i).ToString()
          }

          #So würde es auch gehen
          #write-output %results["feld1"]
          #write-output $results["feld2"]

          [User]$u = [User]::new($reader["Anmeldename"])

          $model += $u
    }

    close

}


###################################

#$Benutzer = [System.Collections.ArrayList]::New()
#GetReportData $Benutzer

#setComputer $UserListe.pc[0]

# untenstehende Routine könnte auch in der setUSer-Methode für jeden User ausgeführt werden
# da das Skript auf nur auf einem Rechner läuft, kann man sich die wiederholten
# Statements aber sparen
#setComputer ($Benutzer[0]).pc

# und jetzt der ganze Rest
#saveData $Benutzer

$database_data = [System.Collections.ArrayList]::New()
getData $database_data

