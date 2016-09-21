Set-ExecutionPolicy Unrestricted
cls



function GetUsers
{

	return Get-ChildItem "C:\Users" | Select-Object Name
}





function GetWERPath($_user)
{


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

function GetWerError($_user,$showName) # Zählt die Fehler und kann die Namen der ErrorDateien ausgeben.
{
	$_count = 0;
	
	$_ordner = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportArchive";
	if((Test-Path -path $_ordner) -eq $true) # Testen ob es den Ordner gibt
	{
		$_ordner = Get-ChildItem $_ordner;# Holt die Ordner aus dem Verzeichnis
		if($_ordner -ne $null) # Prüfen ob es unterordner gibt !!!!!!!!
		{
			foreach($_reportarch in $_ordner)
			{
				$_tempreportarch = $_reportarch.Name; # Namen wieder Temporär selektieren
				$_ordner2 = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportArchive\$_tempreportarch";
				if((Test-Path -path $_ordner2) -eq $true)# Testen ob es den Ordner gibt
				{
					$_unterordner = Get-ChildItem $_ordner2 | Where-Object {$_.length -ne 0};
					foreach($_error in $_unterordner)
					{
						if($showName -eq 1)
						{
							Write-Host "$_reportarch/$_error";
						}
						$_count ++;
					}
				}
			}
		}
	}
	
	$_ordner = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportQueue";
	if((Test-Path $_ordner) -eq $true) # Testen ob es den Ordner gibt
	{
		$_ordner = Get-ChildItem $_ordner;
		if($_ordner -ne $null) # Prüfen ob es unterordner gibt !!!!!!!!
		{
			foreach($_reportarch in $_ordner)
			{
				$_tempreportarch = $_reportarch.Name; # Namen wieder Temporär selektieren
				$_ordner2 = "C:\Users\$_user\AppData\Local\Microsoft\Windows\WER\ReportQueue\$_tempreportarch";
				if((Test-Path $_ordner2) -eq $true)# Testen ob es den Ordner gibt
				{
					$_unterordner = Get-ChildItem $_ordner2 | Where-Object {$_.length -ne 0};
					foreach($_error in $_unterordner)
					{
						if($showName -eq 1)
						{
							Write-Host "$_reportarch/$_error.Name";
						}
						$_count ++;
					}
				}
			}
		}
	}
	return $_count;
}
function GetWhereReportStat($_showNames)
{
	$_users = GetUsers;
	foreach($_user in $_users) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
	{
		
		$_tempuser = $_user.Name; # Temp Benutzername damit er aus der Hashtable genommen werden kann
		
		Write-Host "--------------------------------------"
		Write-Host "---------------$_tempuser---------------"
		Write-Host "--------------------------------------"
		
		$_count = GetWerError $_tempuser $_showNames; # Zählt die WER Fehler / Dokumente
		
		Write-Host "";
		Write-Host "--------------------------------------"
		Write-Host "Benutzer: $_tempuser - Fehler: $_count";
		Write-Host "--------------------------------------"
		Write-Host "";
	}
}
function GetReportInnerData($_path,$_methode)
{




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



function GetReportData
{
    $stats=@()
	$apps=@()
	 
	$_users = GetUsers;
	foreach($_user in $_users) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
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
				
				$stats += New-Object PSObject -Property @{user=$_user.Name;report_id=$_reportid;report_type=$_reporttype;event_type=$_eventtype;event_time=$_eventtime;bucket_id=$_bucketid;app=$_appname};
				
				$apps += New-Object PSObject -Property @{app=$_appname};
			}
		}
	}
	
	
	### CSV für die anzahl der Fehler pro Benutzer
	$csv=@()
	
	$_users = GetUsers;
	foreach($_user in $_users) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
	{
		$_tempuser = $_user.Name; # Temp Benutzername damit er aus der Hashtable genommen werden kann
		$_count = GetWerError $_tempuser $_showNames; # Zählt die WER Fehler / Dokumente
		$csv += New-Object PSObject -Property @{Benutzer=$_tempuser;Fehler=$_count}
		$csv | Select-Object Benutzer,Fehler | Export-Csv -Path c:\Benutzer-Fehler.csv -Encoding utf8 -NoTypeInformation -Delimiter ";"
	}
	
	##### Reporttypen pro Nutzer
	$_counter1=0
	$_counter2=0
	$_counter3=0
	
	$csv=@()
	
	foreach($_user in $_users) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
	{
		$_tempuser = $_user.Name; # Temp Benutzername damit er aus der Hashtable genommen werden kann
		foreach ($_error in $stats) 
		{
			if($_tempuser -eq $_error.user) #Username an erster Stelle im Array 
			{
				switch ($_error.report_type)
				{
					"1" {$_counter1 ++}
					"2" {$_conuter2 ++}
					"3" {$_counter3 ++}
				}
			}
		}
		
		$csv += New-Object PSObject -Property @{Benutzer=$_tempuser;Report_ID1=$_counter1;Report_ID2=$_counter2;Report_ID3=$_counter3}
		$csv | Select-Object Benutzer,Report_ID1,Report_ID2,Report_ID3 | Export-Csv  -Path c:\Benutzer-Report.csv -Encoding utf8 -NoTypeInformation -Delimiter ";"
	}
	
	### Abfragen der Fehler pro Anwendung
	$_counter1=0
	$_counter2=0
	$_counter3=0
	
	$csv=@()
	
	$apps = $apps | group-object app -noelement | select-object name | sort-object name  
	
	foreach($_app in $apps) # $_users hier stehen alle benuter vom Rechner und werden nach $_user geschrieben in der Schleife
	{
		foreach ($_error in $stats) 
		{
			if($_app.Name -eq $_error.app) #Username an erster Stelle im Array 
			{
				switch ($_error.report_type)
				{
					"1" {$_counter1 ++}
					"2" {$_conuter2 ++}
					"3" {$_counter3 ++}
				}
			}
		}
		
		$csv += New-Object PSObject -Property @{Anwendung=$_app.Name;Report_ID1=$_counter1;Report_ID2=$_counter2;Report_ID3=$_counter3}
		$csv | Select-Object Anwendung,Report_ID1,Report_ID2,Report_ID3 | Export-Csv  -Path c:\Benutzer-AppReport.csv -Encoding utf8 -NoTypeInformation -Delimiter ";"
	}
}


function GetOtherData 
{
	$macadresse = get-wmiobject -class "Win32_NetworkAdapterConfiguration" | Where {$_.IpEnabled -Match "True"} | Select MacAddress
	write-host $macadresse
	$macadresse = $macadresse[0].MacAddress
	
	$os = (Get-WmiObject Win32_OperatingSystem).Name
	
	$comname = (Get-WmiObject Win32_OperatingSystem).CSName
	
	Write-Host "OS: $os";
	Write-Host "Computername: $comname";
	Write-Host "Macadresse: $macadresse";
}

####Menue als letzte Funktion das die inkludierten Funktionen noch aufgerufen werden können !
function Menue 
{
	do 
	{
		Write-Host "1. Vorhandene Nutzer anzeigen";
		Write-Host "2. Statistik je Nutzer anzeigen";
		Write-Host "3. Reportnamen anzeigen (Name der jeweiligen WER-Datei)";
		Write-Host "4. Einzelreportdaten ausgeben";
		Write-Host "5. Weitere relevanten Daten anzeigen";
		Write-Host " x für beenden";
		
		$_eingabe1 = Read-Host "Zahl im Menü auswählen";
		
		switch ($_eingabe1)
		{
			"1"	{GetUsers;}
			"2" {GetWhereReportStat 0;}
			"3" {GetWhereReportStat 1;}
			"4" {GetReportData;}
			"5" {GetOtherData;}
			"x" {break;} 
			default {Write-Host "Falsche Eingabe bitte Zahl zwischen 1 und 5 wählen";}
		}
	}
	until ($_eingabe1 -eq "x");
}
########################################
##############Functionen Ende###########
########################################

Menue # aufruf des Menues

