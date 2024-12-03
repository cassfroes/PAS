{################################################}
{#    Universidade Federal do Rio de Janeiro    #}
{################################################}

unit clmenu;

INTERFACE

uses crt,graph,graphnce;

procedure box_definecor(c1,c2,c3,c4:integer);
procedure box_cria(x1,y1,x2,y2:integer;titulo:string);
procedure box_press(x1,y1,x2,y2:integer);
function le_strg(x1,y1,numcaract:integer):string;

IMPLEMENTATION

var    cor1,cor2,cor3,cor4:integer;    { cores da box }

Procedure box_definecor(c1,c2,c3,c4:integer);
begin
     cor1:=c1;cor2:=c2;cor3:=c3;cor4:=c4;
end;

Procedure box_cria(x1,y1,x2,y2:integer;titulo:string);
begin
     setcolor(cor1);moveto(x1,y2);
     lineto(x1,y1);lineto(x2,y1);
     moveto(x2-2,y1+2);
     lineto(x1+2,y1+2);lineto(x1+2,y2-2);
     setcolor(cor2);
     lineto(x2-2,y2-2);lineto(x2-2,y1+2);
     moveto(x2,y1);lineto(x2,y2);lineto(x1,y2);
     setcolor(cor3);
     rectangle(x1+1,y1+1,x2-1,y2-1);
     setfillstyle(solidfill,cor3);
     bar(x1+3,y1+3,x2-3,y2-3);
     settextjustify(centertext,centertext);setcolor(cor4);
     outtextxy((x1+x2)div 2,(y1+y2)div 2,titulo);
end;

Procedure box_press(x1,y1,x2,y2:integer);
var P,P1:pointer;
    tam,tam1:word;
    k:integer;
    x,y:integer;
    k1:integer;
begin
     k1:=lemouse(x,y);
     semcursormouse;
     tam:=ImageSize(x1+1,y1+1,x2-1,y2-1);
     GetMem(P,tam);
     tam1:=ImageSize(x1,y1,x2,y2);
     GetMem(P1,tam1);
     GetImage(x1,y1,x2,y2,P1^);
     GetImage(x1+1,y1+1,x2-1,y2-1,P^);
     PutImage(x1+2,y1+2,P^,NormalPut);
     setcolor(cor3);rectangle(x1,y1,x2,y2);
     comcursormouse;
     repeat k:=lemouse(x,y) until (k<>k1)or(x<x1)
                            or(y<y1)or(x>x2)or(y>y2);
     semcursormouse;
     PutImage(x1,y1,P1^,NormalPut);
     comcursormouse;
     freemem(P,tam);
     freemem(P1,tam1);
end;

Function le_strg(x1,y1,numcaract:integer):string;
var aux:char;
    strg:string;
    x0:integer;
begin
     while keypressed do aux:=readkey;
     x0:=x1;
     setcolor(4);
     setfillstyle(solidfill,5);
     strg:='';
     repeat
     repeat
       bar(x1-4,y1-5,x1+5,y1+5);outtextxy(x1,y1,#177);delay(50);
       bar(x1-4,y1-5,x1+5,y1+5);outtextxy(x1,y1,#178);
       delay(50);
     until (keypressed);
     bar(x1-4,y1-5,x1+5,y1+5);
     aux:=readkey;
     if (aux<>#13)and(aux<>#27)and(aux<>#8)and(length(aux)<numcaract)then
                      begin outtextxy(x1,y1,aux);
                            x1:=x1+8;
                            strg:=strg+aux;
                            end;
     if aux=#8 then begin
                   if x1> x0 then x1:=x1-8;
                   delete(strg,length(strg),1);
                   bar(x1-4,y1-5,x1+5,y1+5);
                   end;
     until (aux=#13) or (aux=#27);
     if (aux=#27) then begin
                       le_strg:=#27;
                       end
     else le_strg:=strg;
 end;

end.