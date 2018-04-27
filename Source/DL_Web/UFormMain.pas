{*******************************************************************************
  ����: dmzn@163.com 2018-03-15
  ����: ������,��������ģ��
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIRegClasses,
  uniGUIForm, uniLabel, uniMultiItem, uniComboBox, uniTreeView, uniImage,
  uniPanel, uniGUIBaseClasses, uniGUIFrame, Vcl.Menus, uniMainMenu, uniSplitter,
  uniCheckBox, uniButton, uniMemo, uniPageControl, Vcl.Controls, uniStatusBar;

type
  TfFormMain = class(TUniForm)
    StatusBar1: TUniStatusBar;
    PanelTop: TUniSimplePanel;
    ImageRight: TUniImage;
    ImageLeft: TUniImage;
    PageWork: TUniPageControl;
    SheetWelcome: TUniTabSheet;
    PanelLeft: TUniPanel;
    UniSimplePanel3: TUniSimplePanel;
    ComboFactory: TUniComboBox;
    LabelFactory: TUniLabel;
    TreeMenu: TUniTreeView;
    UniSplitter1: TUniSplitter;
    UniPanel1: TUniPanel;
    LabelHint: TUniLabel;
    SheetMemory: TUniTabSheet;
    MemoMemory: TUniMemo;
    UniSimplePanel1: TUniSimplePanel;
    BtnFresh: TUniButton;
    CheckFriendly: TUniCheckBox;
    PMenu1: TUniPopupMenu;
    N1: TUniMenuItem;
    N2: TUniMenuItem;
    N3: TUniMenuItem;
    BtnUpdateMemory: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure BtnFreshClick(Sender: TObject);
    procedure TreeMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnUpdateMemoryClick(Sender: TObject);
    procedure TreeMenuClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFormConfig;
    //��������
    procedure CallBack_UpdateMemory(Sender: TComponent; Res: Integer);
    //�Ի���ص�
    procedure TabSheetClose(Sender: TObject; var AllowClose: Boolean);
    //��ҳ�ر�
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, UManagerGroup,
  USysDB, USysFun, USysBusiness, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

//Date: 2018-04-19
//Desc: ��ʼ����������
procedure TfFormMain.LoadFormConfig;
var nStr: string;
begin
  ImageLeft.Url := sImageDir + 'top_left.bmp';
  ImageRight.Url := sImageDir + 'top_right.bmp';

  with UniMainModule.FUserConfig do
  begin
    Caption := FMainTitle;
    LabelHint.Caption := FHintText;

    nStr := '�û�:��%s�� ����:��%s�� ϵͳ:��%s�� �����:��%s��';
    nStr := Format(nStr, [FUserID, FLocalIP, FOSUser, FUserAgent]);
    StatusBar1.SimpleText := nStr;
  end;

  PageWork.ActivePage := SheetWelcome;
  SheetMemory.Visible := UniMainModule.FUserConfig.FIsAdmin;
end;

procedure TfFormMain.UniFormCreate(Sender: TObject);
begin
  LoadFormConfig;
  BuidMenuTree(TreeMenu);
  GetFactoryList(ComboFactory.Items);
end;

//Desc: ˢ���ڴ�
procedure TfFormMain.BtnFreshClick(Sender: TObject);
begin
  LoadSystemMemoryStatus(MemoMemory.Lines, CheckFriendly.Checked);
end;

//Desc: �����ڴ�
procedure TfFormMain.BtnUpdateMemoryClick(Sender: TObject);
var nStr: string;
begin
  nStr := '�����������¼�����������,���Ͽ���������.' + #13#10 +
          '�����������"��"��ť.';
  MessageDlg(nStr, mtConfirmation, mbYesNo, CallBack_UpdateMemory);
end;

procedure TfFormMain.CallBack_UpdateMemory(Sender: TComponent; Res: Integer);
begin
  if Res = mrYes then ReloadSystemMemory(True);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.TreeMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PMenu1.Popup(X, Y, TreeMenu);
end;

procedure TfFormMain.N1Click(Sender: TObject);
begin
  TreeMenu.FullExpand;
end;

procedure TfFormMain.N3Click(Sender: TObject);
begin
  TreeMenu.FullCollapse;
end;

procedure TfFormMain.TreeMenuClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nForm: TUniForm;
    nFrame: TUniFrame;
    nFrameClass: TUniFrameClass;
begin
  if (not Assigned(TreeMenu.Selected)) or
     (TreeMenu.Selected.HasChildren) then Exit;
  nIdx := NativeInt(TreeMenu.Selected.Data);

  nStr := GetMenuItemID(nIdx);
  if nStr = '' then Exit;
  //invalid menu

  for nIdx := Low(UniMainModule.FMenuModule) to High(UniMainModule.FMenuModule) do
  with UniMainModule.FMenuModule[nIdx] do
  begin
    if CompareText(FMenuID, nStr) <> 0 then Continue;
    //not match

    if FItemType = mtForm then
    begin
      nForm := SystemGetForm(FModule);
      if not Assigned(nForm) then
      begin
        nStr := '������[ %s ]��Ч.';
        ShowMessage(Format(nStr, [FModule]));
        Exit;
      end;

      nForm.ShowModalN;
      //show form
    end else

    if FItemType = mtFrame then
    begin
      if not Assigned(FTabSheet) then
      begin
        nFrameClass := TUniFrameClass(GetClass(FModule));
        if not Assigned(nFrameClass) then
        begin
          nStr := 'Frame��[ %s ]��Ч.';
          ShowMessage(Format(nStr, [FModule]));
          Exit;
        end;

        FTabSheet := TUniTabSheet.Create(Self);
        with FTabSheet do
        begin
          Pagecontrol := PageWork;
          Caption := TreeMenu.Selected.Text;

          Closable := True;
          OnClose := TabSheetClose;
          Tag := NativeInt(TreeMenu.Selected);
        end;

        nFrame := nFrameClass.Create(Self);
        nFrame.Parent := FTabSheet;
        nFrame.Align := alClient;
      end;

      PageWork.ActivePage := FTabSheet;
      //active
    end;

    Break;
  end;
end;

procedure TfFormMain.TabSheetClose(Sender: TObject; var AllowClose: Boolean);
var nStr: string;
    nIdx: Integer;
    nNode: TUniTreeNode;
begin
  nNode := Pointer((Sender as TUniTabSheet).Tag);
  if not Assigned(nNode) then Exit;

  if TreeMenu.Selected = nNode then
    TreeMenu.Selected := nil;
  //xxxxx

  nIdx := NativeInt(nNode.Data);
  nStr := GetMenuItemID(nIdx);

  for nIdx := Low(UniMainModule.FMenuModule) to High(UniMainModule.FMenuModule) do
  with UniMainModule.FMenuModule[nIdx] do
  begin
    if CompareText(FMenuID, nStr) <> 0 then Continue;
    //not match

    FTabSheet := nil;
  end;
end;

initialization
  RegisterAppFormClass(TfFormMain);
end.
