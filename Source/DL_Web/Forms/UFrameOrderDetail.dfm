inherited fFrameOrderDetail: TfFrameOrderDetail
  Width = 1080
  Height = 636
  Font.Charset = GB2312_CHARSET
  Font.Height = -12
  Font.Name = #23435#20307
  ParentFont = False
  ExplicitWidth = 1080
  ExplicitHeight = 636
  inherited PanelWork: TUniContainerPanel
    Width = 1080
    Height = 636
    ExplicitWidth = 991
    ExplicitHeight = 636
    inherited UniToolBar1: TUniToolBar
      Width = 1080
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      ExplicitWidth = 991
      inherited BtnAdd: TUniToolButton
        Visible = False
      end
      inherited BtnEdit: TUniToolButton
        Visible = False
      end
      inherited BtnDel: TUniToolButton
        Visible = False
      end
      inherited UniToolButton4: TUniToolButton
        Visible = False
      end
    end
    inherited PanelQuick: TUniSimplePanel
      Width = 1080
      ExplicitWidth = 991
      object Label2: TUniLabel
        Left = 422
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #20379' '#24212' '#21830':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 1
      end
      object EditCustomer: TUniEdit
        Left = 482
        Top = 12
        Width = 125
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 2
        EmptyText = #26597#25214
        OnKeyPress = EditTruckKeyPress
      end
      object Label3: TUniLabel
        Left = 634
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #26085#26399#31579#36873':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 3
      end
      object EditDate: TUniEdit
        Left = 695
        Top = 12
        Width = 185
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 4
        EmptyText = #26597#25214
        ReadOnly = True
        OnKeyPress = EditTruckKeyPress
      end
      object BtnDateFilter: TUniBitBtn
        Left = 882
        Top = 12
        Width = 25
        Height = 22
        Hint = ''
        Caption = '...'
        TabOrder = 5
        OnClick = BtnDateFilterClick
      end
      object Label1: TUniLabel
        Left = 12
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #27966#36710#21333#21495':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 6
      end
      object EditBill: TUniEdit
        Left = 77
        Top = 12
        Width = 125
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 7
        EmptyText = #26597#25214
        OnKeyPress = EditTruckKeyPress
      end
      object Label4: TUniLabel
        Left = 220
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #36710#29260#21495#30721':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 8
      end
      object EditTruck: TUniEdit
        Left = 280
        Top = 12
        Width = 125
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 9
        EmptyText = #26597#25214
        OnKeyPress = EditTruckKeyPress
      end
      object Check1: TUniCheckBox
        Left = 928
        Top = 15
        Width = 97
        Height = 17
        Hint = ''
        Caption = #26597#35810#24050#21024#38500
        TabOrder = 10
      end
    end
    inherited DBGridMain: TUniDBGrid
      Width = 1080
      Height = 534
      OnMouseDown = DBGridMainMouseDown
      Columns = <
        item
          Width = 64
          Font.Charset = GB2312_CHARSET
          Font.Height = -12
          Font.Name = #23435#20307
        end>
    end
    inherited SplitterTop: TUniSplitter
      Width = 1080
      ExplicitWidth = 991
    end
  end
  object PMenu1: TUniPopupMenu
    Left = 40
    Top = 184
    object MenuItemN1: TUniMenuItem
      Caption = #26102#38388#27573#26597#35810
      OnClick = MenuItemN1Click
    end
    object MenuItemN2: TUniMenuItem
      Caption = '-'
    end
    object MenuItemN3: TUniMenuItem
      Caption = #26597#35810#26410#23436#25104
      OnClick = MenuItemN3Click
    end
  end
end
