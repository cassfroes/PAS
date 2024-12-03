uses graph,graphnce,crt;
var boleano:byte;
{$F+}
function detectmode:integer;
begin
     detectmode:=3;
end;
{$F-}
procedure inicgrafico;
var driver,modo,testdriver:integer;
begin
     modografico(vga,def);

(*     testdriver:=installuserdriver('svga256',@detectmode);
     if graphresult<>grok then halt;
     driver:=detect;
     modo:=0;
     initgraph(driver,modo,'c:\bp\bgi');
     if graphresult<>grok then halt;*)
end;

function confirma(x,y:integer;txt1,txt2,txt3,txt4:string):byte;
var xm,ym,bm:integer;
    ch:char;
procedure escreveok;
begin
     box_cria(x+10,y+50,x+108,y+80,'    O k');
     setlinestyle(solidln,0,thickwidth);
     setcolor(darkgray);
     line(x+25,y+62,x+28,y+72);line(x+28,y+72,x+50,y+62);
     setcolor(lightgreen);
     line(x+22,y+60,x+25,y+70);line(x+25,y+70,x+47,y+60);
end;
procedure escrevecancela;
begin
     setcolor(lightred);
     box_cria(x+110,y+50,x+208,y+80,'   Cancela');
     setlinestyle(solidln,0,thickwidth);
     setcolor(darkgray);
     line(x+123,y+60,x+144,y+73);
     line(x+141,y+58,x+125,y+74);
     setcolor(lightred);
     line(x+120,y+57,x+141,y+70);
     line(x+138,y+56,x+122,y+72);
end;
procedure pressok;
begin
     sound(500);delay(100);nosound;
     box_press(x+10,y+50,x+108,y+80);
     confirma:=0;
end;
procedure presscancela;
begin
     sound(100);delay(100);nosound;
     box_press(x+110,y+50,x+208,y+80);
     confirma:=1;
end;

begin
     setfillstyle(solidfill,darkgray);
     bar(x,y,x+219,y+85);
     outtextxy(x+8,y+5,txt1);outtextxy(x+8,y+15,txt2);
     outtextxy(x+8,y+25,txt3);outtextxy(x+8,y+35,txt4);
     setcolor(yellow);
     rectangle(x,y,x+219,y+85);
     escreveok;
     escrevecancela;
     repeat
     bm:=lemouse(xm,ym)
     until(bm<>0);
        if(xm>x+10)and(xm<x+108)and(ym>y+50)and(ym<y+80)then pressok
        else if(xm>x+110)and(xm<x+208)and(ym>y+50)and(ym<y+80)then presscancela
        else confirma:=2;

end;


{-------------------------------------}
{ corpo principal; confirma retorna : }
{ 0 : se clicou OK                    }
{ 1 : se clicou CANCELA               }
{ 2 : se clicou fora dos botäes       }
BEGIN
     inicgrafico;
     inicmouse;

     boleano:=confirma(100,150,'ATENCAO','','Sair do programa causar ','perda de dados');
     fimgrafico;
END.