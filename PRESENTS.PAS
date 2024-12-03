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
   VID  := 2;
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
  InitGraph(GraphDriver,GraphMode,'c:\cassiano');
  erro := graphresult;
  if erro <> 0 then
     begin
          writeln ( 'Erro : ' , grapherrormsg ( erro ) );
          readln;
          halt;
     end;
end;

Function now:real;
var h,m,s,c:word;
begin
     gettime(h,m,s,c);
     now:=h*3600+m*60+s+c/100;
end;


Procedure apresenta;
var i:integer;
    x,y:integer;
    j,cor:integer;
    ind:integer;
    t0,dt:real;
begin
     ind:=0;
     for i:=1 to 60 do begin
                       setRGBpalette(i+65,0,0,i);
                       setRGBpalette(i,0,0,0);
                       end;
     setRGBpalette(61,0,0,0);
     setRGBpalette(63,0,0,0);
     setRGBpalette(126,63,0,0);
     setRGBpalette(62,0,0,0);
     setRGBpalette(127,0,63,0);
     setRGBpalette(128,0,63,63);
     setRGBpalette(129,0,0,0);
     for j:=1 to 60 do
         begin
         setfillstyle(solidfill,j);
         bar(20,50+(j*6),320,55+(j*6));
         end;
     setcolor(62);setlinestyle(solidln,0,thickwidth);
     moveto(20,200);lineto(100,200);lineto(120,150);
     lineto(140,250);lineto(160,150);lineto(200,350);lineto(320,350);
     setcolor(61);
     settextstyle(Triplexfont,horizdir,9);
     outtextxy(72,150,'IRCT');outtextxy(72,151,'IRCT');
     outtextxy(70,150,'IRCT');
     outtextxy(71,150,'IRCT');
     outtextxy(71,151,'IRCT');
     outtextxy(70,151,'IRCT');
     setcolor(63);
     settextjustify(centertext,centertext);
     settextstyle(triplexfont,horizdir,4);
     outtextxy(190,245,'p');
     outtextxy(205,235,'a');
     outtextxy(220,225,'i');
     outtextxy(235,215,'n');
     outtextxy(250,205,'t');
     settextstyle(smallfont,horizdir,5);
     setcolor(67);outtextxy(480,100,'Universidade Federal');
     outtextxy(480,120,'do Rio de Janeiro');
     outtextxy(480,160,'Editor Gr fico  -  outubro / 1993');
     outtextxy(480,180,'autor : Cassiano Lustosa Fr¢es');
     t0:=now;
     randomize;
     repeat
         Y:=56+random(360);x:=20+random(300);
         j:=getpixel(x,y);
         if (j<=63) and(j>10)then
           putpixel(x,y,j+65);
         dt:=now;
     until (dt=t0+5);
     setRGBpalette(61,63,0,0);
     setRGBpalette(62,0,63,0);
     setRGBpalette(63,0,63,63);
     for i:=1 to 60 do
     for j:=i to 60 do begin
                       setRGBpalette(j,0,0,i);
                       if i=1 then setRGBpalette(67,j,j,j);
                       end;

end;


BEGIN
     Inicia_svga;
     apresenta;
     sound(500);delay(50);nosound;
     readln;
     closegraph;
END.