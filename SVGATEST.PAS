Program X;
Uses Crt,Graph,dos;
var i,a:Integer;

{$I svga256.inc}

procedure Inicia_SVGA;
var
  AutoDetect : pointer;
  erro, GraphMode, GraphDriver, x : integer;

{$F+}					(* Forca chamadas longas *)
function DetectVGA : Integer;
var Vid : Integer;
begin
   VID  := 4;
   clrscr;
  DetectVGA := Vid;
end;
{$F-}

begin
  AutoDetect := @DetectVGA;
  GraphDriver := InstallUserDriver('SVGA256',AutoDetect);
  erro := graphresult;
  if erro <> 0 then
     begin
          writeln ( 'Erro : ' , grapherrormsg ( erro ) );
          readln;
          halt;
     end;
  GraphDriver := Detect;
  InitGraph(GraphDriver,GraphMode,'');
  erro := graphresult;
  if erro <> 0 then
     begin
          writeln ( 'Erro : ' , grapherrormsg ( erro ) );
          readln;
          halt;
     end;
end;

begin
inicia_svga;
a:=16;
i:=1;
repeat
setfillstyle(1,a);
bar(i,1,i+14,767);
i:=i+14;
a:=a+1;
until a=255;
repeat until keypressed;
closegraph;
end.

