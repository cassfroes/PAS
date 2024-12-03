program moveball;
uses graph,crt;
var P:pointer;



Procedure inicia_grafico;
var dr,mo:integer;
begin
     dr:=detect;
     initgraph(dr,mo,'');
end;



Procedure tela;
var i:integer;
begin
     randomize;
     for i:=1 to 20 do begin
          setfillstyle(random(12),random(16));
          fillellipse(random(640),random(480),30,50);
          end;
end;




Procedure grava_imagem;
var tamanho:longint;
begin
     setfillstyle(8,magenta);
     fillellipse(10,10,10,10);
     tamanho:=Imagesize(0,0,20,20);
     getmem(P,tamanho);
     getImage(0,0,20,20,P^);
     cleardevice;
end;


Procedure move;
var x,y:integer;
    incx,incy:integer;
begin
     x:=112;y:=234;incx:=6;incy:=6;
     repeat
           PutImage(x,y,P^,XORPut);
           if x>=getmaxx then incx:=-6;
           if x<=0 then incx:=6;
           if y>=getmaxy then incy:=-6;
           if y<=0 then incy:=6;
{           PutImage(x,y,P^,XORPut);}
           x:=x+incx;
           y:=y+incy;
     Until keypressed;
end;

BEGIN
     inicia_grafico;
     grava_imagem;
     tela;
     move;
END.


