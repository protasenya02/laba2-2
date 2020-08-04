program laba2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Types in 'Types.pas',
  Procedures in '\\Mac\Home\Documents\Embarcadero\Studio\Projects\2 семестр\лаба 4\Procedures.pas';

begin
ReadFile;
HeadAddress:= SearchHead;
MainMenu;
readln;
end.
