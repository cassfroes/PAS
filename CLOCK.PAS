(*    SIMULACAO GRAFICA DE UM RELOGIO   *)
(*    CASSIANO LUSTOSA FROES  -  1993   *)


Program CLOCK;

Uses Crt,Graph,dos;
var h,m,s,c,segaux,haux,maux:Word;
    centrox,centroy:integer;

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


Procedure Desenha_Mostrador;
var a:integer;
    i:real;
begin
     for a:=1 to 100 do
     begin
         setRGBpalette(a div 2,a div 2,0,a div 3);setcolor(a div 2);
         ellipse(getmaxx div 2,getmaxy div 2,0,360,500-a*2,290-a div 6);
     end;

     settextjustify(centertext,centertext);
     settextstyle(Triplexfont,horizdir,5);
     setRGBpalette(55,10,10,10);setfillstyle(solidfill,55);
     fillellipse(centrox,centroy,300,274);
     setRGBpalette(51,30,63,0);setcolor(54);
     setRGBpalette(54,30,30,30);
     a:=0;
     i:=0;
     while i<=2*Pi do
           begin
           circle(round(centrox+200*cos(i)),round(centroy+200*sin(i)),3);
           i:=i+Pi/6;
           end;
     setcolor(54);
     repeat
     outtextxy(getmaxx div 2+a,getmaxy div 2 -235+a,'XII');
     outtextxy(getmaxx div 2+a,getmaxy div 2 +225+a,'VI');
     outtextxy(getmaxx div 2-250+a,getmaxy div 2-4+a,'IX');
     outtextxy(getmaxx div 2+250+a,getmaxy div 2-4+a,'III');
     a:=a+1;if a=4 then setcolor(51);
     until a>4;
end;

Procedure Desenha_ponteiros;
var hora,minuto,segundo,cent:word;
    beta:real;
begin
     setcolor(55);
     setlinestyle(solidln,0,normwidth);
     beta:=(segaux*2*Pi/60)-Pi/2;
     line(centrox,centroy,
               centrox+(round(190*cos(beta))),
               centroy+(round(190*sin(beta))));
     setlinestyle(solidln,0,thickwidth);
     beta:=(haux mod 12 + maux/60 + segaux/3600)*2*Pi/12-Pi/2;
     line(centrox,centroy,centrox+(round(100*cos(beta))),
                         centroy+(round(100*sin(beta))));
     beta:=(maux + segaux/60)*2*Pi/60-Pi/2;
     line(centrox,centroy,centrox+(round(190*cos(beta))),
                         centroy+(round(190*sin(beta))));

     setcolor(53);setlinestyle(solidln,0,thickwidth);
     beta:=(h mod 12 + m/60 + s/3600)*2*Pi/12-Pi/2;
     line(centrox,centroy,centrox+(round(100*cos(beta))),
                         centroy+(round(100*sin(beta))));
     beta:=(m + s/60)*2*Pi/60-Pi/2;
     line(centrox,centroy,centrox+(round(190*cos(beta))),
                         centroy+(round(190*sin(beta))));
     setcolor(52);
     beta:=(s*2*Pi/60)-Pi/2;
     setlinestyle(solidln,0,normwidth);
     line(centrox,centroy,
               centrox+(round(190*cos(beta))),
               centroy+(round(190*sin(beta))));
     sound(50);delay(5);sound(10);delay(10);nosound;
end;




BEGIN
     inicia_SVGA;
     centrox:=getmaxx div 2;centroy:=getmaxy div 2;
     setRGBpalette(0,0,0,0);setRGBpalette(52,63,0,20);
     setRGBpalette(53,63,63,0);
     desenha_mostrador;
     Gettime(h,m,s,c);segaux:=s;haux:=h;maux:=m;
     repeat
     Gettime(h,m,s,c);
     if segaux<>s then
      begin
         desenha_ponteiros;
         segaux:=s;haux:=h;maux:=m;
      end;
     until keypressed;
END.

