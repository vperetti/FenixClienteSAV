; Script gerado para a Versão 4.0 do Fenix ClienteSAV

[Setup]
AppName=Fenix
AppVerName=Fenix Cliente 2026 (v4)
AppPublisher=BasePro
AppPublisherURL=http://www.basepro.com.br
AppSupportURL=http://www.basepro.com.br
AppUpdatesURL=http://www.basepro.com.br
DefaultDirName=c:\Fenix
DefaultGroupName=Fenix
OutputDir=Output
OutputBaseFilename=InstaladorFenixV4
DirExistsWarning=no
DisableDirPage=yes
DisableProgramGroupPage=yes

[Components]
Name: "principal"; Description: "Cliente Fenix"; Types: full compact custom; Flags: fixed
Name: "fenixreport"; Description: "Fenix Report"; Types: full

[Files]
Source: "..\bin\ClienteSAV.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite; Components: principal
Source: "..\extras\fenix.ico"; DestDir: "{app}"; CopyMode: alwaysoverwrite; Components: principal
Source: "..\extras\fenixReport.jar"; DestDir: "{app}"; CopyMode: alwaysoverwrite; Components: fenixreport
Source: "..\extras\lib\*"; DestDir: "{app}\lib\"; CopyMode: alwaysoverwrite; Flags: recursesubdirs createallsubdirs; Components: fenixreport

[Icons]
Name: "{group}\Fenix"; Filename: "{app}\ClienteSAV.exe"; Parameters: " -load sav"; IconFilename: "{app}\fenix.ico"; Components: principal
Name: "{group}\Configuração"; Filename: "{app}\ClienteSAV.exe"; IconFilename: "{app}\fenix.ico"; Components: principal
Name: "{commondesktop}\Fenix"; Filename: "{app}\ClienteSAV.exe"; Parameters: " -load sav"; IconFilename: "{app}\fenix.ico"; Components: principal
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\Fenix"; Filename: "{app}\ClienteSAV.exe"; Parameters: " -load sav"; IconFilename: "{app}\fenix.ico"; Tasks: quicklaunch; Components: principal

[Tasks]
Name: "quicklaunch"; Description: "Criar ícone no Quick Launch"; GroupDescription: "Ícones adicionais:"; Flags: unchecked
