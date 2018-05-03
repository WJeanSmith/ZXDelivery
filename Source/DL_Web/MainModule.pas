{*******************************************************************************
  ����: dmzn@163.com 2018-04-20
  ����: �û�ȫ����ģ��
*******************************************************************************}
unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, uniGUIBaseClasses, uniGUIClasses,
  uniImageList, uniGUIForm, System.SyncObjs, USysConst;

type
  TUniMainModule = class(TUniGUIMainModule)
    ImageListSmall: TUniNativeImageList;
    ImageListBar: TUniNativeImageList;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
    procedure UniGUIMainModuleBeforeLogin(Sender: TObject;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    FMainForm: TUniForm;
    //������
    FUserConfig: TSysParam;
    //ϵͳ����
    FMenuModule: TMenuModuleItems;
    //�˵�ģ��
  end;

function UniMainModule: TUniMainModule;
//��ں���

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, USysBusiness;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
var nIdx: Integer;
begin
  FUserConfig := gSysParam;
  //����ȫ�ֲ���
  with FUserConfig,UniSession do
  begin
    FLocalIP   := RemoteIP;
    FLocalName := RemoteHost;
    FUserAgent := UserAgent;
    FOSUser    := SystemUser;
  end;

  GlobalSyncLock;
  try
    //for nIdx := gAllUsers.Count-1 downto 0 do
    // if PSysParam(gAllUsers[nIdx]).FLocalIP = FUserConfig.FLocalIP then
    //  FUserConfig := PSysParam(gAllUsers[nIdx])^;
    //restore

    gAllUsers.Add(@FUserConfig);
  finally
    GlobalSyncRelease;
  end;

  SetLength(FMenuModule, gMenuModule.Count);
  for nIdx := 0 to gMenuModule.Count-1 do
    FMenuModule[nIdx] := PMenuModuleItem(gMenuModule[nIdx])^;
  //׼���˵�ģ��ӳ��
end;

procedure TUniMainModule.UniGUIMainModuleDestroy(Sender: TObject);
var nIdx: Integer;
begin
  GlobalSyncLock;
  try
    nIdx := gAllUsers.IndexOf(@FUserConfig);
    if nIdx >= 0 then
      gAllUsers.Delete(nIdx);
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

procedure TUniMainModule.UniGUIMainModuleBeforeLogin(Sender: TObject;
  var Handled: Boolean);
begin
  Handled := FUserConfig.FUserID <> '';
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
