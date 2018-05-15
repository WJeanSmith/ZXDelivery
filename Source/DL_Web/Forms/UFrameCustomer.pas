{*******************************************************************************
  ����: dmzn@163.com 2018-04-25
  ����: �ͻ�����
*******************************************************************************}
unit UFrameCustomer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, UFrameBase, uniGUITypes, uniLabel, uniEdit, Data.DB,
  Datasnap.DBClient, uniGUIClasses, uniBasicGrid, uniDBGrid, uniPanel,
  uniToolBar, uniGUIBaseClasses;

type
  TfFrameCustomer = class(TfFrameBase)
    EditName: TUniEdit;
    UniLabel1: TUniLabel;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
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
  uniGUIVars, MainModule, uniGUIApplication, uniGUIForm, UFormBase,
  UManagerGroup, USysBusiness, USysDB, USysConst;

function TfFrameCustomer.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Customer;
  if nWhere <> '' then
    Result := Result + ' where ' + nWhere;
  //xxxxx
end;

procedure TfFrameCustomer.BtnAddClick(Sender: TObject);
var nForm: TUniForm;
    nParam: TFormCommandParam;
begin
  nForm := SystemGetForm('TfFormCutomer', True);
  if not Assigned(nForm) then Exit;

  nParam.FCommand := cCmd_AddData;
  (nForm as TfFormBase).SetParam(nParam);

  nForm.ShowModal(
    procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrok then
        InitFormData(FWhere);
      //refresh
    end);
  //show form
end;

procedure TfFrameCustomer.BtnEditClick(Sender: TObject);
var nForm: TUniForm;
    nParam: TFormCommandParam;
begin
  if DBGridMain.SelectedRows.Count < 1 then
  begin
    ShowMessage('��ѡ��Ҫ�޸ĵļ�¼');
    Exit;
  end;

  nForm := SystemGetForm('TfFormCutomer', True);
  if not Assigned(nForm) then Exit;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := ClientDS.FieldByName('R_ID').AsString;
  (nForm as TfFormBase).SetParam(nParam);

  nForm.ShowModal(
    procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrok then
        InitFormData(FWhere);
      //refresh
    end);
  //show form
end;

procedure TfFrameCustomer.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
    nList: TStrings;
begin
  if DBGridMain.SelectedRows.Count < 1 then
  begin
    ShowMessage('��ѡ��Ҫɾ���ļ�¼');
    Exit;
  end;

  nStr := ClientDS.FieldByName('C_Name').AsString;
  nStr := Format('ȷ��Ҫɾ������Ϊ[ %s ]�Ŀͻ���?', [nStr]);
  MessageDlg(nStr, mtConfirmation, mbYesNo,
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res <> mrYes then Exit;
      //cancel

      nList := nil;
      try
        nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
        nStr := ClientDS.FieldByName('C_ID').AsString;

        nSQL := 'Delete From %s Where C_ID=''%s''';
        nSQL := Format(nSQL, [sTable_Customer, nStr]);
        nList.Add(nSQL);

        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_CustomerItem, nStr]);
        nList.Add(nSQL);

        DBExecute(nList, nil, FDBType);
        gMG.FObjectPool.Release(nList);

        InitFormData(FWhere);
        ShowMessage('�ѳɹ�ɾ����¼');
      except
        on nErr: Exception do
        begin
          gMG.FObjectPool.Release(nList);
          ShowMessage('ɾ��ʧ��: ' + nErr.Message);
        end;
      end;
    end);
  //xxxxx
end;

procedure TfFrameCustomer.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'C_Name like ''%%%s%%'' Or C_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  RegisterClass(TfFrameCustomer);
end.
