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
     LePCX('c:\cassiano\ufrj1',100,30);
     for i:=1 to 20 do
         begin
         { degrade branco-preto - moldura da imagem }
         setRGBpalette(i,63-i*3,63-i*3,63-i*3);
         setcolor(i);
         rectangle(110-i,32-i,219+i,getmaxy-298+i);
         end;
    for i:=1 to 20 do
         begin
         { degrade da janela }
         setfillstyle(2,20-i);
         bar(2+i,200+i*3,636-i,204+i*3);
         bar(2+i,480-i*3,636-i,476-i*3);

         bar(2+i,204+i*3,3+i,480-i*3);
         bar(636-i,204+i*3,632-i,480-i*3);
         end;
    setfillstyle(1,1);
    bar(22,260,616,420);
     { cor da letra dentro da janela }
     setRGBpalette(100,30,0,0);
     setRGBpalette(21,60,0,0);

     setcolor(21);
     setlinestyle(0,0,Thickwidth);
     rectangle(0,0,getmaxx,getmaxy);

     setfillstyle(solidfill,20);
     setcolor(255);
     settextstyle(installuserfont('lcom'),horizdir,4);
     settextjustify(centertext,toptext);
     outtextxy(400,35,'Universidade');
     outtextxy(400,75,'Federal do');
     outtextxy(400,115,'Rio de Janeiro');
     outtextxy(401,35,'Universidade');
     outtextxy(401,75,'Federal do');
     outtextxy(401,115,'Rio de Janeiro');

     settextjustify(centertext,toptext);
     settextstyle(installuserfont('tscr'),horizdir,4);
     setusercharsize(2,3,1,1);
     setcolor(100);
         outtextxy(320,280,'Circuitos L¢gicos');
         outtextxy(320,281,'Circuitos L¢gicos');
     settextstyle(defaultfont,horizdir,1);
     settextjustify(lefttext,toptext);
     outtextxy(100,350,'Autores : Cassiano Lustosa Fr¢es');
     outtextxy(100,365,'        em abril / 1994');
     repeat until keypressed;
     readkey;
     beep(100,30);
     beep(500,20);
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
     if contador mod 20=0 then delay(2);
{     if contador mod 100=0 then
                 if cor<0 then beep(contador div 2,5)
                          else beep((3073-contador)div 2,5);}
     until contador=-1;
{     repeat until keypressed;
     readkey;}
end;

Begin
     Inicializa_Grafico;
  {   fechatela2(255);}
     desenhatela;
     fechatela2(-1);
     fechatela2(20);
     FimGrafico;
end.
