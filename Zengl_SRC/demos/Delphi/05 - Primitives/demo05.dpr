program demo05;

{$I zglCustomConfig.cfg}
{$I zgl_config.cfg}

{$R *.res}

uses
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_keyboard,
  zgl_fx,
  zgl_render_2d,
  zgl_primitives_2d,
  zgl_types,
  zgl_math_2d,
  {$IfNDef OLD_METHODS}
  gegl_color,
  {$EndIf}
  zgl_utils;

var
  calc   : Integer;
  points : array[ 0..359 ] of zglTPoint2D;
  TimeStart: LongWord = 0;
  {$IfNDef OLD_METHODS}
  dirRes : UTF8String {$IFNDEF MACOSX} = '../data/' {$ENDIF};
  newColor: array[0..1] of LongWord;
  {$EndIf}

procedure Init;
  var
    i : Integer;
begin
  for i := 0 to 359 do
  begin
    points[ i ].X := 400 + m_Cos( i ) * ( 96 + random( 32 ) );
    points[ i ].Y := 300 + m_Sin( i ) * ( 96 + random( 32 ) );
  end;
   {$IfNDef OLD_METHODS}
  // Rus: ������������� ����� ����, �������� ��� � ������ �����������. ��� ��������� � gegl_color.
  // Eng: set a new color. Which is not in the standard list. All constants in gegl_color.
  newColor[0] := Color_FindOrAdd($0000009B);
  newColor[1] := Color_FindOrAdd($FFFFFF4B);
  {$EndIf}
end;

procedure Draw;
var
  i : Integer;
begin
  // RU: ������������� ���� � ����� ��� ������ ������� �������������� ( � ������ ������)
  // EN: Set color and alpha for each vertex.
  fx2d_SetVCA( $FF0000, $00FF00, $0000FF, $FFFFFF, 255, 255, 255, 255 );
  // RU: ������ ������������� � ��������(���� PR2D_FILL) � �������������� ��������� ������ ��� ������ �������(���� FX2D_VCA).
  // EN: Render filled rectangle(flag PR2D_FILL) and use different colors for each vertex(flag FX2D_VCA).
  pr2d_Rect(0, 0, 800, 600, {$IfDef OLD_METHODS}$000000, 255{$Else}cl_Black{$EndIf}, FX2D_VCA or PR2D_FILL);   // 4 + $010000

  // RU: ������ � ������ ������ ���� � �������� 128 �������.
  // EN: Render circle in the center of screen with radius 128 pixels.
  pr2d_Circle( 400, 300, 128, {$IfDef OLD_METHODS}$000000, 155{$Else}newColor[0]{$EndIf}, 32, PR2D_FILL );

  // RU: ������ ����� ������ �����.
  // EN: Render lines inside the circle.

  for i := 0 to 359 do
    pr2d_Line( 400, 300, points[ i ].X, points[ i ].Y, {$IfDef OLD_METHODS}$FFFFFF, 255{$Else}cl_White{$EndIf} );

  // RU: ������ ������� � �������� � ���, �� ����������� ���������(���� PR2D_SMOOTH).
  // EN: Render filled ellipses with smoothed edges(flag PR2D_SMOOTH).
  pr2d_Ellipse( 400 + 300, 300, 64, 256, {$IfDef OLD_METHODS}$FFFFFF, 75{$Else}newColor[1]{$EndIf}, 32, PR2D_FILL {or PR2D_SMOOTH });
  pr2d_Ellipse( 400 + 300, 300, 64, 256, {$IfDef OLD_METHODS}$000000, 255{$Else}cl_Black{$EndIf}, 32, PR2D_SMOOTH );

  pr2d_Ellipse( 400 - 300, 300, 64, 256, {$IfDef OLD_METHODS}$FFFFFF, 75{$Else}newColor[1]{$EndIf}, 32, PR2D_FILL or PR2D_SMOOTH );
  pr2d_Ellipse( 400 - 300, 300, 64, 256, {$IfDef OLD_METHODS}$000000, 255{$Else}cl_Black{$EndIf}, 32, PR2D_SMOOTH );
end;

procedure Timer;
begin
  INC( calc );
  if calc > 359 Then
    calc := 0;
  points[ calc ].X := 400 + m_Cos( calc ) * ( 96 + random( 32 ) );
  points[ calc ].Y := 300 + m_Sin( calc ) * ( 96 + random( 32 ) );
end;

Begin
  TimeStart := timer_Add( @Timer, 16, t_Start );

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );

  wnd_SetCaption(utf8_Copy('05 - Primitives'));

  zgl_Init();
End.
