unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, KMAlert;

type
  TForm1 = class(TForm)
    KMAlert1: TKMAlert;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure KMAlert1Show(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  KMAlert1.PopUp;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  KMAlert1.Show(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  KMAlert1.CloseUp;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Height:= 125;
end;

procedure TForm1.KMAlert1Show(Sender: TObject);
begin
  case KMAlert.TaskBarPos of
    ABE_BOTTOM: Label2.Caption:= 'TaskBar is Bottom';
    ABE_TOP: Label2.Caption:= 'TaskBar is Top';
    ABE_LEFT: Label2.Caption:= 'TaskBar is Left';
    ABE_RIGHT: Label2.Caption:= 'TaskBar is Right';
  end;
end;

end.
