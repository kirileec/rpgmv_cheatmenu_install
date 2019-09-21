unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,FileCtrl,System.IOUtils,System.StrUtils;

type
  TForm1 = class(TForm)
    lbledt1: TLabeledEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    function CheckDirValid(var dir:string):Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.JSON;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  dir :string;
begin
  if TDirectory.Exists('E:\') then
    dir := 'E:\'
  else
  if TDirectory.Exists('D:\') then
    dir := 'D:\';

  if (SelectDirectory('请选择游戏所在目录', '', dir)) then
  begin
    if not CheckDirValid(dir) then
    begin
      ShowMessage('目录选择不正确, 请重新选择');
      exit;
    end;
    lbledt1.Text := dir;
  end;
end;

procedure ExtractRes(ResName, ResNewName : String);
var
Res : TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, Resname, RT_RCDATA);
  Res.SavetoFile(ResNewName);
  Res.Free;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  dir:string;
  f:string;
  Res : TResourceStream;
  endIndex:Integer;
  str:string;
  cheatStr:string;
begin
  dir := lbledt1.Text;
  if not CheckDirValid(dir) then
  begin
    ShowMessage('目录选择不正确, 请重新选择');
    exit;
  end;
  lbledt1.Text := dir;

  ExtractRes('RES_CM_CSS',dir + '\www\js\plugins\Cheat_Menu.css');
  ExtractRes('RES_CM_JS',dir + '\www\js\plugins\Cheat_Menu.js');

  f := dir + '\www\js\plugins.js';
  str := TFile.ReadAllText(f,TEncoding.UTF8);
  endIndex := str.LastIndexOf(']');
  cheatStr := ',{"name":"Cheat_Menu","status":true,"description":"","parameters":{}}'     ;
  Insert(cheatStr,str,endIndex);
  //,{"name":"Cheat_Menu","status":true,"description":"","parameters":{}}
  TFile.WriteAllText(f,str);
  ShowMessage('配置成功, 请重启游戏');
end;



function TForm1.CheckDirValid(var dir: string): Boolean;
var
  f:string;
begin
  Result := true;
  if dir[Length(dir)]='\' then
    dir := LeftStr(dir,Length(dir)-1);
  f := '\package.json';
  if not TFile.Exists(dir + f) then
    Exit(False);
  f := '\www\js\plugins.js';
  if not TFile.Exists(dir + f) then
    Exit(False);

end;

end.
