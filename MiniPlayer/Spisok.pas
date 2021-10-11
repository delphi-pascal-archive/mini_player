unit Spisok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ListBox2: TListBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
 aFile = '\List.kvs';

var
  Form2: TForm2;
  F: TextFile;
  Fname, name: String;
implementation

uses MainForm;

{$R *.dfm}
//добавить
procedure TForm2.SpeedButton1Click(Sender: TObject);
var
i: integer;
koldir, kols, kolss: integer;
nam, str, cDir: string;
begin
 if OpenDialog1.Execute then
  begin
  GetDir(0, cDir);
  koldir := length(cdir);
  for i:=0 to OpenDialog1.Files.Count-1 do
    begin
    kols := length(OpenDialog1.Files.Strings[i]);
    ListBox2.Items.Add(OpenDialog1.Files.Strings[i]);
    nam := Copy(OpenDialog1.Files.Strings[i], koldir+2, kols-koldir);
    kolss := length(nam);
    str := copy(nam, 0, kolss-4);
    ListBox1.Items.Add(str);
    end;
  end;
end;

//удалить
procedure TForm2.SpeedButton2Click(Sender: TObject);
var
i: Integer;
begin
 i := ListBox1.ItemIndex; //номер выделенного элемента

 if ListBox1.ItemIndex <> -1 then
  begin
   ListBox1.Items.Delete(i);
   ListBox2.Items.Delete(i);
  end
  else
   MessageDlg('Не выделен трек', mtError, [mbOK], 0);
end;

//Удалить все
procedure TForm2.SpeedButton4Click(Sender: TObject);
begin
 ListBox1.Clear;
 ListBox2.Clear;
end;

//открытие формы
procedure TForm2.FormShow(Sender: TObject);
var
 Namef : String;
 leng,buf1, buf2, col, i: Integer;
begin
 ListBox1.Clear;

 Fname := Form1.Label6.Caption + aFile;
 ListBox2.Items.LoadFromFile(Fname);

 col := ListBox2.Count;
 for i:= 0 to col-1 do
  begin
   Namef := ListBox2.Items.Strings[i];
   buf1 := LastDelimiter('\',Namef);
   Delete(Namef, 1, buf1);
   leng := Length(Namef);
   buf2 := LastDelimiter('.',Namef);
   Delete(Namef, buf2, leng);
   ListBox1.Items.Add(Namef);
  end;

 DeleteFile(Fname);  //удалить старый файл
end;

//назад
procedure TForm2.SpeedButton5Click(Sender: TObject);
begin
 Close;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var
 h, i: Integer;
begin
 Fname := Form1.Label6.Caption + aFile;  //путь к файлу List

 h:= FileCreate(Fname);  //создать новый
 FileClose(h);

 ListBox2.Items.SaveToFile(Fname);

 Form1.ListBox1.Clear;
 for i:= 0 to ListBox2.Count - 1 do
 Form1.ListBox1.Items.Add(ListBox2.Items.Strings[i]);
end;

end.
