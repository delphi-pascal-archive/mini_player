unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, XPMan, ImgList, inifiles, StdCtrls, MPlayer,
  ComCtrls, MMSYSTEM, Menus, Trayicon, KMAlert;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    XPManifest1: TXPManifest;
    Panel2: TPanel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    MediaPlayer1: TMediaPlayer;
    ListBox1: TListBox;
    Label6: TLabel;
    Timer1: TTimer;
    Label11: TLabel;
    SpeedButton16: TSpeedButton;
    Panel3: TPanel;
    TrackBar1: TTrackBar;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    N1: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    Label12: TLabel;
    KMAlert1: TKMAlert;
    Label13: TLabel;
    Label14: TLabel;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
   
    procedure SpeedButton9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton11MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Play;
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N81Click(Sender: TObject);
   
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
     FCanClose: Boolean;
  end;

type
  TID3Tag = record
    Titel: string[30];
    Artist: string[30];
    Album: string[30];
    Genre: Byte;
  end;

const
 Genres : array[0..146] of string =  
    ('Blues','Classic Rock','Country','Dance','Disco','Funk','Grunge',  
    'Hip- Hop','Jazz','Metal','New Age','Oldies','Other','Pop','R&B',  
    'Rap','Reggae','Rock','Techno','Industrial','Alternative','Ska',  
    'Death Metal','Pranks','Soundtrack','Euro-Techno','Ambient',  
    'Trip-Hop','Vocal','Jazz+Funk','Fusion','Trance','Classical',  
    'Instrumental','Acid','House','Game','Sound Clip','Gospel','Noise',  
    'Alternative Rock','Bass','Punk','Space','Meditative','Instrumental Pop',
    'Instrumental Rock','Ethnic','Gothic','Darkwave','Techno-Industrial','Electronic',  
    'Pop-Folk','Eurodance','Dream','Southern Rock','Comedy','Cult','Gangsta',  
    'Top 40','Christian Rap','Pop/Funk','Jungle','Native US','Cabaret','New Wave',  
    'Psychadelic','Rave','Showtunes','Trailer','Lo-Fi','Tribal','Acid Punk',  
    'Acid Jazz','Polka','Retro','Musical','Rock & Roll','Hard Rock','Folk',  
    'Folk-Rock','National Folk','Swing','Fast Fusion','Bebob','Latin','Revival',  
    'Celtic','Bluegrass','Avantgarde','Gothic Rock','Progressive Rock',  
    'Psychedelic Rock','Symphonic Rock','Slow Rock','Big Band','Chorus',  
    'Easy Listening','Acoustic','Humour','Speech','Chanson','Opera',  
    'Chamber Music','Sonata','Symphony','Booty Bass','Primus','Porn Groove',  
    'Satire','Slow Jam','Club','Tango','Samba','Folklore','Ballad',  
    'Power Ballad','Rhytmic Soul','Freestyle','Duet','Punk Rock','Drum Solo',  
    'Acapella','Euro-House','Dance Hall','Goa','Drum & Bass','Club-House',  
    'Hardcore','Terror','Indie','BritPop','Negerpunk','Polsk Punk','Beat',  
    'Christian Gangsta','Heavy Metal','Black Metal','Crossover','Contemporary C',
    'Christian Rock','Merengue','Salsa','Thrash Metal','Anime','JPop','SynthPop');

var
  Form1: TForm1;

implementation

uses Spisok, Setting, About;

{$R *.dfm}

var
  min,sec: integer; // время воспроизведения
  volume: LongWord; // старшее слово - правый канал,
                    // младшее - левый.

function ReadID3Tag(FileName: string): TID3Tag;  
var  
  FS: TFileStream;  
  Buffer: array [1..128] of Char;  
begin  
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);  
  try  
    FS.Seek(-128, soFromEnd);  
    FS.Read(Buffer, 128);  
    with Result do  
    begin  
      Titel := Copy(Buffer, 4, 30);
      Artist := Copy(Buffer, 34, 30);
      Album := Copy(Buffer, 64, 30);
      Genre := Ord(Buffer[128]);
    end;  
  finally  
    FS.Free;  
  end;  
end;

procedure TForm1.SpeedButton5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 SpeedButton6.Visible := True;
end;

procedure TForm1.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 SpeedButton6.Visible := False;
 SpeedButton8.Visible := False;
 SpeedButton10.Visible := False;
 SpeedButton12.Visible := False;
end;

procedure TForm1.SpeedButton7MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 SpeedButton8.Visible := True;
end;

//начальная загрузка
procedure TForm1.FormShow(Sender: TObject);
var Vars: Tinifile;
colorKMA, colorL: String;
begin

 SpeedButton6.Left := 8;
 SpeedButton8.Left := 40;
 SpeedButton10.Left := 104;
 SpeedButton12.Left := 136;
 SpeedButton14.Left := 232;
 SpeedButton15.Left := 8;

 //язык
 Vars:=TiniFile.Create(extractfilepath(paramstr(0))+'Config.ini');
 Label1.Caption := Vars.ReadString('Language','Language','Russian');
 Label12.Caption := Vars.ReadString('CheckBox1','Cheked','0');
 colorKMA := Vars.ReadString('MAlert','Color','clInfoBk');
 colorL := Vars.ReadString('MAlert','LabelColor','clWindowText');

 KMAlert1.ForegroundColor := StringToColor(colorKMA);
 KMAlert1.Font.Color := StringToColor(colorKMA);
 Label13.Font.Color := StringToColor(colorL);
 Label14.Font.Color := StringToColor(colorL);
 Vars.Free;

 Vars := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Language\' + Label1.Caption + '.lng');

 SpeedButton1.Hint := Vars.ReadString('Form1', 'SpeedButton1', '');
 N1.Caption := Vars.ReadString('Form1', 'SpeedButton1', '');
 SpeedButton2.Hint := Vars.ReadString('Form1', 'SpeedButton2', '');
 N21.Caption := Vars.ReadString('Form1', 'SpeedButton2', '');
 SpeedButton3.Hint := Vars.ReadString('Form1', 'SpeedButton3', '');
 SpeedButton4.Hint := Vars.ReadString('Form1', 'SpeedButton4', '');
 SpeedButton6.Hint := Vars.ReadString('Form1', 'SpeedButton6', '');
 N31.Caption := Vars.ReadString('Form1', 'SpeedButton6', '');
 SpeedButton8.Hint := Vars.ReadString('Form1', 'SpeedButton8', '');
 N51.Caption := Vars.ReadString('Form1', 'SpeedButton8', '');
 SpeedButton10.Hint := Vars.ReadString('Form1', 'SpeedButton10', '');
 N61.Caption := Vars.ReadString('Form1', 'SpeedButton10', '');
 SpeedButton12.Hint := Vars.ReadString('Form1', 'SpeedButton12', '');
 N71.Caption := Vars.ReadString('Form1', 'SpeedButton12', '');
 SpeedButton13.Hint := Vars.ReadString('Form1', 'SpeedButton13', '');
 SpeedButton14.Hint := Vars.ReadString('Form1', 'SpeedButton14', '');
 SpeedButton15.Hint := Vars.ReadString('Form1', 'SpeedButton15', '');
 N41.Caption := Vars.ReadString('Form1', 'SpeedButton15', '');
 SpeedButton16.Hint := Vars.ReadString('Form1', 'SpeedButton16', '');
 Label2.Caption := Vars.ReadString('Form1', 'Label2', '');
 Label3.Caption := Vars.ReadString('Form1', 'Label3', '');
 Label4.Caption := Vars.ReadString('Form1', 'Label4', '');
 Label5.Caption := Vars.ReadString('Form1', 'Label5', '');
 N81.Caption := Vars.ReadString('Form2', 'SpeedButton5', '');
 Label7.Caption := '';
 Label8.Caption := '';
 Label9.Caption := '';
 Label10.Caption := '';
 Label11.Caption := '0:00';
 SpeedButton15.Down := False;

 Form2.Caption := Vars.ReadString('Form2', 'Caption', '');
 Form2.SpeedButton1.Hint := Vars.ReadString('Form2', 'SpeedButton1', '');
 Form2.SpeedButton2.Hint := Vars.ReadString('Form2', 'SpeedButton2', '');
 Form2.SpeedButton4.Hint := Vars.ReadString('Form2', 'SpeedButton4', '');
 Form2.SpeedButton5.Hint := Vars.ReadString('Form2', 'SpeedButton5', '');

 Form3.Caption := Vars.ReadString('Form3', 'Caption', '');
 Form3.SpeedButton1.Hint := Vars.ReadString('Form3', 'SpeedButton1', '');
 Form3.GroupBox1.Caption := Vars.ReadString('Form3', 'GroupBox1', '');
 Form3.GroupBox2.Caption := Vars.ReadString('Form3', 'GroupBox2', '');
 Form3.CheckBox1.Caption := Vars.ReadString('Form3', 'ChekBox1', '');
 Form3.GroupBox3.Caption := Vars.ReadString('Form3', 'GroupBox3', '');
 Form3.SpeedButton2.Caption := Vars.ReadString('Form3', 'SpeedButton2', '');
 Form3.SpeedButton3.Caption := Vars.ReadString('Form3', 'SpeedButton3', '');
 Form3.Label1.Caption := Vars.ReadString('Form3', 'Label1', '');

 Vars.Free;

 ListBox1.Clear;
 ListBox1.Items.LoadFromFile(Label6.Caption + '\List.kvs');

 // старшее слово переменной volume - правый канал,
 // младшее - левый
 volume := (TrackBar1.Position - TrackBar1.Max+1)* 6500;
 volume := volume +   (volume shl 16);
 waveOutSetVolume(WAVE_MAPPER,volume); // уровень сигнала
 TrackBar1.Position := 7;
end;

procedure TForm1.SpeedButton9MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  SpeedButton10.Visible := True;
end;

procedure TForm1.SpeedButton11MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 SpeedButton12.Visible := True;
end;

//выключить звук
procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
 volume := 0;
 waveOutSetVolume(WAVE_MAPPER,volume);
 TrackBar1.Enabled := False;

 SpeedButton14.Visible := True;
end;

//включить звук
procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
 volume := 6500* (TrackBar1.Max - TrackBar1.Position);
 volume := volume +  (volume shl 16);
 waveOutSetVolume(WAVE_MAPPER, volume);
 TrackBar1.Enabled := True;

 SpeedButton14.Visible := False;
end;

// воспроизвести композицию,
// название которой выделено
// в списке ListBox1
procedure TForm1.Play;
var
Fname: String;
nom: Integer;
Namef, rash : String;
leng,buf1, buf2: Integer;
begin
  Timer1.Enabled := False;

  nom:= ListBox1.ItemIndex;

  Namef := ListBox1.Items.Strings[nom];
  buf2 := LastDelimiter('.',Namef);
  rash := Copy(Namef, buf2, 4);
  buf1 := LastDelimiter('\',Namef);
  Delete(Namef, 1, buf1);
  leng := Length(Namef);
  buf2 := LastDelimiter('.',Namef);
  Delete(Namef, buf2, leng);

  Fname := ListBox1.Items[nom];

  if (rash = '.mp3') or (rash = '.m3u') then
  begin
   With ReadID3Tag(Fname) Do
    Begin
     Label7.Caption := Titel;
     Label13.Caption := Titel;
     Label8.Caption := Artist;
     Label14.Caption := Artist;
     Label9.Caption := Album;
    If (Genre>=0) and (Genre<=146) Then
      Label10.Caption := Genres[Genre]
    Else
      Label10.Caption := 'N/A';
  End;
  end
  else
  begin
   Label7.Caption := Namef;
   Label13.Caption := Namef;
   Label8.Caption := '';
   Label9.Caption := '';
   Label10.Caption := '';
   Label14.Caption := '';
  end;

  MediaPlayer1.FileName := Fname;

  try
   Mediaplayer1.Open;
  except
    on EMCIDeviceError do
      begin
        ShowMessage('Ошибка обращения к файлу '+
                     ListBox1.Items[ListBox1.ItemIndex]);
        SpeedButton3.Down := False;
        exit;
      end;
  end;
  MediaPlayer1.Play;
  min := 0;
  sec := 0;
  Timer1.Enabled := True;
  if TrayIcon1.Active = True then
   KMAlert1.PopUp;
end;

//играть
procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
 if ListBox1.Count = 0 then
  MessageDlg('В списке воспроизведения нет треков', mtError, [mbOK], 0)
 else
 begin
  if ListBox1.ItemIndex = -1 then
      ListBox1.ItemIndex := 0;
       
  if Label11.Caption = '0:00' then Play  //песьня с начала
   else
   begin
    MediaPlayer1.Play;            //продолжить воспроизведение
    Timer1.Enabled := True;
   end;

 SpeedButton15.Visible := True;
end;

end;

//пауза
procedure TForm1.SpeedButton15Click(Sender: TObject);
begin
 if SpeedButton15.Down then
  begin
   MediaPlayer1.Pause;
   SpeedButton15.Down := False;
   Timer1.Enabled := False;
   SpeedButton15.Visible := False;
  end;
end;

//выход
procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 FCanClose := true;
 Close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 MediaPlayer1.Close;
 Timer1.Enabled := False;
 Label11.Caption := '0:00';
 SpeedButton15.Down := False;
 SpeedButton15.Visible := False;
 Form2.ShowModal;
end;

// сигнал от таймера
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // изменить счетчик времени
  if sec < 59
    then inc(sec)
    else begin
      sec :=0;
      inc(min);
    end;

  // вывести время воспроизведения
  Label11.Caption := IntToStr(min)+':';
  if sec < 10
    then Label11.Caption :=
           Label11.Caption +'0'+ IntToStr(sec)
    else Label11.Caption :=
           Label11.Caption + IntToStr(sec);

  // если воспроизведение текущей композиции
  // не завершено
  if MediaPlayer1.Position < MediaPlayer1.Length
    then exit;

  // воспроизведение текущей композиции
  // закончено
  Timer1.Enabled := False; // остановить таймер
  MediaPlayer1.Stop;       // остановить плеер

  if ListBox1.ItemIndex < ListBox1.Count // список не исчерпан
  then begin
        ListBox1.ItemIndex := ListBox1.ItemIndex + 1;
        Play;
       end
end;

//стоп
procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
 MediaPlayer1.Close;
 Timer1.Enabled := False;
 Label11.Caption := '0:00';
 SpeedButton15.Down := False;
 SpeedButton15.Visible := False;
end;

//предыдущая
procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
if ListBox1.ItemIndex > 0 then
        ListBox1.ItemIndex := ListBox1.ItemIndex - 1;
 Label11.Caption := '0:00';
 SpeedButton15.Down := False;
 SpeedButton15.Visible := False;

 Play;
 SpeedButton10.Visible := False;
end;

//следующая
procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
 if ListBox1.ItemIndex < ListBox1.Count then
        ListBox1.ItemIndex := ListBox1.ItemIndex + 1;
  Label11.Caption := '0:00';
  SpeedButton15.Down := False;
  SpeedButton15.Visible := False;

  Play;
  SpeedButton12.Visible := False;
end;

//панель громкости
procedure TForm1.SpeedButton16Click(Sender: TObject);
begin
 if SpeedButton16.Down then
  Panel3.Visible := True
 else
  Panel3.Visible := False;
end;

//изменение громкости
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
 volume := 6500* (TrackBar1.Max - TrackBar1.Position);
 volume := volume +  (volume shl 16);
 waveOutSetVolume(WAVE_MAPPER,volume);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 Form3.ShowModal;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if Label12.Caption = '1' then
  begin
   CanClose:=FCanClose;
    if not CanClose
     then
     begin
      Hide;
      TrayIcon1.Active := true;
     end;
  end;

end;

procedure TForm1.N81Click(Sender: TObject);
begin
 TrayIcon1.Active := false;
 Show;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
cDir: string;
begin
 GetDir(0, cDir);

 Label6.Caption := cDir;

end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 Form1.Visible := False;
 Form4.ShowModal;
end;

end.
