unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, UTF8Process, LCLIntf;

type

  { TaboutForm }

  TaboutForm = class(TForm)
    gitHub: TButton;
    StaticText: TStaticText;
    procedure gitHubClick(Sender: TObject);
  private
    { priцvate declarations }
  public
    { public declarations }
  end;

var
  aboutForm: TaboutForm;
  Browser, Params, URL : String;
  p:LongInt;
  myProcess : TProcessUTF8;

implementation

{$R *.lfm}

{ TaboutForm }


procedure TaboutForm.gitHubClick(Sender: TObject);
begin
  FindDefaultBrowser(Browser, Params);
  URL:= 'https://github.com/jokly/PASCulator';
  p:=System.Pos('%s', Params);
  System.Delete(Params, p, 2);
  System.Insert(URL, Params, p);
  myProcess := TProcessUTF8.Create(nil);
  with myProcess do
  try
    CommandLine := Browser + ' ' + Params;
    Execute;
  finally
    Free;
  end;
end;

end.

