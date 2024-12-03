            (*    programa calculadora   *)
            (*   Cassiano Lustosa Fr¢es  *)

program calculadora;
uses graph;
var maxx,maxy:integer;

procedure abregrafico;
var x,y:integer;
begin
     x:=detect;
     initgraph(x,y,'c:\bp\bgi');
     maxx:=getmaxx;maxy:=getmaxy;
end;

(******  desenha  calculadora ******)
procedure desenha(x0,y0:integer);
var a:integer;
begin
     setcolor(lightgray);
     bar3d(x0+5,y0+5,x0+(maxx div 4)-5,y0+(maxy div 2)-5,5,true);
     setcolor(black);
     for a:=y0+14 to y0+45 do
         line(x0+10,a,x0+(maxx div 4)-10,a);
     setcolor(magenta);
     settextjustify(bottomtext,righttext);
     settextstyle(smallfont,horizdir,4);
     outtextxy(x0+10,y0+4,'calculadora');
     a:=x0+15;
     setcolor(blue);
     while a<(x0+maxx div 4 - 10) do           (*linhas verticais*)
           begin
                line(a,y0+50,a,y0+(maxy div 2)-15);
                a:=a+25;
           end;
     a:=y0+50;
     while a<(y0+maxy div 2 -10) do            (*linhas horizontais*)
           begin
                line(x0+15,a,x0+maxx div 4 -20,a);
                a:=a+25;
           end;
end;

(************** main ***************)
begin
     abregrafico;
     desenha(100,100);
     readln;
     closegraph;
end.