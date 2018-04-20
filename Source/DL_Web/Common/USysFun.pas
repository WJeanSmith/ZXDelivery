{*******************************************************************************
  ����: dmzn@163.com 2007-10-09
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  UManagerGroup, ULibFun, USysConst, Registry, Data.DB, Data.Win.ADODB,
  uniStatusBar;

procedure ShowMsgOnLastPanelOfStatusBar(const nStatusBar: TUniStatusBar;
  const nMsg: string);
//��״̬����ʾ��Ϣ

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(const nIni: TIniFile = nil);
//����ϵͳ���ò���
function MakeFrameName(const nFrameID: integer): string;
//����Frame����

function ReplaceGlobalPath(const nStr: string): string;
//�滻nStr�е�ȫ��·��

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//�����б��ͷ���
function MakeListViewColumnInfo(const nLv: TListView): string;
//����б��ͷ�����Ϣ
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
//���ѡ�е��������

function ParseCardNO(const nCard: string; const nHex: Boolean): string;
//��ʽ���ſ����

procedure RegObjectPoolTypes;
//ע������
function LockDBConn(const nType: TAdoConnectionType): TADOConnection;
procedure RelaseDBconn(const nConn: TADOConnection);
function LockDBQuery(const nType: TAdoConnectionType): TADOQuery;
procedure RelaseDBQuery(const nQuery: TADOQuery);
//���ݿ���·
function DBQuery(const nStr: string; const nQuery: TADOQuery): TDataSet;
function DBExecute(const nStr: string; const nCmd: TADOQuery): Integer;
//���ݿ����

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //�����ʶ�����������в���

      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
    end;

    with gServerParam, nTmp do
    begin
      FPort := ReadInteger('Server', 'Port', 8077);
      FExtJS := ReadString('Server', 'JS_Ext', '');
      FUniJS := ReadString('Server', 'JS_Uni', '');

      FDBMain := ReadString('Database', 'Main', '');
      FDBWorkOn := ReadString('Database', 'WorkOn', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: ����FrameID���������
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: �滻nStr�е�ȫ��·��
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//------------------------------------------------------------------------------
//Desc: ��ȫ��״̬�����һ��Panel����ʾnMsg��Ϣ
procedure ShowMsgOnLastPanelOfStatusBar(const nStatusBar: TUniStatusBar;
  const nMsg: string);
begin
  if Assigned(nStatusBar) and (nStatusBar.Panels.Count > 0) then
  begin
    nStatusBar.Panels[nStatusBar.Panels.Count - 1].Text := nMsg;
    //Application.ProcessMessages;
  end;
end;

//Date: 2007-11-30
//Parm: �����Ϣ;�б�
//Desc: ����nList�ı�ͷ���
procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
var nList: TStrings;
    i,nCount: integer;
begin
  if nLv.Columns.Count > 0 then
  begin
    nList := TStringList.Create;
    try
      if TStringHelper.Split(nWidths, nList, nLv.Columns.Count, ';') then
      begin
        nCount := nList.Count - 1;
        for i:=0 to nCount do
         if TStringHelper.IsNumber(nList[i], False) then
          nLv.Columns[i].Width := StrToInt(nList[i]);
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2007-11-30
//Parm: �б�
//Desc: ���nLv�ı�ͷ�����Ϣ
function MakeListViewColumnInfo(const nLv: TListView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nLv.Columns.Count - 1;

  for i:=0 to nCount do
  if i = nCount then
       Result := Result + IntToStr(nLv.Columns[i].Width)
  else Result := Result + IntToStr(nLv.Columns[i].Width) + ';';
end;

//Date: 2007-11-30
//Parm: �б�;�б�;�Ƿ�ȫ�����
//Desc: ���nLv�е���Ϣ,��䵽nList��
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
var i,nCount: integer;
begin
  nList.Clear;
  nCount := nLv.Items.Count - 1;

  for i:=0 to nCount do
  if nAll or nLv.Items[i].Selected then
  begin
    nList.Add(nLv.Items[i].Caption + sLogField +
      TStringHelper.Combine(nLv.Items[i].SubItems, sLogField));
    //combine items's data
  end;
end;

//Date: 2012-4-22
//Parm: 16λ��������
//Desc: ��ʽ��nCardΪ��׼����
function ParseCardNO(const nCard: string; const nHex: Boolean): string;
var nInt: Int64;
    nIdx: Integer;
begin
  if nHex then
  begin
    Result := '';
    for nIdx:=1 to Length(nCard) do
      Result := Result + IntToHex(Ord(nCard[nIdx]), 2);
    //xxxxx
  end else Result := nCard;

  nInt := StrToInt64('$' + Result);
  Result := IntToStr(nInt);
  Result := StringOfChar('0', 12 - Length(Result)) + Result;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-20
//Desc: ע������
procedure RegObjectPoolTypes;
begin
  with gMG.FObjectPool do
  begin
    NewClass(TADOConnection,
      function():TObject begin Result := TADOConnection.Create(nil); end);
    //ado conn

    NewClass(TADOQuery,
      function():TObject begin Result := TADOQuery.Create(nil); end);
    //ado query
  end;
end;

//Date: 2018-04-20
//Parm: ��������
//Desc: ��ȡ���ݿ���·
function LockDBConn(const nType: TAdoConnectionType): TADOConnection;
var nStr: string;
begin
  Result := gMG.FObjectPool.Lock(TADOConnection) as TADOConnection;
  with Result do
  begin
    if nType = ctMain then
         nStr := gServerParam.FDBMain
    else nStr := gServerParam.FDBWorkOn;

    if Result.ConnectionString <> nStr then
    begin
      Connected := False;
      ConnectionString := nStr;
      LoginPrompt := False;
    end;
  end;
end;

//Date: 2018-04-20
//Parm: ���Ӷ���
//Desc: �ͷ���·
procedure RelaseDBconn(const nConn: TADOConnection);
begin
  gMG.FObjectPool.Release(nConn);
end;

//Date: 2018-04-20
//Parm: ��������
//Desc: ��ȡ��ѯ����
function LockDBQuery(const nType: TAdoConnectionType): TADOQuery;
var nStr: string;
begin
  Result := gMG.FObjectPool.Lock(TADOQuery) as TADOQuery;
  with Result do
  begin
    if nType = ctMain then
         nStr := gServerParam.FDBMain
    else nStr := gServerParam.FDBWorkOn;

    Close;
    Connection := gMG.FObjectPool.Lock(TADOConnection) as TADOConnection;

    if Connection.ConnectionString <> nStr then
    with Connection do
    begin
      Connected := False;
      ConnectionString := nStr;
      LoginPrompt := False;
    end;
  end;
end;

//Date: 2018-04-20
//Parm: ��ѯ����
//Desc: �ͷŲ�ѯ����
procedure RelaseDBQuery(const nQuery: TADOQuery);
begin
  gMG.FObjectPool.Release(nQuery.Connection);
  gMG.FObjectPool.Release(nQuery);
end;

//Date: 2018-04-20
//Parm: SQL;��ѯ����
//Desc: ��nQuery��ִ�в�ѯ
function DBQuery(const nStr: string; const nQuery: TADOQuery): TDataSet;
begin
  nQuery.Close;
  nQuery.SQL.Text := nStr;
  nQuery.Open;

  Result := nQuery;
  //result
end;

//Date: 2018-04-20
//Parm: SQL;��������
//Desc: ��nCmd��ִ��д�����
function DBExecute(const nStr: string; const nCmd: TADOQuery): Integer;
begin
  nCmd.Close;
  nCmd.SQL.Text := nStr;
  Result := nCmd.ExecSQL;
end;

end.


