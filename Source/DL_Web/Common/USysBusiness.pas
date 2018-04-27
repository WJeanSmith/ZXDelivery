{*******************************************************************************
  ����: dmzn@163.com 2018-04-23
  ����: ҵ���嵥Ԫ
*******************************************************************************}
unit USysBusiness;

interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  Data.DB, Data.Win.ADODB, System.SyncObjs,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniGUISessionManager, uniGUIApplication, uniTreeView, uniGUIForm, uniDBGrid,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, ULibFun, USysDB, USysConst, USysFun;

procedure RegObjectPoolTypes;
//ע�Ỻ��ض���
procedure GlobalSyncLock;
procedure GlobalSyncRelease;
//ȫ��ͬ������

function SystemGetForm(const nClass: string): TUniForm;
//���������ƻ�ȡ�������
function UserConfigFile: TIniFile;
//�û��Զ��������ļ�

function LockDBConn(const nType: TAdoConnectionType = ctMain): TADOConnection;
procedure ReleaseDBconn(const nConn: TADOConnection);
function LockDBQuery(const nType: TAdoConnectionType = ctMain): TADOQuery;
procedure ReleaseDBQuery(const nQuery: TADOQuery);
//���ݿ���·
function DBQuery(const nStr: string; const nQuery: TADOQuery): TDataSet;
function DBExecute(const nStr: string; const nCmd: TADOQuery = nil;
  const nType: TAdoConnectionType = ctMain): Integer;
//���ݿ����

function ParseCardNO(const nCard: string; const nHex: Boolean): string;
//��ʽ���ſ����
procedure LoadSystemMemoryStatus(const nList: TStrings; const nFriend: Boolean);
//����ϵͳ�ڴ�״̬
procedure ReloadSystemMemory(const nResetAllSession: Boolean);
//���¼���ϵͳ��������

procedure LoadMenuItems(const nForce: Boolean);
//����˵�����
procedure BuidMenuTree(const nTree: TUniTreeView; nEntity: string = '');
//�����˵���
function GetMenuItemID(const nIdx: Integer): string;
//��ȡָ���˵���ʶ
function GetMenuByModule(const nModule: string): string;
function GetModuleByMenu(const nMenu: string): string;
//�˵���ģ�黥��

procedure LoadFactoryList(const nForce: Boolean);
//���빤���б�
procedure GetFactoryList(const nList: TStrings);
function GetFactory(const nIdx: Integer; var nFactory: TFactoryItem): Boolean;
//���������б�

procedure LoadPopedomList(const nForce: Boolean);
//����Ȩ���б�
function GetPopedom(const nMenu: string): string;
function HasPopedom(const nMenu,nPopedom: string): Boolean;
function HasPopedom2(const nPopedom,nAll: string): Boolean;
//�Ƿ���ָ��Ȩ��

procedure LoadEntityList(const nForce: Boolean);
//���������ֵ��б�
procedure BuildDBGridColumn(const nEntity: string; const nGrid: TUniDBGrid;
  const nFilter: string = '');
//���������

implementation

uses
  MainModule, ServerModule;

var
  gSyncLock: TCriticalSection;
  //ȫ����ͬ������

//------------------------------------------------------------------------------
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
    else nStr := gAllFactorys[UniMainModule.FUserConfig.FFactory].FDBWorkOn;

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
procedure ReleaseDBconn(const nConn: TADOConnection);
begin
  if Assigned(nConn) then
  begin
    gMG.FObjectPool.Release(nConn);
  end;
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
    else nStr := gAllFactorys[UniMainModule.FUserConfig.FFactory].FDBWorkOn;

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
procedure ReleaseDBQuery(const nQuery: TADOQuery);
begin
  if Assigned(nQuery) then
  begin
    gMG.FObjectPool.Release(nQuery.Connection);
    gMG.FObjectPool.Release(nQuery);
  end;
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
//Parm: SQL;��������;��������
//Desc: ��nCmd��ִ��д�����
function DBExecute(const nStr: string; const nCmd: TADOQuery;
  const nType: TAdoConnectionType): Integer;
var nC: TADOQuery;
begin
  nC := nil;
  try
    if Assigned(nCmd) then
         nC := nCmd
    else nC := LockDBQuery(nType);

    with nC do
    begin
      Close;
      SQL.Text := nStr;
      Result := ExecSQL;
    end;
  finally
    if not Assigned(nCmd) then
      ReleaseDBQuery(nC);
    //xxxxx
  end;
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

//Date: 2018-04-23
//Desc: ȫ��ͬ������
procedure GlobalSyncLock;
begin
  gSyncLock.Enter;
end;

//Date: 2018-04-23
//Desc: ȫ��ͬ�������Ӵ�
procedure GlobalSyncRelease;
begin
  gSyncLock.Leave;
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

//Date: 2018-04-24
//Parm: �б�;�Ѻø�ʽ
//Desc: ���ڴ�״̬���ݼ��ص��б���
procedure LoadSystemMemoryStatus(const nList: TStrings; const nFriend: Boolean);
begin
  GlobalSyncLock;
  try
    nList.BeginUpdate;
    nList.Clear;

    with TObjectStatusHelper do
    begin
      AddTitle(nList, 'System Buffer');
      nList.Add(FixData('All Users:', gAllUsers.Count));
      nList.Add(FixData('All Menus:', Length(gAllMenus)));
      nList.Add(FixData('All Popedoms:', Length(gAllPopedoms)));
      nList.Add(FixData('All Entitys:', Length(gAllEntitys)));
      nList.Add(FixData('All Factorys:', Length(gAllFactorys)));
    end;

    gMG.FObjectPool.GetStatus(nList, nFriend);
    gMG.FObjectManager.GetStatus(nList, nFriend);
  finally
    GlobalSyncRelease;
    nList.EndUpdate;
  end;
end;

//Date: 2018-04-24
//Parm: �Ͽ�ȫ���Ự
//Desc: ���ػ���,�Ͽ�ȫ������
procedure ReloadSystemMemory(const nResetAllSession: Boolean);
var nStr: string;
    nIdx: Integer;
    nList: TUniGUISessions;
begin
  if nResetAllSession then
  begin
    nList := UniServerModule.SessionManager.Sessions;
    try
      nList.Lock;
      for nIdx := nList.SessionList.Count-1 downto 0 do
      begin
        nStr := '����Ա����ϵͳ,�����µ�¼';
        TUniGUISession(nList.SessionList[nIdx]).Terminate(nStr);
      end;
    finally
      nList.Unlock;
    end;
  end;

  GlobalSyncLock;
  try
    LoadFactoryList(True);
    //���빤���б�
    LoadPopedomList(True);
    //����Ȩ���б�
    LoadMenuItems(True);
    //����˵���
    LoadEntityList(True);
    //���������ֵ�
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-24
//Parm: ��������
//Desc: ��ȡnClass��Ķ���
function SystemGetForm(const nClass: string): TUniForm;
var nCls: TClass;
begin
  nCls := GetClass(nClass);
  if Assigned(nCls) then
       Result := TUniForm(UniMainModule.GetFormInstance(nCls))
  else Result := nil;
end;

//Date: 2018-04-26
//Desc: �û��Զ�������
function UserConfigFile: TIniFile;
var nStr,nFile: string;
    nIdx: Integer;
begin
  nStr := gPath + 'users\';
  if not DirectoryExists(nStr) then
    ForceDirectories(nStr);
  //new folder

  with TEncodeHelper,UniMainModule do
    nFile := EncodeBase64(FUserConfig.FUserID);
  //encode

  for nIdx := 1 to Length(nFile) do
   if nFile[nIdx] in ['a'..'z', 'A'..'Z','0'..'9'] then
    nStr := nStr + nFile[nIdx];
  //number & charactor

  Result := TIniFile.Create(nStr + '.ini');
  if not FileExists(nStr) then
  begin
    Result.WriteString('Config', 'User', UniMainModule.FUserConfig.FUserID);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-23
//Parm: ǿ�Ƽ���
//Desc: ��ȡ���ݿ�˵���
procedure LoadMenuItems(const nForce: Boolean);
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllMenus);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s ' +
         'Where M_ProgID=''%s'' And M_NewOrder>=0 And M_Title<>''-'' ' +
         'Order By M_NewOrder ASC';
    nStr := Format(nStr, [sTable_Menu, gSysParam.FProgID]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllMenus, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllMenus[nIdx] do
        begin
          FEntity    := FieldByName('M_Entity').AsString;
          FMenuID    := FieldByName('M_MenuID').AsString;
          FPMenu     := FieldByName('M_PMenu').AsString;
          FTitle     := FieldByName('M_Title').AsString;
          FImgIndex  := FieldByName('M_ImgIndex').AsInteger;
          FFlag      := FieldByName('M_Flag').AsString;
          FAction    := FieldByName('M_Action').AsString;
          FFilter    := FieldByName('M_Filter').AsString;
          FNewOrder  := FieldByName('M_NewOrder').AsFloat;
          FLangID    := 'cn';
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-23
//Parm: �б���;ʵ������
//Desc: �����˵��б�nTree
procedure BuidMenuTree(const nTree: TUniTreeView; nEntity: string);
var nIdx,nInt: Integer;
    nGroup: Integer;
    nItem: TuniTreeNode;

  //Desc: �����nItem�Ƿ��пɶ�Ȩ��
  function HasPopedom(const nMItem: string): Boolean;
  var i: Integer;
  begin
    Result := UniMainModule.FUserConfig.FIsAdmin;
    if Result then Exit;
    
    with gAllPopedoms[nGroup] do
    begin
      for i := Low(FPopedom) to High(FPopedom) do
      if CompareText(nMItem, FPopedom[i].FItem) = 0 then
      begin 
        Result := Pos(sPopedom_Read, FPopedom[i].FPopedom) > 0;
        Exit;
      end;
    end;
  end;

  //Desc: �����ӽڵ�
  procedure MakeChileMenu(const nParent: TuniTreeNode);
  var i,nTag: Integer;
      nSub: TuniTreeNode;
  begin
    for i := 0 to nInt do
    with gAllMenus[i] do
    begin
      if CompareText(FEntity, nEntity) <> 0 then Continue;
      //not match entity

      nTag := Integer(nParent.Data);
      if CompareText(FPMenu, gAllMenus[nTag].FMenuID) <> 0 then Continue;
      //not sub item

      if not HasPopedom(MakeMenuID(FEntity, FMenuID)) then Continue;
      //no popedom

      nSub := nTree.Items.AddChild(nParent, FTitle);
      nSub.Data := Pointer(i);
      MakeChileMenu(nSub);
    end;
  end;
begin
  if nEntity='' then
    nEntity := 'MAIN';
  //main menu

  GlobalSyncLock;
  try
    nTree.Items.BeginUpdate;
    nTree.Items.Clear;
    nGroup := -1;

    for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
    if gAllPopedoms[nIdx].FID = UniMainModule.FUserConfig.FGroupID then
    begin
      nGroup := nIdx;
      Break;
    end;

    if nGroup < 0 then
    begin
      nTree.Items.AddChild(nil, 'Ȩ�޲���');
      Exit;
    end;

    nInt := Length(gAllMenus)-1;
    for nIdx := 0 to nInt do
    with gAllMenus[nIdx] do
    begin
      if CompareText(FEntity, nEntity) <> 0 then Continue;
      //not match entity
      if (FMenuID = '') or (FPMenu <> '') then Continue;
      //not root item
      if not HasPopedom(MakeMenuID(FEntity, FMenuID)) then Continue;
      //no popedom

      nItem := nTree.Items.AddChild(nil, FTitle);
      nItem.Data := Pointer(nIdx);
    end;

    nItem := nTree.Items.GetFirstNode;
    while Assigned(nItem) do
    begin
      MakeChileMenu(nItem);
      nItem := nItem.GetNextSibling;
    end;
  finally
    GlobalSyncRelease;
    nTree.Items.EndUpdate;
  end;
end;

//Date: 2018-04-24
//Parm: �˵�������
//Desc: ��ȡnIdx�Ĳ˵���ʶ
function GetMenuItemID(const nIdx: Integer): string;
begin
  GlobalSyncLock;
  try
    Result := '';
    if (nIdx >= Low(gAllMenus)) and (nIdx <= High(gAllMenus)) then
     with gAllMenus[nIdx] do
      Result := MakeMenuID(FEntity, FMenuID);
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-26
//Parm: ģ������
//Desc: ����ģ��ΪnModule�Ĳ˵���
function GetMenuByModule(const nModule: string): string;
var nIdx: Integer;
begin
  with UniMainModule do
  begin
    Result := '';
    //init

    for nIdx := Low(FMenuModule) to High(FMenuModule) do
    with FMenuModule[nIdx] do
    begin
      if CompareText(nModule, FModule) = 0 then
      begin
        Result := FMenuID;
        Exit;
      end;
    end;
  end;
end;

//Date: 2018-04-26
//Parm: �˵���
//Desc: �����˵���ΪnMenu��ģ��
function GetModuleByMenu(const nMenu: string): string;
var nIdx: Integer;
begin
  with UniMainModule do
  begin
    Result := '';
    //init

    for nIdx := Low(FMenuModule) to High(FMenuModule) do
    with FMenuModule[nIdx] do
    begin
      if CompareText(nMenu, FModule) = 0 then
      begin
        Result := FModule;
        Exit;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-24
//Parm: ǿ�Ƹ���
//Desc: ���ع����б��ڴ�
procedure LoadFactoryList(const nForce: Boolean);
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllFactorys);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s Where F_Valid=''%s'' Order By F_Index ASC';
    nStr := Format(nStr, [sTable_Factorys, sFlag_Yes]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllFactorys, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllFactorys[nIdx] do
        begin
          FFactoryID  := FieldByName('F_ID').AsString;
          FFactoryName:= FieldByName('F_Name').AsString;
          FMITServURL := FieldByName('F_MITUrl').AsString;
          FHardMonURL := FieldByName('F_HardUrl').AsString;
          FWechatURL  := FieldByName('F_WechatUrl').AsString;
          FDBWorkOn   := FieldByName('F_DBConn').AsString;
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-24
//Parm: �б�
//Desc: ���ع����б�nList��
procedure GetFactoryList(const nList: TStrings);
var nIdx: Integer;
begin
  GlobalSyncLock;
  try
    nList.BeginUpdate;
    nList.Clear;

    for nIdx := Low(gAllFactorys) to High(gAllFactorys) do
     with gAllFactorys[nIdx] do
      nList.AddObject(FFactoryID + '.' + FFactoryName, Pointer(nIdx));
    //xxxxx
  finally
    GlobalSyncRelease;
    nList.EndUpdate;
  end;
end;

//Date: 2018-04-24
//Parm: ����;��������
//Desc: ��ȡnIdx�����ݵ�nFactory
function GetFactory(const nIdx: Integer; var nFactory: TFactoryItem): Boolean;
begin
  GlobalSyncLock;
  try
    Result := (nIdx >= Low(gAllFactorys)) and (nIdx <= High(gAllFactorys));
    if Result then
      nFactory := gAllFactorys[nIdx];
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-24
//Parm: ǿ�Ƽ���
//Desc: ����Ȩ�޵��ڴ�
procedure LoadPopedomList(const nForce: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllPopedoms);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query
    nStr := 'Select * From ' + sTable_Group;

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllPopedoms, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllPopedoms[nIdx] do
        begin
          FID       := FieldByName('G_ID').AsString;
          FName     := FieldByName('G_NAME').AsString;
          FDesc     := FieldByName('G_DESC').AsString;
          SetLength(FPopedom, 0);
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From ' + sTable_Popedom;
    //Ȩ�ޱ�

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
      with gAllPopedoms[nIdx] do
      begin
        nInt := 0;
        First;

        while not Eof do
        begin
          if FieldByName('P_Group').AsString = FID then
            Inc(nInt);
          Next;
        end;

        SetLength(FPopedom, nInt);
        nInt := 0;
        First;

        while not Eof do
        begin
          if FieldByName('P_Group').AsString = FID then
          begin
            with FPopedom[nInt] do
            begin
              FItem := FieldByName('P_Item').AsString;
              FPopedom := FieldByName('P_Popedom').AsString;
            end;

            Inc(nInt);
          end;

          Next;
        end;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-26
//Parm: �˵���
//Desc: ��ȡ��ǰ�û���nMenu��ӵ�е�Ȩ��
function GetPopedom(const nMenu: string): string;
var nIdx,nGroup: Integer;
begin
  with UniMainModule do
  try
    GlobalSyncLock;
    Result := '';
    nGroup := -1;

    for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
    if gAllPopedoms[nIdx].FID = FUserConfig.FGroupID then
    begin
      nGroup := nIdx;
      Break;
    end;

    if nGroup < 0 then Exit;
    //no group match

    with gAllPopedoms[nGroup] do
    begin
      for nIdx := Low(FPopedom) to High(FPopedom) do
      if CompareText(nMenu, FPopedom[nIdx].FItem) = 0 then
      begin
        Result := FPopedom[nIdx].FPopedom;
        Exit;
      end;
    end;
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-26
//Parm: �˵���;Ȩ����
//Desc: �жϵ�ǰ�û���nMenu�Ƿ���nPopedomȨ��
function HasPopedom(const nMenu,nPopedom: string): Boolean;
begin
  with UniMainModule do
  begin
    Result := FUserConfig.FIsAdmin or (Pos(nPopedom, GetPopedom(nMenu)) > 0);
  end;
end;

//Date: 2018-04-26
//Parm: Ȩ����;Ȩ����
//Desc: ���nAll���Ƿ���nPopedomȨ����
function HasPopedom2(const nPopedom,nAll: string): Boolean;
begin
  with UniMainModule do
  begin
    Result := FUserConfig.FIsAdmin or (Pos(nPopedom, nAll) > 0);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-26
//Parm: ǿ��ˢ��
//Desc: ���������ֵ�
procedure LoadEntityList(const nForce: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllEntitys);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s Where E_ProgID=''%s''';
    nStr := Format(nStr, [sTable_Entity, gSysParam.FProgID]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllEntitys, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllEntitys[nIdx] do
        begin
          FEntity := FieldByName('E_Entity').AsString;
          FTitle  := FieldByName('E_Title').AsString;
          SetLength(FDictItem, 0);
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s Order By D_Index ASC';
    nStr := Format(nStr, ['Sys_DataDict']);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      for nIdx := Low(gAllEntitys) to High(gAllEntitys) do
      with gAllEntitys[nIdx] do
      begin
        nStr := gSysParam.FProgID + '_' + FEntity;
        nInt := 0;
        First;

        while not Eof do
        begin
          if CompareText(nStr, FieldByName('D_Entity').AsString) = 0 then
            Inc(nInt);
          Next;
        end;

        if nInt < 1 then Continue;
        //no entity detail

        SetLength(FDictItem, nInt);
        nInt := 0;
        First;

        while not Eof  do
        begin
          if CompareText(nStr, FieldByName('D_Entity').AsString) = 0 then
          with FDictItem[nInt] do
          begin
            FItemID  := FieldByName('D_ItemID').AsInteger;
            FTitle   := FieldByName('D_Title').AsString;
            FAlign   := TAlignment(FieldByName('D_Align').AsInteger);
            FWidth   := FieldByName('D_Width').AsInteger;
            FIndex   := FieldByName('D_Index').AsInteger;
            FVisible := StrToBool(FieldByName('D_Visible').AsString);
            FLangID  := FieldByName('D_LangID').AsString;

            with FDBItem do
            begin
              FTable := FieldByName('D_DBTable').AsString;
              FField := FieldByName('D_DBField').AsString;
              FIsKey := StrToBool(FieldByName('D_DBIsKey').AsString);

              FType  := TFieldType(FieldByName('D_DBType').AsInteger);
              FWidth := FieldByName('D_DBWidth').AsInteger;
              FDecimal:= FieldByName('D_DBDecimal').AsInteger;
            end;

            with FFormat do
            begin
              FStyle  := TDictFormatStyle(FieldByName('D_FmtStyle').AsInteger);
              FData   := FieldByName('D_FmtData').AsString;
              FFormat := FieldByName('D_FmtFormat').AsString;
              FExtMemo:= FieldByName('D_FmtExtMemo').AsString;
            end;

            with FFooter do
            begin
              FDisplay := FieldByName('D_FteDisplay').AsString;
              FFormat := FieldByName('D_FteFormat').AsString;
              FKind := TDictFooterKind(FieldByName('D_FteKind').AsInteger);
              FPosition := TDictFooterPosition(FieldByName('D_FtePositon').AsInteger);
            end;

            Inc(nInt);
          end;

          Next;
        end;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-26
//Parm: ʵ������;�б�;�ų��ֶ�
//Desc: ʹ�������ֵ�nEntity����nGrid�ı�ͷ
procedure BuildDBGridColumn(const nEntity: string; const nGrid: TUniDBGrid;
 const nFilter: string);
var i,nIdx: Integer;
    nList: TStrings;
begin
  with nGrid do
  begin
    BorderStyle := ubsDefault;
    LoadMask.Message := '��������';

    Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowSelect,
                dgRowSelect];
    //ѡ�����

    ReadOnly := True;
  end;

  nList := nil;
  try
    GlobalSyncLock;
    nGrid.Columns.BeginUpdate;
    nIdx := -1;
    //init

    for i := Low(gAllEntitys) to High(gAllEntitys) do
    if CompareText(nEntity, gAllEntitys[i].FEntity) = 0 then
    begin
      nIdx := i;
      Break;
    end;

    if nIdx < 0 then Exit;
    //no entity match

    if nFilter <> '' then
    begin
      nList := TStringList.Create;
      TStringHelper.Split(nFilter, nList, 0, ';');
    end;

    with gAllEntitys[nIdx],nGrid do
    begin
      Columns.Clear;
      //clear first

      for i := Low(FDictItem) to High(FDictItem) do
      with FDictItem[i] do
      begin
        if not FVisible then Continue;

        if Assigned(nList) and (nList.IndexOf(FDBItem.FField) >= 0) then
          Continue;
        //�ֶα�����,������ʾ

        with Columns.Add do
        begin
          Alignment := FAlign;
          FieldName := FDBItem.FField;

          Title.Alignment := FAlign;
          Title.Caption := FTitle;
          Width := FWidth;
        end;
      end;
    end;
  finally
    GlobalSyncRelease;
    nList.Free;
    nGrid.Columns.EndUpdate;
  end;
end;

initialization
  gSyncLock := TCriticalSection.Create;
finalization
  FreeAndNil(gSyncLock);
end.


