program teste;
uses graph,graphnce,crt;


Procedure Inicializa_grafico;
var dr,mo:integer;
begin
     dr:=svga;mo:=svgamed256;
     ModoGrafico(dr,mo);

end;

procedure beep(s,t:integer);
begin
     sound(s);
     delay(t);
     nosound;
end;
Procedure desenhatela;
var i:integer;
begin
     setfillstyle(solidfill,255);
     bar(0,0,getmaxx,getmaxy);

     LePCX('d:\cassiano\marcacol',12,12);

     for i:=1 to 10 do
         begin
         { degrade branco-preto }
         setRGBpalette(i,63-i*6,63-i*6,63-i*6);
         setcolor(i);
         rectangle(10-i,10-i,getmaxx-10+i,getmaxy-10+i);

         { degrade branco-vinho da janela }
         SetRGBpalette(i+10,60-i*4,60-i*6,60-i*6);
         setcolor(i+10);
         rectangle(30+i,245+i,getmaxx-30-i,getmaxy-30-i);
         end;
     { cor da letra dentro da janela }
     setRGBpalette(21,60,63,0);

     setfillstyle(solidfill,20);
     bar(42,257,getmaxx-42,getmaxy-42);
     setcolor(245);
     settextstyle(installuserfont('lcom'),horizdir,1);
     setusercharsize(4,3,5,4);
     settextjustify(lefttext,toptext);
     outtextxy(250,60,'Universidade');
     outtextxy(250,100,'Federal do');
     outtextxy(250,140,'Rio de Janeiro');
     outtextxy(250,61,'Universidade');
     outtextxy(250,101,'Federal do');
     outtextxy(250,141,'Rio de Janeiro');

     settextjustify(centertext,toptext);
     settextstyle(installuserfont('tscr'),horizdir,4);
     setcolor(21);
     outtextxy(320,260,'Mapas de Karnaugh');
     outtextxy(320,300,'Circuitos L¢gicos');
     settextstyle(smallfont,horizdir,5);
     settextjustify(lefttext,toptext);
     outtextxy(100,370,'Autor : Cassiano Lustosa Fr¢es');
     outtextxy(100,390,'        em abril / 1994');
     repeat until keypressed;
     readkey;
     beep(100,30);
     beep(500,20);
end;

Procedure fechatela(cor:integer);
var tabela:array[0..63,0..47]of boolean;
    x,y:integer;
    contador:integer;
begin
     contador:=0;
     if cor<0 then
     begin
     for x:=22 to 45 do
         setRGBpalette(x,x-22,45-x,70-x);
     for x:=45 to 69 do
         setRGBpalette(x,x-22,x-45,70-x);
     end
     else
     setfillstyle(solidfill,cor);
     for x:=0 to 63 do
         for y:=0 to 47 do tabela[x][y]:=false;
     repeat
           repeat
           x:=random(64);
           y:=random(48);
           until not tabela[x][y];
     tabela[x][y]:=true;
     if cor<=0 then setfillstyle((random(2)+4),y+22);
     bar(x*10,y*10,x*10+9,y*10+9);
     contador:=contador+1;
     if contador mod 120=0 then beep((x+y)*40,2);
     until contador=3072;
{     repeat until keypressed;
     readkey;}
end;


Procedure fechatela2(cor:integer);
type tipoxy = record
              x,y:integer;
              end;
var tabela:array[0..3071]of tipoxy;
    x,y:integer;
    contador:integer;
    rand:integer;
begin
     contador:=-1;
     if cor<0 then
     begin
     for x:=22 to 45 do
         setRGBpalette(x,x-22,45-x,70-x);
     for x:=45 to 69 do
         setRGBpalette(x,x-22,x-45,70-x);
     end
     else
     setfillstyle(solidfill,cor);
     for x:=0 to 63 do
         for y:=0 to 47 do
                        begin
                        contador:=contador+1;
                        tabela[contador].x:=x;
                        tabela[contador].y:=y;
                        end;
     repeat
     rand:=random(contador);
     if cor<=0 then setfillstyle((random(2)+4),tabela[rand].y+22);
     bar(tabela[rand].x*10,tabela[rand].y*10,tabela[rand].x*10+9,
                                             tabela[rand].y*10+9);
     tabela[rand]:=tabela[contador];
     contador:=contador-1;
{     if contador mod 120=0 then beep((tabela[contador].x+
                                       tabela[contador].y)*30,5);}
{     if contador mod 100=0 then
                 if cor<0 then beep(contador div 2,5)
                          else beep((3073-contador)div 2,5);}
     until contador=-1;
{     repeat until keypressed;
     readkey;}
end;

Begin
     Inicializa_Grafico;
     fechatela2(255);
     desenhatela;
     fechatela2(-1);
     fechatela2(10);
     readln;
     FimGrafico;
end.
