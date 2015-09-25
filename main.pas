unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TmainForm }

  TmainForm = class(TForm)
    MC: TButton;
    C: TButton;
    backspace: TButton;
    buffer: TEdit;
    MS: TButton;
    MR: TButton;
    Mplus: TButton;
    equal: TButton;
    opposite: TButton;
    minus: TButton;
    plus: TButton;
    Edit: TEdit;
    CE: TButton;
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
    Mminus: TButton;
    two: TButton;
    three: TButton;
    zero: TButton;
    procedure backspaceClick(Sender: TObject);
    procedure buttonsSymbolsClick(Sender: TObject);
    procedure CClick(Sender: TObject);
    procedure CEClick(Sender: TObject);
    procedure changeSignClick(Sender: TObject);
    procedure dotClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure equalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure actionClick(Sender: TObject);
    procedure moduloClick(Sender: TObject);
    procedure oppositeClick(Sender: TObject);
    procedure sqrtBClick(Sender: TObject);
  private
    procedure changeEdit(ch: Char);
    procedure consider(op:Char);
    procedure initialVariables();
    procedure applyFunction(f: Char; old:String);
  public
    { public declarations }
  end;
const
  MAX_LENGTH_OF_NUMBER = 16;
  ERROR_MESSAGE = 'Ошибка';
type
  States = (Initial, ActionButton, Error);
var
  mainForm: TmainForm;
  state:States;
  lengthNumber:Integer;
  answer: Extended;
  operation: Char;
  changeValue:boolean;

implementation

{$R *.lfm}

{ Иницилизация begin}
procedure TmainForm.FormCreate(Sender: TObject);
begin
  answer:= 0;
  lengthNumber:= 1;
  state:= Initial;
  changeValue:= false;
end;

procedure TmainForm.initialVariables();
begin
  buffer.Text:= '';
  answer:= 0;
  Edit.Text:= '0';
end;
{ end }
{ Ввод begin }
procedure TmainForm.changeEdit(ch: Char);
begin
  if (changeValue) then begin
     Edit.Text:= '0';
     changeValue:= false;
  end;
  Edit.Text:= Edit.Text + ch;
end;

procedure TmainForm.buttonsSymbolsClick(Sender: TObject);
begin
  if (state <> Error) then begin
     changeEdit(TButton(Sender).Caption[1]);
  end;
end;

procedure TmainForm.FormKeyPress(Sender: TObject; var Key: char);
var
  symbols: Set of Char = ['0'..'9'];
begin
  if not (Key in symbols) then
     Key:= #0;
  changeEdit(Key);
end;

procedure TmainForm.dotClick(Sender: TObject);
var
  i:integer;
begin
  if (state <> Error) then begin
    for i:=1 to Length(Edit.Text) do
      if (Edit.Text[i] = ',') then exit;
    Edit.Text:= Edit.Text + ',';
  end;
end;

procedure TmainForm.EditChange(Sender: TObject);
var
  i:integer;
begin
  if (Length(Edit.Text) > 1) and (Edit.Text[1] = '0') then
        Edit.Text:= copy(Edit.Text, 2, Length(Edit.Text))
  else if (Edit.Text = '') or (Edit.Text = '-') then
     Edit.Text:= '0';
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
end;
{ end }
{ Вычислительные операции begin }
procedure TmainForm.consider(op:Char);
begin
  case op of
     '+': answer:= answer + StrToFloat(Edit.Text);
     '-': answer:= answer - StrToFloat(Edit.Text);
     '*': answer:= answer * StrToFloat(Edit.Text);
     '/':
       Try
          answer:= answer / StrToFloat(Edit.Text);
       Except on EDivByZero do
       begin
          initialVariables();
          Edit.Text:= ERROR_MESSAGE;
          state:= Error;
       end;
       end;
  end;
end;

procedure TmainForm.actionClick(Sender: TObject);
begin
  if (state <> Error) then begin
    operation:= TButton(Sender).Caption[1];
    if (buffer.Text = '') then
        answer:= StrToFloat(Edit.Text);
    if (buffer.Text = '') or ((buffer.Text <> '') and (buffer.Text[Length(buffer.Text) - 1] in ['+','-','*','/'])) then
       buffer.Text:= buffer.Text + Edit.Text + ' ' + operation + ' '
    else
       buffer.Text:= buffer.Text + ' ' + operation + ' ';
    if (state = ActionButton) then
        consider(operation);
    state:= ActionButton;
    changeValue:= true;
  end;
end;

procedure TmainForm.applyFunction(f: Char; old:String);
begin
  if (buffer.Text = '') then
     answer:= StrToFloat(Edit.Text)
  else begin
    consider(buffer.Text[Length(buffer.Text) - 1]);
    state:= Initial;
    changeValue:= true;
  end;
  case f of
     's': buffer.Text:= buffer.Text + '√(' + old + ')';
     '%': buffer.Text:= buffer.Text + old;
     '/': buffer.Text:= buffer.Text + '1/(' + old + ')';
  end;
end;

procedure TmainForm.sqrtBClick(Sender: TObject);
var
  old:String;
begin
  if (state <> Error) then begin
    old:= Edit.Text;
    Try
       Edit.Text:= FloatToStr(sqrt(StrToFloat(Edit.Text)));
    Except on EInvalidOp do begin
      Edit.Text:= ERROR_MESSAGE;
      state:= Error;
      end;
    end;
    applyFunction('s', old);
  end;
end;

procedure TmainForm.moduloClick(Sender: TObject);
begin
  if (state <> Error) then begin
    Edit.Text:= FloatToStr(answer / 100 * StrToFloat(Edit.Text));
    applyFunction('%', Edit.Text);
  end;
end;

procedure TmainForm.oppositeClick(Sender: TObject);
var
  old:String;
begin
  if (state <> Error) then begin
    old:= Edit.Text;
    Try
       Edit.Text:= FloatToStr(1 / StrToFloat(Edit.Text));
    Except on EDivByZero do
    begin
      Edit.Text:= ERROR_MESSAGE;
      state:= Error;
    end;
    end;
    applyFunction('/', old);
  end;
end;
{ end }
{Служебные функции begin }
procedure TmainForm.backspaceClick(Sender: TObject);
begin
  if (Length(Edit.Text) <> 0) and (state <> Error) then
      Edit.Text:= copy(Edit.Text, 1, Length(Edit.Text)-1);
end;

procedure TmainForm.CEClick(Sender: TObject);
begin
  Edit.Text:= '0';
  if (state = Error) then begin
     buffer.Text:= '';
     answer:= 0;
     state:= Initial;
  end;
end;

procedure TmainForm.CClick(Sender: TObject);
begin
  initialVariables();
  state:= Initial;
end;

procedure TmainForm.changeSignClick(Sender: TObject);
begin
  if not (state = Error) then
     Edit.Text:= FloatToStr((-1) * StrToFloat(Edit.Text));
end;

procedure TmainForm.equalClick(Sender: TObject);
begin
  if (state = ActionButton) then
      consider(operation);
  if not (state = Error) then begin
      Edit.Text:= FloatToStr(answer);
      buffer.Text:= '';
      answer:= 0;
      state:= Initial;
  end;
end;
{ end }

{ Буфер begin }
// TODO
{ end }

end.

