unit Setting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, inifiles;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    GroupBox3: TGroupBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ColorDialog1: TColorDialog;
    ColorDialog2: TColorDialog;
    Shape1: TShape;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  Vars: Tinifile;

implementation

uses MainForm, Spisok, About;

{$R *.dfm}
// поиск файла в каталоге
procedure Find;
var
   SearchRec: TSearchRec;
   lang: String;
begin
   if FindFirst('*.lng', faAnyFile,SearchRec) = 0 then
       repeat
          if (SearchRec.Attr and faAnyFile) = SearchRec.Attr then
             begin
              lang := SearchRec.Name;
              lang := Copy(lang, 0, Length(lang)-4);
              Form3.ComboBox1.Items.Add(lang);
             end;
        until FindNext(SearchRec) <> 0;
end;


procedure TForm3.FormShow(Sender: TObject);
var
cDir: String;
begin
 Vars:=TiniFile.Create(extractfilepath(paramstr(0))+'Config.ini');
 ComboBox1.Text := Vars.ReadString('Language','Language','Russian');

 ColorDialog1.Color := StringToColor(Vars.ReadString('MAlert','Color','clInfoBk'));
 ColorDialog2.Color := StringToColor(Vars.ReadString('MAlert','LabelColor','clWindowText'));

 Shape1.Brush.Color := StringToColor(Vars.ReadString('MAlert','Color','clInfoBk'));
 Label1.Color := StringToColor(Vars.ReadString('MAlert','Color','clInfoBk'));
 Label1.Font.Color := StringToColor(Vars.ReadString('MAlert','LabelColor','clWindowText'));

 if Vars.ReadString('CheckBox1', 'Cheked', '0') = '0' then
  CheckBox1.Checked := False
 else
  CheckBox1.Checked := True;
 Vars.Free;

{поиск сущ языков}
 ComboBox1.Items.Clear;
 cDir := Form1.Label6.Caption+'\Language\';
 ChDir(cDir);
 Find;
end;

//назад
procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
 Close;
end;

//выбор языка
procedure TForm3.ComboBox1Change(Sender: TObject);
begin
 Vars := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Language\' + ComboBox1.Text + '.lng');

 Form1.SpeedButton1.Hint := Vars.ReadString('Form1', 'SpeedButton1', '');
 Form1.SpeedButton2.Hint := Vars.ReadString('Form1', 'SpeedButton2', '');
 Form1.SpeedButton3.Hint := Vars.ReadString('Form1', 'SpeedButton3', '');
 Form1.SpeedButton4.Hint := Vars.ReadString('Form1', 'SpeedButton4', '');
 Form1.SpeedButton6.Hint := Vars.ReadString('Form1', 'SpeedButton6', '');
 Form1.SpeedButton8.Hint := Vars.ReadString('Form1', 'SpeedButton8', '');
 Form1.SpeedButton10.Hint := Vars.ReadString('Form1', 'SpeedButton10', '');
 Form1.SpeedButton12.Hint := Vars.ReadString('Form1', 'SpeedButton12', '');
 Form1.SpeedButton13.Hint := Vars.ReadString('Form1', 'SpeedButton13', '');
 Form1.SpeedButton14.Hint := Vars.ReadString('Form1', 'SpeedButton14', '');
 Form1.SpeedButton15.Hint := Vars.ReadString('Form1', 'SpeedButton15', '');
 Form1.SpeedButton16.Hint := Vars.ReadString('Form1', 'SpeedButton16', '');
 Form1.Label2.Caption := Vars.ReadString('Form1', 'Label2', '');
 Form1.Label3.Caption := Vars.ReadString('Form1', 'Label3', '');
 Form1.Label4.Caption := Vars.ReadString('Form1', 'Label4', '');
 Form1.Label5.Caption := Vars.ReadString('Form1', 'Label5', '');
 Form1.N1.Caption := Vars.ReadString('Form1', 'SpeedButton1', '');
 Form1.N21.Caption := Vars.ReadString('Form1', 'SpeedButton2', '');
 Form1.N31.Caption := Vars.ReadString('Form1', 'SpeedButton6', '');
 Form1.N51.Caption := Vars.ReadString('Form1', 'SpeedButton8', '');
 Form1.N61.Caption := Vars.ReadString('Form1', 'SpeedButton10', '');
 Form1.N71.Caption := Vars.ReadString('Form1', 'SpeedButton12', '');
 Form1.N41.Caption := Vars.ReadString('Form1', 'SpeedButton15', '');
 Form1.N81.Caption := Vars.ReadString('Form2', 'SpeedButton5', '');

 Form2.Caption := Vars.ReadString('Form2', 'Caption', '');
 Form2.SpeedButton1.Hint := Vars.ReadString('Form2', 'SpeedButton1', '');
 Form2.SpeedButton2.Hint := Vars.ReadString('Form2', 'SpeedButton2', '');
 Form2.SpeedButton4.Hint := Vars.ReadString('Form2', 'SpeedButton4', '');
 Form2.SpeedButton5.Hint := Vars.ReadString('Form2', 'SpeedButton5', '');

 Form3.Caption := Vars.ReadString('Form3', 'Caption', '');
 SpeedButton1.Hint := Vars.ReadString('Form3', 'SpeedButton1', '');
 GroupBox1.Caption := Vars.ReadString('Form3', 'GroupBox1', '');
 GroupBox2.Caption := Vars.ReadString('Form3', 'GroupBox2', '');
 CheckBox1.Caption := Vars.ReadString('Form3', 'ChekBox1', '');
 GroupBox3.Caption := Vars.ReadString('Form3', 'GroupBox3', '');
 SpeedButton2.Caption := Vars.ReadString('Form3', 'SpeedButton2', '');
 SpeedButton3.Caption := Vars.ReadString('Form3', 'SpeedButton3', '');
 Label1.Caption := Vars.ReadString('Form3', 'Label1', '');

 Vars.Free;
end;

//цвет фона
procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
 if ColorDialog1.Execute then
  Shape1.Brush.Color := ColorDialog1.Color;
end;

//цвет текста
procedure TForm3.SpeedButton3Click(Sender: TObject);
begin
 if ColorDialog2.Execute then
  Label1.Font.Color := ColorDialog2.Color;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Vars:=TiniFile.Create(extractfilepath(paramstr(0))+'Config.ini');
 Vars.WriteString('Language', 'Language', ComboBox1.Text);
 Vars.WriteString('MAlert', 'Color', ColorToString(Shape1.Brush.Color));
 Vars.WriteString('MAlert', 'LabelColor', ColorToString(Label1.Font.Color));

 Form1.KMAlert1.ForegroundColor := Shape1.Brush.Color;
 Form1.KMAlert1.Font.Color := Shape1.Brush.Color;
 Form1.Label13.Font.Color := Label1.Font.Color;
 Form1.Label14.Font.Color := Label1.Font.Color;

 if CheckBox1.Checked = True then
  begin
   Vars.WriteString('CheckBox1', 'Cheked', '1');
   Form1.Label12.Caption := '1';
  end
 else
  begin
   Vars.WriteString('CheckBox1', 'Cheked', '0');
   Form1.Label12.Caption := '0';
  end;
 Vars.Free;
end;

end.
