unit KMAlert;

{  ====================================  }
{  TKMAlert в.1.0                        }
{  Объект на основе BergSoftware TAlert  }
{  ====================================  }
{  Основная задача данного объекта зак-  }
{  лючается в выводе Окна с Вашим сооб-  }
{  щением, иконкой и т.д. Окошко появ-   }
{  ляется на установленное время в углу  }
{  с треем и исчезает.                   }
{  Поддерживаються следующие команды:    }
{  PopUp - Для автомитического вычисле-  }
{          ния Трэя и вывода окна;       }
{  Show(X, Y) - Для ручного вывода окна  }
{               в установленном месте;   }
{  CloseUp - Скрытие окна.               }
{  ====================================  }
{  Разрабатывался на Delphi 7 (b 8.1)    }
{  Доработал KiBERMiKE сентябрь 2005 г.  }
{  KiBERMiKE@yandex.ru                   }
{  ====================================  }

interface

uses
  Windows, Classes, Messages, Controls, Forms, ExtCtrls, Graphics,
  SysUtils, ShellApi;

type
  TAlertDirection = (adNone, adUp, adDown, adLeft, adRight);
  TOnShow = procedure (Sender: TObject) of object;
  TOnClose = procedure (Sender: TObject) of object;

type
	TKMAlert = class(TCustomControl)
  private
  	FAlertDirection: TAlertDirection;
    FCloseDelay: Integer;
    FDelayTimer: TTimer;
    FForegroundColor: TColor;
    FInProgress: Boolean;
    FOnShow: TOnShow;
    FOnClose: TOnClose;
    TaskBarRect: TRect;
    function FindTaskbar(var ARect: TRect): Integer;
    procedure GetTaskBar;
    procedure SetCloseDelay(const Value: Integer);
    procedure SetForegroundColor(const Value: TColor);
    procedure GoPopUp;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoDelayTimer(Sender: TObject);
    procedure Paint; override;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
  	constructor Create(AOwner: TComponent); override;
  	procedure PopUp;
  	procedure CloseUp;
    procedure Show(X, Y: Integer);
  published
    property CloseDelay: Integer read FCloseDelay write SetCloseDelay;
    property Font;
    property ForegroundColor: TColor read FForegroundColor write SetForegroundColor;
    property OnShow: TOnShow read FOnShow write FOnShow;
    property OnClose: TOnClose read FOnClose write FOnClose;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

var
  TaskBarPos: Cardinal;

implementation

{ TKMAlert }

procedure Register;
begin
  RegisterComponents('KiBERMiKE''s Soft', [TKMAlert]);
end;

constructor TKMAlert.Create(AOwner: TComponent);
begin
  inherited;
  Visible:= csDesigning in ComponentState;
  ControlStyle:= ControlStyle + [csAcceptsControls, csReplicatable];
  FAlertDirection:= adNone;
  FCloseDelay:= 5000;
  FForegroundColor:= clInfoBk;
  FInProgress:= False;
  FDelayTimer:= TTimer.Create(Self);
  FDelayTimer.Enabled:= False;
  FDelayTimer.OnTimer:= DoDelayTimer;
  FDelayTimer.Interval:= FCloseDelay;
  FOnShow:= nil;
  ParentColor:= True;
  Height:= 153;
  Width:= 169;
end;

procedure TKMAlert.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  	if not (csDesigning in ComponentState) then
    begin
	    WndParent:= GetDesktopWindow;
   	  Style:= WS_CLIPSIBLINGS or WS_CHILD;
	 	  ExStyle:= WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
   	  WindowClass.Style:= CS_DBLCLKS or CS_SAVEBITS and not(CS_HREDRAW or CS_VREDRAW);
	  end;
end;

procedure TKMAlert.CreateWnd;
begin
  inherited;
end;

procedure TKMAlert.SetCloseDelay(const Value: Integer);
begin
  FCloseDelay:= Value;
  FDelayTimer.Interval:= Value;
end;

procedure TKMAlert.SetForegroundColor(const Value: TColor);
begin
  FForegroundColor:= Value;
  Invalidate;
end;

procedure TKMAlert.DoDelayTimer(Sender: TObject);
begin
  FInProgress:= False;

  FDelayTimer.Enabled:= False;

  CloseUp;
end;

procedure TKMAlert.GoPopUp;
var
	delta: Integer;
begin
  if Assigned(FOnShow) then FOnShow(Self);

  delta:= 0;

  case TaskBarPos of
    ABE_BOTTOM:
      delta:= TaskbarRect.Bottom - TaskbarRect.Top;
    ABE_TOP:
      delta:= TaskbarRect.Bottom;
    ABE_LEFT:
      delta:= TaskbarRect.Right;
    ABE_RIGHT:
      delta:= TaskbarRect.Right - TaskbarRect.Left;
  end;

  case FAlertDirection of
    adUp:
    begin
      SetWindowPos(Handle, HWND_TOPMOST, (Screen.Width - Width),
          (Screen.Height - delta) - Height, Width, Height, SWP_HIDEWINDOW);
      AnimateWindow(Handle, 500, AW_VER_NEGATIVE + AW_SLIDE);
      FDelayTimer.Enabled:= True;
    end;
    adDown:
    begin
      SetWindowPos(Handle, HWND_TOPMOST, Screen.Width - Width,
                   delta, Width, Height, SWP_HIDEWINDOW);
      AnimateWindow(Handle, 500, AW_VER_POSITIVE + AW_SLIDE);
      FDelayTimer.Enabled:= True;
    end;
    adLeft:
    begin
      SetWindowPos(Handle, HWND_TOPMOST, (Screen.Width - delta) - Width,
          Screen.Height - Height, Width, Height, SWP_HIDEWINDOW);
      AnimateWindow(Handle, 500, AW_HOR_NEGATIVE + AW_SLIDE);
      FDelayTimer.Enabled:= True;
    end;
    adRight:
    begin
      SetWindowPos(Handle, HWND_TOPMOST, delta,
                   Screen.Height - Height, Width, Height, SWP_HIDEWINDOW);
      AnimateWindow(Handle, 500, AW_HOR_POSITIVE + AW_SLIDE);
      FDelayTimer.Enabled:= True;
    end;
  end;
end;

procedure TKMAlert.CloseUp;
var
  OldPos: Cardinal;
begin
  if Assigned(FOnClose) then FOnClose(Self);

  OldPos:= TaskBarPos;

  GetTaskBar;

  FDelayTimer.Enabled:= False;

  if OldPos <> TaskBarPos then
    FAlertDirection:= adNone;

  case FAlertDirection of
    adUp:
      AnimateWindow(Handle, 500, AW_VER_POSITIVE + AW_SLIDE + AW_HIDE);
    adDown:
      AnimateWindow(Handle, 500, AW_VER_NEGATIVE + AW_SLIDE + AW_HIDE);
    adLeft:
      AnimateWindow(Handle, 500, AW_HOR_POSITIVE + AW_SLIDE + AW_HIDE);
    adRight:
      AnimateWindow(Handle, 500, AW_HOR_NEGATIVE + AW_SLIDE + AW_HIDE);
    adNone:
      AnimateWindow(Handle, 500, AW_CENTER + AW_SLIDE + AW_HIDE);
  end;
end;

procedure TKMAlert.Show(X, Y: Integer);
begin
  if Assigned(FOnShow) then FOnShow(Self);

 	FInProgress:= True;

  SetWindowPos(Handle, HWND_TOPMOST, X, Y,
               Width, Height, SWP_HIDEWINDOW);

  AnimateWindow(Handle, 500, AW_CENTER + AW_SLIDE);

  FAlertDirection:= adNone;

  FDelayTimer.Enabled:= True;
end;

procedure TKMAlert.WMNCPaint(var Message: TMessage);
begin
  inherited;
end;

procedure TKMAlert.WMSize(var Message: TWMSize);
begin
  inherited;
end;

procedure TKMAlert.Paint;
var
  R: TRect;
begin
  inherited;
	with Canvas do
  begin
    Brush.Color:= ForegroundColor;
    FillRect(ClientRect);

    R:= ClientRect;
    OffsetRect(R, R.Left, R.Top);
    DrawEdge(Handle, R, EDGE_RAISED, BF_RECT);
    InflateRect(R, -2, -2);
    DrawEdge(Handle, R, EDGE_SUNKEN, BF_RECT);
  end;
end;

procedure TKMAlert.Popup;
begin
  ShowWindow(Handle, SW_HIDE);

  GetTaskBar;

  case TaskBarPos of
    ABE_BOTTOM:
     FAlertDirection:= adUp;
    ABE_TOP:
      FAlertDirection:= adDown;
    ABE_LEFT:
      FAlertDirection:= adRight;
    ABE_RIGHT:
      FAlertDirection:= adLeft;
  end;

 	FInProgress:= True;

  GoPopUp;
end;

function TKMAlert.FindTaskbar(var ARect: TRect): Integer;
var
	AppData: TAppBarData;
begin
	AppData.Hwnd:= FindWindow('Shell_TrayWnd', nil);
  AppData.cbSize:= SizeOf(TAppBarData);
  if SHAppBarMessage(ABM_GETTASKBARPOS, AppData) = 0 then
    raise Exception.Create('SHAppBarMessage returned false when trying ' +
      'to find the Task Bar''s position');
  Result:= AppData.uEdge;
  ARect:= AppData.rc;
end;

procedure TKMAlert.GetTaskBar;
begin
  TaskBarPos:= FindTaskBar(TaskBarRect);
end;

end.