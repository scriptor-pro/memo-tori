#define MyAppName "Memo Tori"
#define MyAppExeName "memo-tori.exe"
#define MyAppVersion "__VERSION__"
#define MyAppPublisher "Memo Tori"
#define MyAppId "{{A7B8C9D0-1234-5678-9ABC-DEF012345678}"
#define MySourceDir "__SOURCE_DIR__"

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir={#MySourceDir}\dist
OutputBaseFilename=memo-tori-{#MyAppVersion}-setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "Create a Desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
Source: "{#MySourceDir}\dist\memo-tori\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\dist\memo-tori\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent
