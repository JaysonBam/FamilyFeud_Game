unit FamilyF_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, pngimage, DB, ADODB;

type
  TfrmFamilyFeud = class(TForm)
    pgc1: TPageControl;
    tsInput: TTabSheet;
    tsMainGame: TTabSheet;
    tsFastRound: TTabSheet;
    pnlVraag: TPanel;
    pnlOne: TPanel;
    pnlTwo: TPanel;
    pnlThree: TPanel;
    pnlFour: TPanel;
    pnlFive: TPanel;
    pnlSix: TPanel;
    pnlSeven: TPanel;
    pnlEight: TPanel;
    pnlSilver1: TPanel;
    pnlOranje: TPanel;
    pnlSilver2: TPanel;
    pnlSwart: TPanel;
    pnlXPoints: TPanel;
    pnlTeamA: TPanel;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    btnGame: TButton;
    lblTeamA: TLabel;
    shp1: TShape;
    shp4: TShape;
    shp2: TShape;
    shp3: TShape;
    shp5: TShape;
    pnlA1: TPanel;
    pnlP1: TPanel;
    pnlA2: TPanel;
    pnlP2: TPanel;
    pnlA3: TPanel;
    pnlP3: TPanel;
    pnlA4: TPanel;
    pnlP4: TPanel;
    pnlA5: TPanel;
    pnlP5: TPanel;
    pnlA6: TPanel;
    pnlP6: TPanel;
    pnlA7: TPanel;
    pnlP7: TPanel;
    pnlA8: TPanel;
    pnlP8: TPanel;
    pnl1: TPanel;
    pnlTotal: TPanel;
    lblTeamB: TLabel;
    pnlTeanB: TPanel;
    tbl: TADOTable;
    pnlTeamAG: TPanel;
    pnlTeamBG: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure btnGameClick(Sender: TObject);
    procedure btnGameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure MakeRounded(Control: TWinControl);
    procedure RoundNumber(Number: Integer);
    procedure SetPanel(Number: Integer);
    procedure ClearPage;
    procedure SetStrikes(Number: Integer);
    procedure SetTeam(Team:char);
    procedure TurnPanel(PanelNumber:integer);
    procedure NewRound;
  public
    iRoundNumber,iX,iTeamA,iTeamB,iTotal,iStrikes,iAnswer,iAnswerCorrect:Integer;
    arrDone:array[1..100] of Boolean;
    arrP:array[1..8] of Integer;
    arrA:array[1..8] of string;
    arrCorrect:array[1..8] of Boolean;
    cActive:char;
    { Public declarations }
  end;

var
  frmFamilyFeud: TfrmFamilyFeud;

implementation

{$R *.dfm}

procedure TfrmFamilyFeud.btnGameClick(Sender: TObject);
var
iRandom,iQ:Integer;
  I: Integer;
  tFile:TextFile;
begin
 ClearPage;
 RoundNumber(1);
 NewRound;

end;

procedure TfrmFamilyFeud.btnGameKeyPress(Sender: TObject; var Key: Char);
var
bSteal,bCorrect,bIncorrect:Boolean;
begin
 bCorrect:=False;
 bIncorrect:=False;
 if UpCase(Key)='N' then
 begin
   NewRound
 end;

 if (UpCase(key)='A') or (UpCase(key)='B') then
 begin
  SetTeam(UpCase(key));
  //Box die panel. Set Active
 end;
 if Key in ['0'..'8'] then
 begin
  if iStrikes=3 then bSteal:=True else bSteal:=False;
  if (arrCorrect[StrToInt(key)]=False) and (Key in ['1'..IntToStr(iAnswer)[1]]) then
  begin
    //ShowMessage('1');
    arrCorrect[StrToInt(key)]:=True;
    inc(iAnswerCorrect);
    TurnPanel(StrToInt(key));
    bCorrect:=True;
  end;
  if Key='0' then
  begin
   SetStrikes(iStrikes+1);
   bIncorrect:=True;
  end;
  //Einde van Rondte


 // if bSteal then ShowMessage('bSteal=true') else ShowMessage('bSteal=fasle');
 // if bIncorrect then ShowMessage('bIncorrect=true') else ShowMessage('bIncorrect=fasle');
 // if bCorrect then ShowMessage('bCorrect=true') else ShowMessage('bCorrect=fasle');



  if bSteal and bIncorrect then
  begin
  // ShowMessage('1');
   if cActive='A' then
    iTeamA:=iTeamA+iTotal;
   if cActive='B' then
    iTeamB:=iTeamB+iTotal;
    RoundNumber(iRoundNumber+1);
  end;
  if bSteal and bCorrect then
  begin
  // ShowMessage('2');
   if cActive='A' then
    iTeamB:=iTeamB+iTotal;
   if cActive='B' then
    iTeamA:=iTeamA+iTotal;
    RoundNumber(iRoundNumber+1);
  end;
  if (bSteal = false) and (iAnswer=iAnswerCorrect) then
  begin
  // ShowMessage('3');
   if cActive='A' then
    iTeamA:=iTeamA+iTotal;
   if cActive='B' then
    iTeamB:=iTeamB+iTotal;
    RoundNumber(iRoundNumber+1);
  end;
  pnlTeamA.Caption:=IntToStr(iTeamA);
  pnlTeanB.Caption:=IntToStr(iTeamB);
 end;
/////////////////////////////////////////////////////////////////////////////////////
end;

procedure TfrmFamilyFeud.ClearPage;
var
  I: Integer;
begin
 pnlTotal.Caption:='0';
 pnlTeamA.Caption:='0';
 pnlTeanB.Caption:='0';
 iTeamA:=0;
 iTeamB:=0;
 iTotal:=0;
 iAnswerCorrect:=0;

 SetPanel(0);
 SetStrikes(0);
 for I := 1 to 8 do
 arrCorrect[I]:=False;

end;

procedure TfrmFamilyFeud.FormActivate(Sender: TObject);
var
  I: Integer;
begin
 MakeRounded(pnlSilver1);
 MakeRounded(pnlSilver2);
 MakeRounded(pnlOranje);
 MakeRounded(pnlSwart);
 MakeRounded(pnl1);

 for I := 1 to 100 do
 begin
   arrDone[I]:=False;
 end;

end;

procedure TfrmFamilyFeud.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, - 5, - 5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;


procedure TfrmFamilyFeud.NewRound;//Panel,iAntwoorde,arrA,arrP,arrCorrect,iAnwerCorrect
var
I,iRandom:Integer;
tFile:TextFile;
begin
 repeat                         //Kry unike random Number
  iRandom:=Random(99)+1
 until (arrDone[iRandom]=false);
 arrDone[iRandom]:=True;

 tbl.Open;                      //Kyk hoeveel antwoorde daar is
 tbl.First;
 for I := 1 to iRandom do
  tbl.Next;
 if tbl['P5']=0 then iAnswer:=4 else
 if tbl['P6']=0 then iAnswer:=5 else
 if tbl['P7']=0 then iAnswer:=6 else
 if tbl['P8']=0 then iAnswer:=7 else
                     iAnswer:=8;

 SetPanel(iAnswer);              //Stel Net panel

 pnlVraag.Caption:=tbl['Q'];     //Sit vraag op panel

 for I := 1 to iAnswer do        //Sit vrae en antwoorde op array
  begin                          //Sel al die vraag as verrkeerd
    arrP[I]:=tbl['P'+IntToStr(I)];
    arrA[I]:=tbl['A'+IntToStr(I)];
    arrCorrect[I]:=False;
  end;

 iAnswerCorrect:=0;              //Maak iAnwserCorrect = 0

 AssignFile(tFile,'J:\FamilyFeudAntwoorde.txt');    //Skryf antwoorde op text file
 Rewrite(tFile);
 Writeln(tFile,tbl['Q']);
 for I := 1 to iAnswer do
  Writeln(tFile,IntToStr(I)+'. '+arrA[I]);
 CloseFile(tFile);

 pnlTotal.Caption:='0';
 iTotal:=0;
 iStrikes:=0;
 SetStrikes(0);
end;

procedure TfrmFamilyFeud.SetPanel(Number: Integer);
var
  J: Integer;
begin
 pnlA1.Caption:='';
 pnlP1.Caption:='';
 pnlA2.Caption:='';
 pnlP2.Caption:='';
 pnlA3.Caption:='';
 pnlP3.Caption:='';
 pnlA4.Caption:='';
 pnlP4.Caption:='';
 pnlA5.Caption:='';
 pnlP5.Caption:='';
 pnlA6.Caption:='';
 pnlP6.Caption:='';
 pnlA7.Caption:='';
 pnlP7.Caption:='';
 pnlA8.Caption:='';
 pnlP8.Caption:='';

for J := 1 to Number do
 case J of
  1:pnlA1.Caption:='1';
  2:pnlA2.Caption:='2';
  3:pnlA3.Caption:='3';
  4:pnlA4.Caption:='4';
  5:pnlA5.Caption:='5';
  6:pnlA6.Caption:='6';
  7:pnlA7.Caption:='7';
  8:pnlA8.Caption:='8';
 end;


end;

procedure TfrmFamilyFeud.SetStrikes(Number: Integer);
var
  I: Integer;
begin
 img1.Visible:=False;
 img2.Visible:=False;
 img3.Visible:=False;

 for I := 1 to Number do
 case I of
  1 :begin
      iStrikes:=1;
      img1.Visible:=True;
     end;
  2 :begin
      iStrikes:=2;
      img2.Visible:=True;
     end;
  3 :begin
      iStrikes:=3;
      img3.Visible:=True;
     end;
 end;

end;

procedure TfrmFamilyFeud.SetTeam(Team: char);
begin
 with pnlTeamA do
 begin
  Top:=0;
  Left:=0;
  Width:=273;
  Height:=90;
 end;
 with pnlTeanB do
 begin
  Top:=0;
  Left:=0;
  Width:=273;
  Height:=90;
 end ;
 case Team of
  'A':begin
        with pnlTeamA do
         begin
          Top:=5;
          Left:=5;
          Width:=263;
          Height:=80;
          cActive:='A';
         end;

      end;
  'B':begin
        with pnlTeanB do
         begin
          Top:=5;
          Left:=5;
          Width:=263;
          Height:=80;
          cActive:='B';
         end;
      end;
 end;
end;

procedure TfrmFamilyFeud.TurnPanel(PanelNumber: integer);
begin
  case PanelNumber of
   1:begin
      pnlA1.Caption:=arrA[1];
      pnlP1.Caption:=IntToStr(arrP[1]);
     end;
   2:begin
      pnlA2.Caption:=arrA[2];
      pnlP2.Caption:=IntToStr(arrP[2]);
     end;
   3:begin
      pnlA3.Caption:=arrA[3];
      pnlP3.Caption:=IntToStr(arrP[3]);
     end;
   4:begin
      pnlA4.Caption:=arrA[4];
      pnlP4.Caption:=IntToStr(arrP[4]);
     end;
   5:begin
      pnlA5.Caption:=arrA[5];
      pnlP5.Caption:=IntToStr(arrP[5]);
     end;
   6:begin
      pnlA6.Caption:=arrA[6];
      pnlP6.Caption:=IntToStr(arrP[6]);
     end;
   7:begin
      pnlA7.Caption:=arrA[7];
      pnlP7.Caption:=IntToStr(arrP[7]);
     end;
   8:begin
      pnlA8.Caption:=arrA[8];
      pnlP8.Caption:=IntToStr(arrP[8]);
     end;
  end;

   itotal:=itotal+arrP[PanelNumber]*iX ;
   pnlTotal.caption:=inttostr(itotal);
end;

procedure TfrmFamilyFeud.RoundNumber(Number: Integer);
var
  J: Integer;
begin
 shp1.Brush.Color:=clSilver;
 shp2.Brush.Color:=clSilver;
 shp3.Brush.Color:=clSilver;
 shp4.Brush.Color:=clSilver;
 shp5.Brush.Color:=clSilver;

for J := 1 to Number do
 case J of
  1: begin
      shp1.Brush.Color:=clLime;
      pnlXPoints.Caption:='x 1';
      iRoundNumber:=1;
      iX:=1;
     end;
  2: begin
      shp2.Brush.Color:=clLime;
      pnlXPoints.Caption:='x 1';
      iRoundNumber:=2;
      iX:=1;
     end;
  3: begin
      shp3.Brush.Color:=clLime;
      pnlXPoints.Caption:='x 2';
      iRoundNumber:=3;
      iX:=2;
     end;
  4: begin
      shp4.Brush.Color:=clLime;
      pnlXPoints.Caption:='x 2';
      iRoundNumber:=4;
      iX:=2;
     end;
  5: begin
      shp5.Brush.Color:=clLime;
      pnlXPoints.Caption:='x 3';
      iRoundNumber:=5;
      iX:=3;
     end;
 end;


end;

end.
