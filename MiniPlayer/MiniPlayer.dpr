program MiniPlayer;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  Spisok in 'Spisok.pas' {Form2},
  Setting in 'Setting.pas' {Form3},
  About in 'About.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MiniPlayer';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
