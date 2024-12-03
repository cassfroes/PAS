{
        BUG:   A pilha deve ter 64k
         para que a tela possa ser empilhada !
}

uses graph,crt;

var video:array[0..64000]of byte absolute($A000):(0000);


{$F+}
function detectmode:integer;
begin
     detectmode:=0;
end;
{$F-}
procedure inicvideo;
var driver,modo,testdriver:integer;
begin
     testdriver:=installuserdriver('svga256',@detectmode);
     if graphresult<>grok then halt;
     driver:=detect;
     modo:=0;
     initgraph(driver,modo,'c:\bp\bgi');
     if graphresult<>grok then halt;
end;

procedure desenha;
var x,y:integer;
begin
     for x:=0 to 255 do
         for y:=0 to 199 do
             putpixel(x,y,y);
     repeat until keypressed;
     readkey;
end;

procedure ponto(x,y:integer;cor:byte);
begin
     video[y*320+x]:=cor;
end;

procedure pintatela;

var i:integer;
    x,y:integer;
    videobuf:array[0..64000]of byte;
begin
     for i:=16 to 31 do
     begin
     fillchar(video,64000,i);
     end;
     setcolor(red);
     for x:=10 to 100 do
         for y:=50 to 54 do
         begin
         line(320,0,x*3,100);
         ponto(x,y,150);
         end;
     ponto(300,195,10);
     setcolor(green);
     outtextxy(100,150,'teste de v¡deo');
     repeat until keypressed;
     readkey;
     move(video,videobuf,64000);
     cleardevice;
     repeat until keypressed;
     readkey;
     move(videobuf,video,64000);
     repeat until keypressed;
     readkey;
end;
procedure apagatela;
var tela:array[0..16000]of record x,y:integer; end;
    xc,yc,rand,contador:integer;
begin
     contador:=0;
     for xc:=0 to 159 do
         for yc:=0 to 99 do
             begin
                  tela[contador].x:=xc;
                  tela[contador].y:=yc;
                  inc(contador);
             end;
     randomize;
     setfillstyle(solidfill,black);
     repeat
     rand:=random(contador);
     bar(tela[rand].x*2,tela[rand].y*2,tela[rand].x*2+1,
                        tela[rand].y*2+1);
     tela[rand]:=tela[contador];
     dec(contador);
     sound(contador div 20);
     until contador=0;
     nosound;
end;
begin
     inicvideo;
     desenha;
     pintatela;
     apagatela;
     delay(100);
     closegraph;
end.