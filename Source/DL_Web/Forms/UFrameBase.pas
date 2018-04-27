{*******************************************************************************
  ����: dmzn@163.com 2018-04-25
  ����: Frame����
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniToolBar, uniGUIBaseClasses, uniPanel, Data.DB,
  Data.Win.ADODB, Datasnap.DBClient, uniBasicGrid, uniDBGrid, uniSplitter,
  System.IniFiles, uniTimer;

type
  TfFrameBase = class(TUniFrame)
    PanelWork: TUniContainerPanel;
    UniToolBar1: TUniToolBar;
    BtnAdd: TUniToolButton;
    BtnEdit: TUniToolButton;
    BtnDel: TUniToolButton;
    UniToolButton4: TUniToolButton;
    BtnRefresh: TUniToolButton;
    BtnPrint: TUniToolButton;
    BtnPreview: TUniToolButton;
    BtnExport: TUniToolButton;
    UniToolButton10: TUniToolButton;
    UniToolButton11: TUniToolButton;
    BtnExit: TUniToolButton;
    PanelQuick: TUniSimplePanel;
    DBGridMain: TUniDBGrid;
    ClientDS: TClientDataSet;
    DataSource1: TDataSource;
    SplitterTop: TUniSplitter;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    FMenuID: string;
    FPopedom: string;
    {*Ȩ����*}
    FWhere: string;
    {*��������*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
    procedure OnLoadPopedom; virtual;
    {*���ຯ��*}
    function FilterColumnField: string; virtual;
    procedure OnLoadGridConfig(const nIni: TIniFile); virtual;
    procedure OnSaveGridConfig(const nIni: TIniFile); virtual;
    {*�������*}
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); virtual;
    procedure InitFormData(const nWhere: string = '';
     const nQuery: TADOQuery = nil); virtual;
    function InitFormDataSQL(const nWhere: string): string; virtual;
    procedure AfterInitFormData; virtual;
    {*��������*}
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  ULibFun, USysBusiness, USysConst, USysDB;

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FMenuID := GetMenuByModule(ClassName);
  FPopedom := GetPopedom(FMenuID);

  OnLoadPopedom;
  //����Ȩ��

  nIni := nil;
  try
    nIni := UserConfigFile;
    PanelQuick.Height := nIni.ReadInteger(ClassName, 'PanelQuick', 50);

    OnLoadGridConfig(nIni);
    //�����û�����
    OnCreateFrame(nIni);
    //���ദ��
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := UserConfigFile;
    nIni.WriteInteger(ClassName, 'PanelQuick', PanelQuick.Height);

    OnSaveGridConfig(nIni);
    //�����û�����
    OnDestroyFrame(nIni);
    //���ദ��
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.OnCreateFrame(const nIni: TIniFile);
begin

end;

procedure TfFrameBase.OnDestroyFrame(const nIni: TIniFile);
begin

end;

//Desc: ��ȡȨ��
procedure TfFrameBase.OnLoadPopedom;
var nIni: TIniFile;
begin
  BtnAdd.Enabled      := HasPopedom2(sPopedom_Add, FPopedom);
  BtnEdit.Enabled     := HasPopedom2(sPopedom_Edit, FPopedom);
  BtnDel.Enabled      := HasPopedom2(sPopedom_Delete, FPopedom);
  BtnPrint.Enabled    := HasPopedom2(sPopedom_Print, FPopedom);
  BtnPreview.Enabled  := HasPopedom2(sPopedom_Preview, FPopedom);
  BtnExport.Enabled   := HasPopedom2(sPopedom_Export, FPopedom);

  BuildDBGridColumn(FMenuID, DBGridMain, FilterColumnField());
  //������ͷ
end;

procedure TfFrameBase.OnLoadGridConfig(const nIni: TIniFile);
begin

end;

procedure TfFrameBase.OnSaveGridConfig(const nIni: TIniFile);
begin

end;

//Desc: ���˲���ʾ
function TfFrameBase.FilterColumnField: string;
begin
  Result := '';
end;

procedure TfFrameBase.InitFormData(const nWhere: string;
  const nQuery: TADOQuery);
begin

end;

function TfFrameBase.InitFormDataSQL(const nWhere: string): string;
begin

end;

procedure TfFrameBase.AfterInitFormData;
begin

end;

procedure TfFrameBase.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
begin

end;

end.
