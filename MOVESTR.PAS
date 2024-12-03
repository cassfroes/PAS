(*************************************)
(* programa movestring - by Cassiano *)
(*************************************)

program movestring;
uses graph,crt;
var x,y:integer;
    k:real;
    tamanho:word;
    P:pointer;

procedure iniciagrafico;
var dr,modo,erro:integer;
begin
     dr:=detect;
     initgraph(dr,modo,'c:\tp5');
     erro:=GraphResult;
     if erro<>grOk then begin
                             write('Erro -',graphErrorMsg(erro));
                             halt;
                        end;
end;


procedure escreve;
var str:string;
begin
     str:='String';
     settextjustify(lefttext,toptext);
     settextstyle(TriplexFont,horizdir,5);
     outtextxy(0,0,Str);
     tamanho:=ImageSize(0,0,textwidth(str),textheight(str));
     getmem(P,tamanho);
     getimage(0,0,textwidth(Str),textheight(Str)+10,P^);
     clearviewport;
end;

(***********************************)
begin
     repeat
     iniciagrafico;setcolor(yellow);
     escreve;
     x:=0;y:=1;k:=1;
     PutImage(x,y,P^,XORPut);
     while y<getmaxy do
         begin
             PutImage(x,y,P^,XORPut);
             y:=round(15*K*K/2);x:=x+10;
             sound(500+y*3);
             k:=k+0.13;
             PutImage(x,y,P^,XORPut);
         end;
         sound(50);delay(200);nosound;
     until keypressed;
     closegraph;
end.