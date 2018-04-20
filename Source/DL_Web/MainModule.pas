{*******************************************************************************
  ����: dmzn@163.com 2018-04-20
  ����: �û�ȫ����ģ��
*******************************************************************************}
unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, uniGUIBaseClasses, uniGUIClasses,
  uniImageList, USysConst, Data.DB, Data.Win.ADODB, System.SyncObjs;

type
  TUniMainModule = class(TUniGUIMainModule)
    ImageListSmall: TUniImageList;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FSyncLock: TCriticalSection;
    //ͬ������
  public
    { Public declarations }
    FUserConfig: TSysParam;
    //ϵͳ����
    procedure SyncLock;
    procedure SyncUnlock;
    //ͬ������
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  FSyncLock := TCriticalSection.Create;
  FUserConfig := gSysParam;
  //����ȫ�ֲ���

  with gUserList.LockList do
  try
    Add(@FUserConfig);
  finally
    gUserList.UnlockList;
  end;
end;

procedure TUniMainModule.UniGUIMainModuleDestroy(Sender: TObject);
var nIdx: Integer;
begin
  FSyncLock.Free;
  //xxxxx

  with gUserList.LockList do
  try
    nIdx := IndexOf(@FUserConfig);
    if nIdx >= 0 then
      Delete(nIdx);
    //xxxxx
  finally
    gUserList.UnlockList;
  end;
end;

procedure TUniMainModule.SyncLock;
begin
  FSyncLock.Enter;
end;

procedure TUniMainModule.SyncUnlock;
begin
  FSyncLock.Leave;
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
