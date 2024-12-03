{################################################}
{#    Universidade Federal do Rio de Janeiro    #}
{################################################}

program cg3;

uses crt,graph,mouse;

var x, y, b,                        { x/y:posicao do mouse; b:botao press.}
    cor1,cor2,cor3,cor4:integer;    { cores da box }
    cor_linha,cor_tinta:integer;
Procedure Inicia_grafico;
var dr,mo:integer;
begin
     dr:=detect;
     InitGraph(dr,mo,'c:\bp\bgi');
end;

Procedure definecorbox(c1,c2,c3,c4:integer);
begin
     cor1:=c1;cor2:=c2;cor3:=c3;cor4:=c4;
end;

Procedure box_cria(x1,y1,x2,y2:integer;titulo:string);
begin
     PMO_semcursormouse;
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
     PMO_comcursormouse;
end;

Procedure box_press(x1,y1,x2,y2:integer);
var P,P1:pointer;
    tam,tam1:word;
begin
     tam:=ImageSize(x1+1,y1+1,x2-1,y2-1);
     GetMem(P,tam);
     tam1:=ImageSize(x1,y1,x2,y2);
     GetMem(P1,tam1);
     PMO_semcursormouse;
     GetImage(x1,y1,x2,y2,P1^);
     GetImage(x1+1,y1+1,x2-1,y2-1,P^);
     PutImage(x1+2,y1+2,P^,NormalPut);
     setcolor(cor3);rectangle(x1,y1,x2,y2);
     PMO_comcursormouse;
     PMO_soltamouse;
     PMO_semcursormouse;
     PutImage(x1,y1,P1^,NormalPut);
     freemem(P,tam);
     freemem(P1,tam1);
     PMO_comcursormouse;
end;

Function le_tecla(posx,posy,x1,y1,x2,y2:integer):string;
var aux:char;
    strg:string;
    x0:integer;
begin
     while keypressed do aux:=readkey;
     x0:=posx;
     setcolor(4);
     setfillstyle(solidfill,5);
     strg:='';
     repeat
     repeat
       bar(posx-4,posy-5,posx+5,posy+5);outtextxy(posx,posy,#177);delay(50);
       bar(posx-4,posy-5,posx+5,posy+5);outtextxy(posx,posy,#178);
       delay(50);
       pmo_readmouse(x,y,b);
     until (keypressed) or ((b=1)and(x>x1)and(x<x2)and(y>y1)and(y<y2));
     bar(posx-4,posy-5,posx+5,posy+5);
     if ((b=1)and(x>x1)and(x<x2)and(y>y1)and(y<y2)) then aux:=#27
              else aux:=readkey;
     if (aux<>#13)and(aux<>#27)and(aux<>#8)then
                      begin outtextxy(posx,posy,aux);
                            posx:=posx+8;
                            strg:=strg+aux;
                            end;
     if aux=#8 then begin
                   if posx> x0 then posx:=posx-8;
                   delete(strg,length(strg),1);
                   bar(posx-4,posy-5,posx+5,posy+5);
                   end;
     until (aux=#13) or (aux=#27);
     if (aux=#27) then begin
                       box_press(x1,y1,x2,y2);
                       le_tecla:=#27;
                       end
     else le_tecla:=strg;
 end;

Procedure define_cor;
var pal:palettetype;
begin
     getpalette(pal);
     SetRGBpalette(pal.colors[1],60,60,60);
     SetRGBpalette(pal.colors[2],25,25,25);
     setRGBpalette(pal.colors[3],15,0,40);
     setRGBpalette(pal.colors[4],5,15,15);
     setRGBpalette(pal.colors[5],45,45,45);
     setRGBpalette(pal.colors[7],5,15,15);
     setRGBpalette(pal.colors[8],30,30,30);
     setRGBpalette(pal.colors[12],0,0,63);
     setRGBpalette(pal.colors[10],0,63,0);
     setRGBpalette(pal.colors[11],63,63,0);
     setRGBpalette(pal.colors[13],0,0,63);
     setRGBpalette(pal.colors[14],30,0,30);
     cor_linha:=14;
     cor_tinta:=13;
end;

Procedure faz_tela;
begin
     define_cor;
     definecorbox(1,2,4,0);
     box_cria(0,0,getmaxx,getmaxy,'');     (* tela toda *)
     definecorbox(2,1,5,0);
     box_cria(10,getmaxy-30,550,getmaxy-10,''); (*comentario*)
     box_cria(10,35,550,getmaxy-35,'');     (* janela *)
     definecorbox(1,2,5,3);
     box_cria(11,10,100,30,'?');
     box_cria(101,10,190,30,'Arquivo');
     box_cria(191,10,280,30,'Editar');
     box_cria(281,10,370,30,'Cores');
     box_cria(371,10,460,30,'Sair');
     box_cria(461,10,550,30,'^');
     box_cria(555,35,getmaxx-5,65,'');  (*ponto*)
     box_cria(555,70,getmaxx-5,100,''); (*reta*)
     box_cria(555,105,getmaxx-5,135,'');(*retangulo*)
     box_cria(555,140,getmaxx-5,170,'');(*circulo*)
     box_cria(555,175,getmaxx-5,205,'Pintar');
     box_cria(555,210,getmaxx-5,240,'Texto');
       setlinestyle(solidln,1,thickwidth);
       circle(595,50,2);
       line(575,80,620,90);
       rectangle(575,113,615,127);
       circle(595,155,10);
       setlinestyle(solidln,1,normwidth);
     definecorbox(1,2,cor_linha,5);
     box_cria(555,405,getmaxx-5,435,'Linha');
     definecorbox(1,2,cor_tinta,5);
     box_cria(555,440,getmaxx-5,getmaxy-10,'Tinta');
     definecorbox(1,2,5,3);
end;

Procedure ponto;
begin
     definecorbox(1,2,8,3);box_cria(555,35,634,65,'');
     PMO_semcursormouse;
     setlinestyle(solidln,1,thickwidth);circle(595,50,2);
     setlinestyle(solidln,1,normwidth);
     PMO_comcursormouse;
     setcolor(cor_linha);
     repeat PMO_readmouse(x,y,b) until b<>0;
     PMO_mudaforma(8,8,PMC_cruz);
     moveto(x,y);
     if b<>2 then
     repeat
     PMO_readmouse(x,y,b);
     if x>=547 then x:=547;
     if y>=getmaxy-38 then y:=getmaxy-38;
     if y<=38 then y:=38;
     if x<=13 then x:=13;
     if b=1 then begin
                 PMO_semcursormouse;
                 lineto(x,y);
                 PMO_comcursormouse;
                 end
                 else moveto(x,y);
     until b=2;
     box_press(555,35,634,65);
     definecorbox(1,2,5,3);box_cria(555,35,634,65,'');
     PMO_mudaforma(0,0,PMC_seta);
     PMO_semcursormouse;
     setlinestyle(solidln,1,thickwidth);circle(595,50,2);
     setlinestyle(solidln,1,normwidth);
     PMO_comcursormouse;
end;

Procedure reta;
var x1,x2,y1,y2:integer;
begin
     definecorbox(1,2,8,3);box_cria(555,70,634,100,'');
     PMO_semcursormouse;
     setlinestyle(solidln,1,thickwidth);line(575,80,620,90);
     setlinestyle(solidln,1,normwidth);
     PMO_comcursormouse;
     setcolor(cor_linha);
     repeat PMO_readmouse(x,y,b) until b<>0;
     x1:=x;y1:=y;
     x2:=x;y2:=y;
     PMO_mudaforma(8,8,PMC_cruz);
     {moveto(x,y);}
     if b<>2 then
     repeat
     PMO_readmouse(x,y,b);
     if x>=547 then x:=547;
     if y>=getmaxy-38 then y:=getmaxy-38;
     if y<=38 then y:=38;
     if x<=13 then x:=13;
     if b=1 then begin
                  setwritemode(XORput);
                  while b<>0 do begin
                  PMO_semcursormouse;
                  line(x1,y1,x2,y2);PMO_comcursormouse;
                   repeat
                   PMO_readmouse(x,y,b);
                   until (x<>x2)or(y<>y2)or(b=0);
                   PMO_semcursormouse;
                   line(x1,y1,x2,y2);PMO_comcursormouse;
                   x2:=x;y2:=y;
                                end;
                 setwritemode(copyPut);
                 PMO_semcursormouse;line(x1,y1,x,y);PMO_comcursormouse;
                 {PMO_esperamouse(x,y,b);}
                 x1:=x;y1:=y;
                 end;
     until b=2;
     box_press(555,70,634,100);
     definecorbox(1,2,5,3);box_cria(555,70,634,100,'');
     PMO_mudaforma(0,0,PMC_seta);
     PMO_semcursormouse;
     setlinestyle(solidln,1,thickwidth);line(575,80,620,90);
     setlinestyle(solidln,1,normwidth);
     PMO_comcursormouse;
end;
Procedure menu_sup;
begin
     if (x>10) and (x<100) then box_press(11,10,100,30);
     if (x>101)and (x<190) then box_press(101,10,190,30);
     if (x>191)and (x<280) then box_press(191,10,280,30);
     if (x>281)and (x<370) then box_press(281,10,370,30);
     if (x>461)and (x<550) then box_press(461,10,550,30);
end;

Procedure menu_lat;
begin
     if (y>35)and(y<65) then begin
                             box_press(555,35,634,65);
                             ponto;
                             exit;
                             end;
     if (y>70)and(y<100) then begin
                              box_press(555,70,634,100);
                              reta;
                              exit;
                              end;
     if (y>105)and(y<135) then box_press(555,105,634,135);
     if (y>140)and(y<170) then box_press(555,140,634,170);
     if (y>175)and(y<205) then box_press(555,175,634,205);
     if (y>210)and(y<240) then box_press(555,210,634,240);
end;

Begin
     Inicia_grafico;
     PMO_inimouse;
     faz_tela;
     repeat
     PMO_readmouse(x,y,b);
     if (b=1) then if (y<30) and(y>10) then menu_sup
                   else if (x>555)and(x<634) then menu_lat;
     until (b=1) and (y>=10) and (y<=30) and (x>371) and (x<460);
     box_press(371,10,460,30);
end.