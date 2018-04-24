{*******************************************************************************
  ����: dmzn@ylsoft.com 2018-03-15
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��

type
  TAdoConnectionType = (ctMain, ctWork);
  //��������

  TFactoryItem = record
    FFactoryID  : string;                            //�������
    FFactoryName: string;                            //��������
    FMITServURL : string;                            //ҵ�����
    FHardMonURL : string;                            //Ӳ���ػ�
    FWechatURL  : string;                            //΢�ŷ���
    FDBWorkOn   : string;                            //�������ݿ�
  end;

  TFactoryItems = array of TFactoryItem;
  //�����б�

  PSysParam = ^TSysParam;
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������
    FOSUser     : string;                            //����ϵͳ
    FUserAgent  : string;                            //���������
    FFactory    : Integer;                           //������������
  end;
  //ϵͳ����

  TServerParam = record
    FPort       : Integer;                           //����˿�
    FExtJS      : string;                            //ext�ű�Ŀ¼
    FUniJS      : string;                            //uni�ű�Ŀ¼
    FDBMain     : string;                            //�����ݿ�����
  end;

  PMenuItemData = ^TMenuItemData;
  TMenuItemData = record
    FProgID: string;                                 //�����ʶ
    FEntity: string;                                 //ʵ���ʶ
    FMenuID: string;                                 //�˵���ʶ
    FPMenu: string;                                  //�ϼ��˵�
    FTitle: string;                                  //�˵�����
    FImgIndex: integer;                              //ͼ������
    FFlag: string;                                   //���Ӳ���(�»���..)
    FAction: string;                                 //�˵�����
    FFilter: string;                                 //��������
    FNewOrder: Single;                               //��������
    FLangID: string;                                 //���Ա�ʶ
  end;

  TMenuItems = array of TMenuItemData;
  //�˵��б�

  TPopedomItemData = record
    FItem: string;                                   //����
    FPopedom: string;                                //Ȩ��
  end;
  TPopedomItems = array of TPopedomItemData;

  TPopedomGroupItem = record
    FID: string;                                     //���ʶ
    FName: string;                                   //������
    FDesc: string;                                   //������
    FUser: TStrings;                                 //�����û�
    FPopedom: TPopedomItems;                         //Ȩ���б�
  end;

  TPopedomGroupItems = array of TPopedomGroupItem;
  //Ȩ���б�

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: string;                                 //ģ������
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gServerParam: TServerParam;                        //����������

  gAllFactorys: TFactoryItems;                       //ϵͳ��Ч�����б�
  gAllPopedoms: TPopedomGroupItems;                  //Ȩ���б�

  gAllUsers: TList;                                  //�ѵ�¼�û��б�
  gAllMenus: TMenuItems;                             //ϵͳ��Ч�˵�
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������
  sCameraDir          = 'Camera\';                   //ץ��Ŀ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������
  sDBConfig_bk        = 'isbk';                      //���ݿ�

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu,nModule: string;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A05', 'TfFormChangePwd', mtForm);
  AddMenuModuleItem('MAIN_SYSCLOSE', 'TfFormExit', mtForm);
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  SetLength(gAllFactorys, 0);
  SetLength(gAllMenus, 0);
  SetLength(gAllPopedoms, 0);

  InitMenuModuleList;
  gAllUsers := TList.Create;
finalization
  FreeAndNil(gAllUsers);
  ClearMenuModuleList;
end.


