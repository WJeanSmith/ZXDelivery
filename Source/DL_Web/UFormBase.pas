{*******************************************************************************
  ����: dmzn@163.com 2018-04-24
  ����: ��׼����
*******************************************************************************}
unit UFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniPanel, uniGUIBaseClasses, uniButton;

type
  TfFormBase = class(TUniForm)
    BtnOK: TUniButton;
    BtnExit: TUniButton;
    PanelWork: TUniSimplePanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
