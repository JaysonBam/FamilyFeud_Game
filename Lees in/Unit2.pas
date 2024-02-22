unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  TForm2 = class(TForm)
    btn1: TButton;
    tblF: TADOTable;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
var
  I,K: Integer;
  sLyn,sLyn1:string;
  tFile:TextFile;
begin
tblF.Open;
 AssignFile(tFile,'Family.txt');
 Reset(tFile);
 Readln(tFile,sLyn);
for I := 1 to 100 do
 begin
   tblF.Last;
   tblF.Insert;
   tblF['Q'] := copy(sLyn, 4, length(sLyn));
   Readln(tFile, sLyn1);
   tblF['Enable'] := True;
   tblF['ID']:=I;
   K := 0;
   Readln(tFile, sLyn);
   while Pos(IntToStr(I + 1) + '.', sLyn) = 0 do
    begin
     // ShowMessage('1-'+sLyn);
     // ShowMessage(IntToStr(Pos(IntToStr(I + 1) + '.', sLyn)));
      inc(K);
     if K<=8 then
     begin
      tblF['A' + IntToStr(K)] := copy(sLyn, 1, Pos('(', sLyn) - 1);
      Delete(sLyn, 1, Pos('(', sLyn));
      tblF['P' + IntToStr(K)] := strtoint(copy(sLyn, 1, Pos(')', sLyn) - 1));
     end;
      Readln(tFile, sLyn);
    end;
   tblF.Post;
 end;
 CloseFile(tfile);
end;

end.
