program teste;

uses graph,crt,graphnce;
type tipotab=record
                         x,y:integer;
                         letra:boolean;
                         end;
var corletra:integer;
    tab1:array[0..3072]of tipotab;
procedure inic_graf;
var x,y:integer;
begin
     modografico(svga,svgamed256);
end;

procedure escreve;
var x,y,vx,vy:integer;
    conta:integer;
begin
     settextjustify(centertext,centertext);
     settextstyle(defaultfont,horizdir,25);
     setcolor(white);
     outtextxy(getmaxx div 2,getmaxy div 2,'CLA');
     corletra:=white;

     conta:=0;
     for x:=0 to 63 do
         for y:=0 to 47 do
             begin
             if getpixel(x*10+3,y*10+3)=white
               then tab1[conta].letra:=true
               else tab1[conta].letra:=false;
             tab1[conta].x:=x;
             tab1[conta].y:=y;
             conta:=conta+1;
             end;
end;

procedure pinta;
var x,y:integer;
    vx,vy:integer;
    novaletra,novofundo:integer;
    pinta:integer;
    conta:integer;
    rand:integer;
    tab:array[0..3072]of tipotab;
    estilo:integer;
begin
     conta:=0;
     for x:=0 to 63 do
         for y:=0 to 47 do
             begin
             tab[conta]:=tab1[conta];
             tab[conta].x:=x;
             tab[conta].y:=y;
             conta:=conta+1;
             end;
   (**)
   (*inicio do loop*)
     randomize;
     novofundo:=random(15);
     repeat
     novaletra:=random(15);
     until (novaletra<>novofundo);
     repeat
{     pinta:=novofundo;}
     rand:=random(conta);
{     for vx:=(tab[rand].x*10) to (tab[rand].x*10+9)do
         for vy:=(tab[rand].y*10) to (tab[rand].y*10+9)do
             if getpixel(vx,vy)=corletra then pinta:=novaletra;}
             {if getpixel(tab[rand].x*10+5,tab[rand].y*10+5)=corletra}
             if tab[rand].letra then begin
                                     pinta:=novaletra*10+tab[rand].x;
                                     estilo:=solidfill;
                                     end
                else begin pinta:=novofundo*10+tab[rand].y;
                           estilo:=random(2)+4;
                end;

     setfillstyle(estilo,pinta);
     bar(tab[rand].x*10,tab[rand].y*10,tab[rand].x*10+9,tab[rand].y*10+9);
     tab[rand]:=tab[conta];
     conta:=conta-1;
     until (conta=0)or (keypressed);
     corletra:=novaletra;
end;

begin
     inic_graf;
     escreve;
     repeat
     pinta;
     until keypressed;
end.