{*******************************************************************************
  ����: dmzn@163.com 2018-04-25
  ����: ��ͬ����
*******************************************************************************}
unit UFrameContract;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, UFrameBase, Data.DB, Datasnap.DBClient,
  uniSplitter, uniBasicGrid, uniDBGrid, uniPanel, uniToolBar, uniGUIBaseClasses;

type
  TfFrameContract = class(TfFrameBase)
  private
    { Private declarations }
  public
    { Public declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
    //�������
  end;

implementation

{$R *.dfm}
uses
  uniGUIVars, MainModule, uniGUIApplication, USysDB;

function TfFrameContract.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_SaleContract;
end;

initialization
  RegisterClass(TfFrameContract);
end.
