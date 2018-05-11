object fFrameBase: TfFrameBase
  Left = 0
  Top = 0
  Width = 814
  Height = 590
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  TabOrder = 0
  AutoScroll = True
  object PanelWork: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 590
    Hint = ''
    ParentColor = False
    Align = alClient
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object UniToolBar1: TUniToolBar
      Left = 0
      Top = 0
      Width = 814
      Height = 46
      Hint = ''
      ButtonHeight = 42
      ButtonWidth = 87
      Images = UniMainModule.ImageListBar
      ShowCaptions = True
      Anchors = [akLeft, akTop, akRight]
      Align = alTop
      TabOrder = 1
      ParentColor = False
      Color = clBtnFace
      object BtnAdd: TUniToolButton
        Left = 0
        Top = 0
        Hint = ''
        ImageIndex = 0
        Caption = #28155#21152
        TabOrder = 1
      end
      object BtnEdit: TUniToolButton
        Left = 87
        Top = 0
        Hint = ''
        ImageIndex = 1
        Caption = #20462#25913
        TabOrder = 2
      end
      object BtnDel: TUniToolButton
        Left = 174
        Top = 0
        Hint = ''
        ImageIndex = 2
        Caption = #21024#38500
        TabOrder = 3
      end
      object UniToolButton4: TUniToolButton
        Left = 261
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'UniToolButton4'
        TabOrder = 4
      end
      object BtnRefresh: TUniToolButton
        Left = 269
        Top = 0
        Hint = ''
        ImageIndex = 3
        Caption = #21047#26032
        ScreenMask.Message = #27491#22312#35835#21462
        ScreenMask.Target = PanelWork
        TabOrder = 5
        OnClick = BtnRefreshClick
      end
      object UniToolButton10: TUniToolButton
        Left = 356
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'UniToolButton10'
        TabOrder = 9
      end
      object BtnPrint: TUniToolButton
        Left = 364
        Top = 0
        Hint = ''
        ImageIndex = 4
        Caption = #25171#21360
        TabOrder = 6
      end
      object BtnPreview: TUniToolButton
        Left = 451
        Top = 0
        Hint = ''
        ImageIndex = 5
        Caption = #39044#35272
        TabOrder = 7
      end
      object BtnExport: TUniToolButton
        Left = 538
        Top = 0
        Hint = ''
        ImageIndex = 6
        Caption = #23548#20986
        TabOrder = 8
      end
      object UniToolButton11: TUniToolButton
        Left = 625
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'UniToolButton11'
        TabOrder = 10
      end
      object BtnExit: TUniToolButton
        Left = 633
        Top = 0
        Hint = ''
        ImageIndex = 7
        Caption = #36864#20986
        TabOrder = 11
        OnClick = BtnExitClick
      end
    end
    object PanelQuick: TUniSimplePanel
      Left = 0
      Top = 46
      Width = 814
      Height = 50
      Hint = ''
      ParentColor = False
      Border = True
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object DBGridMain: TUniDBGrid
      Left = 0
      Top = 96
      Width = 814
      Height = 494
      Hint = ''
      DataSource = DataSource1
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgAutoRefreshRow]
      LoadMask.Message = 'Loading data...'
      Align = alClient
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
      OnColumnSort = DBGridMainColumnSort
    end
  end
  object ClientDS: TClientDataSet
    Aggregates = <>
    ObjectView = False
    Params = <>
    Left = 40
    Top = 232
  end
  object DataSource1: TDataSource
    DataSet = ClientDS
    Left = 96
    Top = 232
  end
end
