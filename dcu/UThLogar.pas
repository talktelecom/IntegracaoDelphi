unit UThLogar;

interface

uses  Windows,
      Forms,
      Dialogs,
      SysUtils,
      Classes,
      UGlobalAtendimento,
      UAtendimento;
type
  ThLogar = class(TThread)
    private
      _ramal : Integer;
      _senha : String;
      _formMain : TForm;
      _atendimento : Atendimento;
    protected
      procedure Execute; override;
    public
      constructor Create( const CreateSuspended : boolean;
                            ramal : Integer;
                            senha : String;
                            atendimento : Atendimento;
                            formMain : TForm);
  end;

implementation

constructor ThLogar.Create( const CreateSuspended : boolean;
                            ramal : Integer;
                            senha : String;
                            atendimento : Atendimento;
                            formMain : TForm);
begin
  _ramal := ramal;
  _senha := senha;
  _formMain := formMain;
  _atendimento := atendimento;
  FreeOnTerminate := true;
  inherited Create(CreateSuspended);
end;

procedure ThLogar.Execute;
begin
  _atendimento.Logar(_ramal, _senha);
end;

end.
