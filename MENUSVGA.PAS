Program Xyznnh;
Uses Crt,Graph,Dos;
var a,b:integer;

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



Begin
     Inicia_SVGA;
     for a:=1 to 126 do setRGBpalette(a,a div 2,10,50);
     a:=0;
     repeat
           for b:=1 to 64 do
              begin
                 setfillstyle(1,b+a div 2);
                 bar(a*8,b*12,a*8+7,b*12+11);
              end;
           a:=a+1
     until a>=126;
     settextjustify(lefttext,toptext);
     settextstyle(TriplexFont,Horizdir,5);
     setviewport(341,200,683,580,false);
     setRGBpalette(129,40,40,50);
       setRGBpalette(127,15,15,15);
       setRGBpalette(128,63,63,63);
       setcolor(127);
       outtextxy(4,0,' *** MENU ***');
       outtextxy(4,70,'Cassiano');
       outtextxy(4,110,'esteve');
       outtextxy(4,150,'aqui !!!');
       setcolor(128);
       outtextxy(8,4,' *** MENU ***');
       outtextxy(8,74,'Cassiano');
       outtextxy(8,114,'esteve');
       outtextxy(8,154,'aqui !!!');
     sound(500);delay(100);nosound;
     repeat until keypressed;
     closegraph;
End.
