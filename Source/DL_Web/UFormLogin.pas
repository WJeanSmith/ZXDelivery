{*******************************************************************************
  ����: dmzn@163.com 2018-04-20
  ����: ��¼
*******************************************************************************}
unit UFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniImage,
  uniButton, uniEdit, uniLabel, uniPanel;

type
  TfFormLogin = class(TUniLoginForm)
    ImageLogo: TUniImage;
    UniSimplePanel1: TUniSimplePanel;
    UniLabel1: TUniLabel;
    EditUser: TUniEdit;
    UniLabel2: TUniLabel;
    EditPwd: TUniEdit;
    BtnOK: TUniButton;
    BtnExit: TUniButton;
    procedure UniLoginFormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormLogin: TfFormLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, Data.Win.ADODB,
  USysFun, USysConst, USysDB;

function fFormLogin: TfFormLogin;
begin
  Result := TfFormLogin(UniMainModule.GetFormInstance(TfFormLogin));
end;

procedure TfFormLogin.UniLoginFormCreate(Sender: TObject);
begin
  ImageLogo.Url := sImageDir + 'logo.bmp';
end;

//Desc: ��¼
procedure TfFormLogin.BtnOKClick(Sender: TObject);
var nStr: string;
    nQuery: TADOQuery;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then
  begin
    ShowMessage('�������û���');
    Exit;
  end;

  nQuery := nil;
  with ULibFun.TStringHelper do
  try
    nStr := 'Select U_NAME,U_PASSWORD,U_GROUP,U_Identity from $a ' +
            'Where U_NAME=''$b'' and U_State=1';

    nStr := MacroValue(nStr, [MI('$a',sTable_User),
                              MI('$b',EditUser.Text)]);
    //xxxxx

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);

    if (nQuery.RecordCount <> 1) or
       (nQuery.FieldByName('U_PASSWORD').AsString <> EditPwd.Text) then
    begin
      ShowMessage('������û���������,����������');
      Exit;
    end;

    with UniMainModule.FUserConfig do
    begin
      FUserID := EditUser.Text;
      FUserName := nQuery.FieldByName('U_PASSWORD').AsString;
      FUserPwd := EditPwd.Text;
      FGroupID := nQuery.FieldByName('U_GROUP').AsString;
      FIsAdmin := nQuery.FieldByName('U_Identity').AsString = '0';
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);

    with DBQuery(nStr, nQuery),UniMainModule.FUserConfig do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nStr := Fields[1].AsString;
        if nStr = sFlag_WXServiceMIT then
          FWechatURL := Fields[0].AsString;
        //xxxxx
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    if gSysParam.FMITServURL = '' then  //ʹ��Ĭ��URL
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_MITSrvURL]);

      with DBQuery(nStr, nQuery),UniMainModule.FUserConfig do
       if RecordCount > 0 then
        FMITServURL := Fields[0].AsString;
      //xxxxx
    end;

    if gSysParam.FHardMonURL = '' then //����ϵͳĬ��Ӳ���ػ�
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_HardSrvURL]);

      with DBQuery(nStr, nQuery),UniMainModule.FUserConfig do
       if RecordCount > 0 then
        FHardMonURL := Fields[0].AsString;
      //xxxxx
    end;

    ModalResult := mrOk;
  finally
    RelaseDBQuery(nQuery);
  end;
end;

initialization
  RegisterAppFormClass(TfFormLogin);

end.