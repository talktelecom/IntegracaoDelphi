unit UMain;

interface

uses
  Windows, Classes, Forms, StdCtrls, Controls, UThLogar, UAtendimento, Dialogs,
  SysUtils;

type
  TFormMain = class(TForm)
    btnLogar: TButton;
    procedure btnLogarClick(Sender: TObject);
  private
    _thLogar: ThLogar;
    procedure Logar(ramal : Integer; senha : String);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}

procedure TFormMain.btnLogarClick(Sender: TObject);
begin
  Logar(1006, 'TalkTelecom$@2017');
end;

procedure TFormMain.Logar(ramal : Integer; senha : String);
var
  ret : Bool;
  _atendimento : Atendimento;
begin
  _atendimento := Atendimento.Create;

  ret := _atendimento.Inicia;
  if (ret = false)  then begin
    { TODO : Logar erro }
    exit;
  end;

  { Inicializar métodos e eventos }


  _thLogar := ThLogar.Create (false, ramal, senha, _atendimento, Self);
end;

end.



