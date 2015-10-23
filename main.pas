unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, about, Menus, ActnList, LCLtype;

type

  { TmainForm }

  TmainForm = class(TForm)
    MainMenu: TMainMenu;
    MC: TButton;
    C: TButton;
    backspace: TButton;
    buffer: TEdit;
    aboutItem: TMenuItem;
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
    divide: TButton;
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
    procedure aboutItemClick(Sender: TObject);
    procedure backspaceClick(Sender: TObject);
    procedure buttonsSymbolsClick(Sender: TObject);
    procedure CClick(Sender: TObject);
    procedure CEClick(Sender: TObject);
    procedure changeSignClick(Sender: TObject);
    procedure dotClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure equalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure actionClick(Sender: TObject);
    procedure MCClick(Sender: TObject);
    procedure moduloClick(Sender: TObject);
    procedure MactionClick(Sender: TObject);
    procedure MRClick(Sender: TObject);
    procedure MSClick(Sender: TObject);
    procedure oppositeClick(Sender: TObject);
    procedure sqrtBClick(Sender: TObject);
  private
    procedure changeEdit(ch: Char);
    procedure consider(op: Char; var ans: Extended);
    procedure applyFunction(f: Char; old: String);
    function isDotExist(): Boolean;
  public
    { public declarations }
  end;

  var
    mainForm: TmainForm;

implementation

const
  MAX_LENGTH_OF_NUMBER = 16;
  ERROR_MESSAGE = 'Ошибка';
type
  States = (Initial, ActionButton, FunctionButton, EqualOperation, Error);
var
  state:States;
  lengthNumber, startFunc:Integer;
  answer, memory, lastNumber, equalAns, lastFuncAns: Extended;
  operation: Char;
  changeValue: Boolean;

{$R *.lfm}

{ Иницилизация begin}
procedure TmainForm.FormCreate(Sender: TObject);
begin
  buffer.Text:= '';
  answer:= 0;
  Edit.Text:= '0';
  lengthNumber:= 1;
  state:= Initial;
  changeValue:= false;
  memory:= 0;
  Edit.MaxLength:= MAX_LENGTH_OF_NUMBER;
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
  if (state = FunctionButton) then begin
     if (buffer.Text = '') then
        state:= Initial
     else
        state:= ActionButton;
     buffer.Text:= copy(buffer.Text, 1, startFunc);
  end;
  if (state = Initial) then equalAns:= StrToFloat(Edit.Text);
end;

procedure TmainForm.buttonsSymbolsClick(Sender: TObject);
begin
  if (state <> Error) then begin
     changeEdit(TButton(Sender).Caption[1]);
  end;
end;

procedure TmainForm.FormKeyPress(Sender: TObject; var Key: char);
var
  symbols: Set of Char = ['0'..'9', '+', '-', '*', '/', '=', '%', #08, #13, #27];
begin
  if not (Key in symbols) then
     Key:= #0;
  case Key of
     '+': plus.Click();
     '-': minus.Click();
     '*': multiply.Click();
     '/': divide.Click();
     '%': modulo.Click();
     '=', #13: equal.Click();
     #08: backspace.Click();
     #27: C.Click();
     else changeEdit(Key);
  end;
end;

procedure TmainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Edit.SelectAll;
  if (Key = VK_F9) then changeSign.Click();
  if (Key = 67) and (Shift = [ssCtrl]) then Edit.CopyToClipboard;
  //if (Key = 86) and (Shift = [ssCtrl]) then Edit.PasteFromClipboard; PASTE Ctrl+V
end;

function TmainForm.isDotExist(): Boolean;
var
  i: integer;
begin
  isDotExist:= false;
  for i:=1 to Length(Edit.Text) do
      if (Edit.Text[i] = ',') then isDotExist:= true;
end;

procedure TmainForm.dotClick(Sender: TObject);
begin
  if (state <> Error) then begin
    if (isDotExist) then exit;
    Edit.Text:= Edit.Text + ',';
  end;
end;

procedure TmainForm.EditChange(Sender: TObject);
var
  i:integer;
begin
  if (Length(Edit.Text) > 1) and (Edit.Text[1] = '0') and not(isDotExist) then
     Edit.Text:= copy(Edit.Text, 2, Length(Edit.Text))
  else if (Edit.Text = '') or (Edit.Text = '-') then Edit.Text:= '0';
  lengthNumber:= 0;
  for i:=1 to Length(Edit.Text) do
      if (Edit.Text[i] in ['0'..'9']) then inc(lengthNumber);
  if (lengthNumber = MAX_LENGTH_OF_NUMBER) then Edit.Enabled:= False
  else Edit.Enabled:= True;
end;
{ end }
{ Вычислительные операции begin }
procedure TmainForm.consider(op:Char; var ans: Extended);
begin
  case op of
     '+': ans+= StrToFloat(Edit.Text);
     '-': ans-= StrToFloat(Edit.Text);
     '*': ans*= StrToFloat(Edit.Text);
     '/':
       Try
          ans/= StrToFloat(Edit.Text);
       Except on EDivByZero do
       begin
          Edit.Text:= ERROR_MESSAGE;
          state:= Error;
       end;
       end;
  end;
end;

procedure TmainForm.actionClick(Sender: TObject);
var
  oldOp: Char;
begin
  if (state <> Error) then begin
    oldOp:= operation;
    operation:= TButton(Sender).Caption[1];
    if (buffer.Text = '') then begin
      answer:= StrToFloat(Edit.Text);
      buffer.Text:= buffer.Text + Edit.Text + ' ' + operation + ' ';
    end
    else if (state = ActionButton) and (changeValue) then begin
      buffer.Text:= copy(buffer.Text, 1, Length(buffer.Text) - 2);
      buffer.Text:= buffer.Text + operation + ' ';
    end
    else if (state = ActionButton) and not(changeValue) then begin
      buffer.Text:= buffer.Text + Edit.Text + ' ' + operation + ' ';
      consider(oldOp, answer);
    end
    else if (state = FunctionButton) then begin
      consider(oldOp, answer);
      buffer.Text:= buffer.Text + ' ' + operation + ' ';
    end;
    Edit.Text:= FloatToStr(answer);
    state:= ActionButton;
    changeValue:= true;
  end;
end;

procedure TmainForm.applyFunction(f: Char; old:String);
var
  subStr: String;
begin
  if (state <> FunctionButton) then begin
    startFunc:= Length(buffer.Text);
    if (buffer.Text = '') then
      answer:= StrToFloat(Edit.Text);
    case f of
       's': buffer.Text:= buffer.Text + '√(' + old + ')';
       '%': buffer.Text:= buffer.Text + old;
       '/': buffer.Text:= buffer.Text + '1/(' + old + ')';
    end;
  end
  else begin
    subStr:= '';
    case f of
      's': subStr:= '√(';
      '%': buffer.Text:= copy(buffer.Text, 1, startFunc) + old;
      '/': subStr:= '1/(';
    end;
    if (subStr <> '') then begin
      subStr:= subStr + copy(buffer.Text, startFunc, Length(buffer.Text)) + ')';
      buffer.Text:= copy(buffer.Text, 1, startFunc) + subStr;
    end;
    if (buffer.Text = '') or (startFunc = 0) then
      answer:= StrToFloat(Edit.Text)
  end;
  state:= FunctionButton;
  changeValue:= true;
end;

procedure TmainForm.sqrtBClick(Sender: TObject);
var
  old:String;
begin
  if (state <> Error) then begin
    old:= Edit.Text;
    Try
       lastFuncAns:= StrToFloat(Edit.Text);
       Edit.Text:= FloatToStr(sqrt(StrToFloat(Edit.Text)));
       applyFunction('s', old);
    Except on EInvalidOp do begin
      Edit.Text:= ERROR_MESSAGE;
      state:= Error;
      end;
    end;
  end;
end;

procedure TmainForm.moduloClick(Sender: TObject);
begin
  if (state <> Error) then begin
    lastFuncAns:= StrToFloat(Edit.Text);
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
       lastFuncAns:= StrToFloat(Edit.Text);
       Edit.Text:= FloatToStr(1 / StrToFloat(Edit.Text));
       applyFunction('/', old);
    Except on EDivByZero do
    begin
      Edit.Text:= ERROR_MESSAGE;
      state:= Error;
    end;
    end;
  end;
end;
{ end }
{Служебные функции begin }
procedure TmainForm.backspaceClick(Sender: TObject);
begin
  if (Length(Edit.Text) <> 0) and (state <> Error) and not(changeValue) then
      Edit.Text:= copy(Edit.Text, 1, Length(Edit.Text)-1);
end;

procedure TmainForm.CEClick(Sender: TObject);
begin
  Edit.Text:= '0';
  equalAns:= 0;
  if (state = Error) then begin
     buffer.Text:= '';
     answer:= 0;
     state:= Initial;
  end;
end;

procedure TmainForm.CClick(Sender: TObject);
begin
  buffer.Text:= '';
  answer:= 0;
  Edit.Text:= '0';
  lengthNumber:= 1;
  state:= Initial;
  changeValue:= false;
  operation:= ' ';
  equalAns:= 0;
  lastFuncAns:= 0;
  state:= Initial;
end;

procedure TmainForm.changeSignClick(Sender: TObject);
begin
  if (state <> Error) then
     Edit.Text:= FloatToStr((-1) * StrToFloat(Edit.Text));
end;

procedure TmainForm.equalClick(Sender: TObject);
begin
  if (state = ActionButton) or (state = FunctionButton) then begin
    lastNumber:= StrToFloat(Edit.Text);
    consider(operation, answer);
    equalAns:= answer;
  end;
  if (state = Initial) then begin
    Edit.Text:= FloatToStr(lastNumber);
    consider(operation, equalAns);
    Edit.Text:= FloatToStr(equalAns);
  end
  else if (state <> Error) then begin
    Edit.Text:= FloatToStr(answer);
    buffer.Text:= '';
    answer:= 0;
    state:= Initial;
  end;
  changeValue:= true;
end;
{ end }

{ Память begin }
procedure TmainForm.MCClick(Sender: TObject);
begin
  memory:= 0;
end;

procedure TmainForm.MRClick(Sender: TObject);
begin
  if (state <> Error) then begin
      Edit.Text:= FloatToStr(memory);
      changeValue:= true;
  end;
end;

procedure TmainForm.MSClick(Sender: TObject);
begin
  if (state <> Error) then begin
      memory:= StrToFloat(Edit.Text);
      changeValue:= true;
  end;
end;

procedure TmainForm.MactionClick(Sender: TObject);
var
  operationM: Char;
begin
  if (state <> Error) then begin
    operationM:= TButton(Sender).Caption[2];
    case operationM of
       '+': memory+= StrToFloat(Edit.Text);
       '-': memory-= StrToFloat(Edit.Text);
    end;
    changeValue:= true;
  end;
end;
{ end }
{ Меню begin}
procedure TmainForm.aboutItemClick(Sender: TObject);
begin
  about.aboutForm.Show();
end;
{ end }
end.

