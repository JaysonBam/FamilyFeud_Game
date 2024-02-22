program FamilyF_p;

uses
  Forms,
  FamilyF_u in 'FamilyF_u.pas' {frmFamilyFeud};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmFamilyFeud, frmFamilyFeud);
  Application.Run;
end.
