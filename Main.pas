unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, Buttons, ComCtrls, MPlayer, Vcl.ExtDlgs;

const
  DRIVECOUNT = 26;
  ALL_DRIVES = 67108863;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    CheckBoxAll: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    FIconPath: string;
  public
    { Public declarations }
  end;

const
  DriveValues: array [1..DRIVECOUNT] of Integer = (
    1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096,
    8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576,
    2097152, 4194304, 8388608, 16777216, 33554432
  );

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  Reg: TRegistry;
  DriveWord: Integer;
  I: Integer;
begin
  if Application.MessageBox('Apply Drives Visible Settings?', 'Settings',
    mb_IconWarning + mb_YesNo) = IDNO then
    Exit
  else
  begin
    Reg := nil;
    try
      DriveWord := 0;
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer', True);
      for I := DRIVECOUNT downto 1 do
      begin
        with Form1.FindComponent('CheckBox' + I.ToString) as TCheckBox do
        begin
          if not Checked then
            DriveWord := DriveWord + DriveValues[I];
        end;
      end;
      if CheckBoxAll.Checked then
        Reg.WriteInteger('Nodrives', ALL_DRIVES)
      else
        Reg.WriteInteger('Nodrives', DriveWord);
      Reg.CloseKey;
    finally
      Reg.Free;
    end;
  end;
  if Application.MessageBox('Registry parameters were changed! Restart Windows?',
    'Apply settings', mb_IconWarning + mb_YesNo) = IDYES  then
     ExitWindows(EW_RebootSystem, 0);
end;


procedure TForm1.BitBtn2Click(Sender: TObject);
var
  Reg : TRegistry;
begin
  if not OpenPictureDialog1.Execute then
    Exit
  else
    FIconPath := OpenPictureDialog1.FileName;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\' +
      ComboBox1.Text + '\DefaultIcon', True);
    Reg.LazyWrite := True;
    Reg.WriteString('', FIconPath);
    Reg.CloseKey;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\' +
      ComboBox1.Text + '\DefaultLabel', True);
    Reg.LazyWrite := True;
    Reg.WriteString('', Edit1.Text);
    Reg.CloseKey;
    ShowMessage('New Icon Successfully Applied!');
  finally
    Reg.Free;
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  Reg : TRegistry;
begin
  if Application.MessageBox('Do you really want restore default icons for all drives?',
    'Confirm', MB_ICONQUESTION + MB_YESNO ) = IDYES then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons');
      Reg.CloseKey;
    finally
      Reg.Free;
    end;
  end;
end;

end.

