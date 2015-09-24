unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TmainForm }

  TmainForm = class(TForm)
    C: TButton;
    backspace: TButton;
    buffer: TEdit;
    equal: TButton;
    multiply1: TButton;
    minus: TButton;
    plus: TButton;
    Edit: TEdit;
    ce: TButton;
    four: TButton;
    one: TButton;
    plus1: TButton;
    modulo: TButton;
    changeSign: TButton;
    multiply: TButton;
    sqrtB: TButton;
    six: TButton;
    five: TButton;
    nine: TButton;
    eight: TButton;
    seven: TButton;
    dot: TButton;
    two: TButton;
    three: TButton;
    zero: TButton;
    procedure backspaceClick(Sender: TObject);
    procedure buttonsSymbolsClick(Sender: TObject);
    procedure CClick(Sender: TObject);
    procedure ceClick(Sender: TObject);
    procedure changeSignClick(Sender: TObject);
    procedure dotClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure sqrtBClick(Sender: TObject);
  private
    procedure changeEdit(ch: Char);
  public
    { public declarations }
  end;
const
  MAX_LENGTH_OF_NUMBER = 16;
type
  States = (Initial, Action, Error);
var
  mainForm: TmainForm;
  state:States;
  lengthNumber:Integer;
  answer: Extended;

implementation

{$R *.lfm}

{ TmainForm }

procedure TmainForm.changeEdit(ch: Char);
begin
  Edit.Text:= Edit.Text + ch;
end;

procedure TmainForm.buttonsSymbolsClick(Sender: TObject);
begin
  changeEdit(TButton(Sender).Caption[1]);
end;

procedure TmainForm.dotClick(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to Length(Edit.Text) do
    if (Edit.Text[i] = ',') then exit;
  Edit.Text:= Edit.Text + ',';
end;

procedure TmainForm.EditChange(Sender: TObject);
var
  i:integer;
begin
  if (Length(Edit.Text) > 1) then begin
     if (Edit.Text[1] = '0') then
        Edit.Text:= copy(Edit.Text, 2, Length(Edit.Text));
     lengthNumber:= 0;
     for i:=1 to Length(Edit.Text) do
       if (Edit.Text[i] in ['0'..'9']) then
          inc(lengthNumber);
     if (lengthNumber = MAX_LENGTH_OF_NUMBER) then
        Edit.Enabled:= False
     else if (lengthNumber > MAX_LENGTH_OF_NUMBER) then
        Edit.Text:= copy(Edit.Text, 1, Length(Edit.Text)-1)
     else
         Edit.Enabled:= True;
  end
  else if (Edit.Text = '') or (Edit.Text = '-') then
     Edit.Text:= '0';
end;

procedure TmainForm.backspaceClick(Sender: TObject);
begin
  if (Length(Edit.Text) <> 0) then
      Edit.Text:= copy(Edit.Text, 1, Length(Edit.Text)-1);
end;

procedure TmainForm.CClick(Sender: TObject);
begin
  buffer.Text:= '';
  answer:= 0;
  Edit.Text:= '0';
end;

procedure TmainForm.ceClick(Sender: TObject);
begin
  Edit.Text:= '0';
end;

procedure TmainForm.FormKeyPress(Sender: TObject; var Key: char);
var
  symbols: Set of Char = ['0'..'9'];
begin
  if not (Key in symbols) then
     Key:= #0;
  changeEdit(Key);
end;

procedure TmainForm.changeSignClick(Sender: TObject);
begin
  Edit.Text:= FloatToStr((-1) * StrToFloat(Edit.Text));
end;

procedure TmainForm.sqrtBClick(Sender: TObject);
begin
  Try
     Edit.Text:= FloatToStr(sqrt(StrToFloat(Edit.Text)));
  Except on EInvalidOp do
     buffer.Text:= 'Ошибка';
  end;
end;

end.

