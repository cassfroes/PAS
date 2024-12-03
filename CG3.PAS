{################################################}
{#      tra‡ador de graficos de fun‡oes         #}
{#    Universidade Federal do Rio de Janeiro    #}
{# Computa‡ao Grafica I-3a. lista de exercicios #}
{################################################}

program cg3;

uses crt,graph,PM_MOUSE;

type
    tipoxptr = ^tipox;
    tipoyptr = ^tipoy;
    tipoy    = record
               valor     : real;
               proximoy  : tipoyptr;
               end;
    tipox    = record
               valor     : real;
               primeiroy : tipoyptr;
               ultimoy   : tipoyptr;
               proximox  : tipoxptr;
               end;

var x, y, b,                        { x/y:posicao do mouse; b:botao press.}
    numero_de_curvas   :   integer;
    xminm, yminm,
    xmaxm, ymaxm,
    xmint, ymint       :   real;  { coord. do mundo e da tela }
    apontax,
    primeirox,ultimox  :   tipoxptr;
    apontay            :   tipoyptr;
    xesc, yesc,
    intervalox,
    intervaloy,
    tracinhox,tracinhoy:   real;
    titulox,tituloy,
    titulografico      :   string;
    ja_leu,ja_plotou   :   boolean;

Procedure Inicia_grafico;
var dr,mo:integer;
begin
     dr:=detect;
     InitGraph(dr,mo,'c:\bp\bgi');
end;

Procedure box_cria(x1,y1,x2,y2,cor1,cor2,cor3,cor4:integer;
                                        titulo:string);
begin
     setcolor(cor1);moveto(x1,y2);
     lineto(x1,y1);lineto(x2,y1);
     moveto(x2-1,y1+1);
     lineto(x1+1,y1+1);lineto(x1+1,y2-1);
     setcolor(cor2);
     lineto(x2-1,y2-1);lineto(x2-1,y1+1);
     moveto(x2,y1);lineto(x2,y2);lineto(x1,y2);
     setfillstyle(solidfill,cor3);
     bar(x1+2,y1+2,x2-2,y2-2);
     settextjustify(centertext,centertext);setcolor(cor4);
     outtextxy((x1+x2)div 2,(y1+y2)div 2,titulo);
end;

Procedure box_press(x1,y1,x2,y2:integer);
var P:pointer;
    tam:word;
begin
     sound(700);delay(30);nosound;
     tam:=ImageSize(x1+2,y1+2,x2-2,y2-2);
     GetMem(P,tam);
     PMO_semcursormouse;
     GetImage(x1+2,y1+2,x2-2,y2-2,P^);
     setfillstyle(solidfill,5);
     bar(x1,y1,x2,y2);
     PutImage(x1+3,y1+3,P^,NormalPut);
     PMO_comcursormouse;
     PMO_soltamouse;
     PMO_semcursormouse;
     PutImage(x1+2,y1+2,P^,NormalPut);
     freemem(P,tam);
     setcolor(1);moveto(x1,y2);
     lineto(x1,y1);lineto(x2,y1);
     moveto(x2-1,y1+1);
     lineto(x1+1,y1+1);lineto(x1+1,y2-1);
     setcolor(2);
     lineto(x2-1,y2-1);lineto(x2-1,y1+1);
     moveto(x2,y1);lineto(x2,y2);lineto(x1,y2);
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
       pmo_semcursormouse;
       bar(posx-4,posy-5,posx+5,posy+5);outtextxy(posx,posy,#177);
       pmo_comcursormouse;delay(50);pmo_semcursormouse;
       bar(posx-4,posy-5,posx+5,posy+5);outtextxy(posx,posy,#178);
       pmo_comcursormouse;delay(50);
       pmo_readmouse(x,y,b);
     until (keypressed) or ((b=1)and(x>x1)and(x<x2)and(y>y1)and(y<y2));
     pmo_semcursormouse;
     bar(posx-4,posy-5,posx+5,posy+5);
     pmo_comcursormouse;
     if ((b=1)and(x>x1)and(x<x2)and(y>y1)and(y<y2)) then aux:=#27
              else aux:=readkey;
     if (aux<>#13)and(aux<>#27)and(aux<>#8)then
                      begin pmo_semcursormouse;
                            outtextxy(posx,posy,aux);
                            pmo_comcursormouse;
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
     SetRGBpalette(pal.colors[2],15,15,15);
     setRGBpalette(pal.colors[3],63,63,0);
     setRGBpalette(pal.colors[4],0,0,63);
     setRGBpalette(pal.colors[5],45,45,45);
     setRGBpalette(pal.colors[7],25,0,5);
     setRGBpalette(pal.colors[12],63,0,0);
     setRGBpalette(pal.colors[10],0,63,0);
     setRGBpalette(pal.colors[11],0,20,63);
     setRGBpalette(pal.colors[13],63,63,0);
     setRGBpalette(pal.colors[14],63,0,63);
end;

Procedure acha_extremos;
var i:integer;
begin
     apontax:=primeirox;
     xminm:=apontax^.valor;
     xmaxm:=apontax^.valor;
     yminm:=apontax^.primeiroy^.valor;
     ymaxm:=yminm;
     repeat
           if apontax^.valor<xminm then xminm:=apontax^.valor;
           if apontax^.valor>xmaxm then xmaxm:=apontax^.valor;
           apontay:=apontax^.primeiroy;
           for i:=1 to numero_de_curvas do
               begin
               if apontay^.valor<yminm then yminm:=apontay^.valor;
               if apontay^.valor>ymaxm then ymaxm:=apontay^.valor;
               apontay:=apontay^.proximoy;
               end;
           apontax:=apontax^.proximox;
     until apontax=nil;
end;

Procedure risca_para(x,y:real);
begin
     lineto(trunc(xesc*(x-xminm)+xmint),
            trunc(yesc*(y-yminm)+ymint));
end;

Procedure move_para(x,y:real);
begin
     moveto(trunc(xesc*(x-xminm)+xmint),
            trunc(yesc*(y-yminm)+ymint));
end;

Procedure faz_tela;
begin
     define_cor;
     box_cria(0,0,getmaxx,getmaxy,1,2,0,0,'');
     box_cria(2,2,getmaxx-2,getmaxy-2,1,2,7,0,'');
     box_cria(9,110,getmaxx-9,getmaxy-10,2,1,0,0,'');
     box_cria(11,112,getmaxx-11,getmaxy-12,2,1,0,0,'');
     box_cria(10,90,134,108,1,2,5,4,' Ajuda         ');
     box_cria(135,90,258,108,1,2,5,4,' Arquivo       ');
     box_cria(259,90,382,108,1,2,5,4,' Plotar        ');
     box_cria(383,90,506,108,1,2,5,4,' Sair          ');
     box_cria(507,90,630,108,1,2,5,4,#24);
     setcolor(0);
     rectangle(9,89,getmaxx-9,109);
     setcolor(3);
     settextstyle(installuserfont('tscr'),horizdir,1);
     setUsercharsize(2,3,11,10);
     settextjustify(centertext,toptext);
     outtextxy(320,0,'COMPUTACAO GRAFICA');
     outtextxy(320,30,'Universidade Federal do Rio de Janeiro');
end;

Procedure faz_escala(x1t,y1t,x2t,y2t,x1m,y1m,x2m,y2m:real);
begin
     if x2m<>x1m then
       Xesc:=(x2t-x1t)/(x2m-x1m)
       else Xesc:=0;
     if y2m<>y1m then
       Yesc:=(y2t-y1t)/(y2m-y1m)
       else Yesc:=0;
     xmint:=x1t;
     ymint:=y1t;
end;

Procedure traca_grafico;
var h:real;
    i,j:integer;
    cor,padrao:integer;
    aux:string;
    eixox,eixoy:real;
begin
     PMO_semcursormouse;
     setfillstyle(solidfill,black);
     bar(14,115,getmaxx-14,getmaxy-15);
     cor:=10;padrao:=0;
     if (xminm<0) and (xmaxm>0) then eixoy:=0
        else if xminm>=0 then eixoy:=xminm
        else if xmaxm<=0 then eixoy:=xmaxm;
     if (yminm<0) and (ymaxm>0) then eixox:=0
        else if yminm>=0 then eixox:=yminm
        else if ymaxm<=0 then eixox:=ymaxm;
     setcolor(1);move_para(eixoy,yminm);risca_para(eixoy,ymaxm);
     move_para(xminm,eixox);risca_para(xmaxm,eixox);
     settextstyle(installuserfont('tscr'),horizdir,1);
     setusercharsize(2,3,11,10);
     move_para((xmaxm+xminm)/2,ymaxm+(ymaxm-yminm)/10);
     outtext(titulografico);
     settextstyle(defaultfont,horizdir,1);
     settextjustify(lefttext,centertext);
     move_para(eixoy,ymaxm);outtext(tituloy);
     settextjustify(righttext,toptext);
     move_para(xmaxm,eixox-(ymaxm-yminm)/15);outtext(titulox);
     settextjustify(centertext,centertext);
     h:=xminm;
     while h<=xmaxm do begin
                       move_para(h,eixox-(ymaxm-yminm)/20);
                       str(h:3:1,aux);outtext(aux);
                       h:=h+intervalox;
                       end;
     h:=xminm;
     while h<=xmaxm do begin
                      move_para(h,eixox);risca_para(h,eixox-(ymaxm-yminm)/50);
                      h:=h+tracinhox;
                      end;
     h:=yminm;
     while h<=ymaxm do begin
                       move_para(eixoy-(xmaxm-xminm)/20,h);
                       str(h:3:2,aux);outtext(aux);
                       h:=h+intervaloy;
                       end;
     h:=yminm;
     while h<=ymaxm do begin
                      move_para(eixoy,h);
                      risca_para(eixoy-(xmaxm-xminm)/100,h);
                      h:=h+tracinhoy;
                      end;
     setcolor(cor);
     for i:=1 to numero_de_curvas do
        begin
        apontax:=primeirox;
        apontay:=apontax^.primeiroy;
        if i>1 then for j:=2 to i do apontay:=apontay^.proximoy;
        move_para(apontax^.valor,apontay^.valor);
        repeat
              apontax:=apontax^.proximox;
              apontay:=apontax^.primeiroy;
              if i>1 then for j:=2 to i do apontay:=apontay^.proximoy;
              risca_para(apontax^.valor,apontay^.valor);
        until apontax^.proximox=nil;
        cor:=cor+1;
        if cor=16 then begin
                       cor:=10;
                       padrao:=padrao+1;
                       setlinestyle(padrao,1,normwidth);
                       end;
        setcolor(cor);
        end;
        setlinestyle(solidln,1,normwidth);
        pmo_comcursormouse;
end;

Procedure ajuda;
var P1:pointer;
    tam:word;
    aux:string;
begin
     settextstyle(defaultfont,horizdir,1);
     pmo_semcursormouse;
     box_cria(50,150,450,450,1,2,7,4,'');
     box_cria(60,180,440,440,2,1,5,4,'');
     box_cria(60,156,135,176,1,2,5,4,'Ok');
     setcolor(3);
     outtextxy(250,170,'Ajuda');
     setcolor(4);
     outtextxy(250,210,'Tra‡ador de Gr ficos');
     outtextxy(250,225,'copyright(c) 1993');
     outtextxy(250,240,'Cassiano Lustosa Fr¢es da Silva');
     outtextxy(250,255,'Irineu Thiago de Oliveira Rangel');
     outtextxy(250,270,'_________________________________________');
     outtextxy(250,285,'arquivo - lˆ  o arquivo  de  dados a  ser');
     outtextxy(250,300,'                                graficado');
     outtextxy(250,315,'plotar  - define intervalos entre  os n£-');
     outtextxy(250,330,'          meros, tracinhos  e  t¡tulos  e');
     outtextxy(250,345,'          plota   o   gr fico  na  janela');
     outtextxy(250,360,'sair    - sai para o D.O.S.              ');
     aux:=#24+'       - plota o gr fico na tela inteira';
     outtextxy(250,375,aux);
     pmo_comcursormouse;
     repeat
     PMO_readmouse(x,y,b);
     until (b=1) and (x>60) and (x<135) and (y>156) and (y<176);
     box_press(60,156,135,176);
     PMO_Semcursormouse;
     setfillstyle(solidfill,black);bar(50,150,505,450);
     if ja_plotou then begin
                       faz_escala(60,410,580,150,xminm,yminm,xmaxm,ymaxm);
                       traca_grafico;
                       end;
     PMO_comcursormouse;
end;

Procedure limpa_lista;
var pyaux:tipoyptr;
    pxaux:tipoxptr;
begin
     apontax:=primeirox;
     while apontax<>nil do
     begin
          (*** limpa y ***)
          while apontax^.primeiroy<>apontax^.ultimoy do
          begin
               new(pyaux);
               pyaux:=apontax^.primeiroy;
               apontax^.primeiroy:=apontax^.primeiroy^.proximoy;
               dispose(pyaux);
          end;
          new(pyaux);
          pyaux:=apontax^.ultimoy;
          dispose(pyaux);
          apontax^.ultimoy:=nil;apontax^.primeiroy:=nil;
          (*** ***)
     new(pxaux);
     pxaux:=apontax;
     primeirox:=apontax^.proximox;
     apontax:=primeirox;
     dispose(pxaux);
     end;
     primeirox:=nil;ultimox:=nil;
end;


Procedure le(nomearq:string);
var i:integer;
    arq:text;
    aux:real;
begin
     {$I-}
     assign(arq,nomearq);
     reset(arq);
     {$I+}
     if IOresult<>0 then begin
                         sound(300);delay(100);nosound;
                         box_cria(200,235,440,290,3,3,2,1,
                               'ARQUIVO INEXISTENTE');
                         repeat pmo_readmouse(x,y,b);
                                until (b=1)or(keypressed);
                         exit;
                         end;
     if ja_leu then limpa_lista;
     ja_leu:=true;
     while not seekeof(arq) do
           begin
                read(arq,aux);
                new(apontax);apontax^.valor:=aux;
                if primeirox=nil then begin
                                      primeirox:=apontax;
                                      ultimox:=apontax;
                                      apontax^.proximox:=nil;
                                      apontax^.primeiroy:=nil;
                                      end
                 else begin
                     ultimox^.proximox:=apontax;
                     ultimox:=apontax;
                     apontax^.proximox:=nil;
                     apontax^.primeiroy:=nil;
                      end;
           for i:=1 to numero_de_curvas do
             begin
               if (i<numero_de_curvas) then read(arq,aux)
                                   else readln(arq,aux);
               new(apontay);apontay^.valor:=aux;
               if apontax^.primeiroy=nil then
                 begin
                     apontax^.primeiroy:=apontay;
                     apontax^.ultimoy:=apontay;
                     apontay^.proximoy:=nil;
                 end
               else begin
                       apontax^.ultimoy^.proximoy:=apontay;
                       apontax^.ultimoy:=apontay;
                       apontay^.proximoy:=nil;
                    end;
             end;
           end;
     close(arq);
end;


Procedure arquivo;
var nomearq,numcurvas:string;
    pos:integer;
    aux:char;
    code:integer;

    procedure sai;
    begin
         PMO_semcursormouse;
         acha_extremos;
         setfillstyle(solidfill,black);
         bar(135,150,505,300);
         setfillstyle(solidfill,black);bar(135,150,505,300);
         if ja_plotou then begin
                  faz_escala(60,410,580,150,xminm,yminm,xmaxm,ymaxm);
                  traca_grafico;
                  end;
         PMO_comcursormouse;
    end;

begin
     nomearq:='';
     box_cria(135,150,505,300,1,2,7,4,'');
     settextstyle(defaultfont,horizdir,1);
     box_cria(150,160,225,180,1,2,5,4,'Cancelar');
     setcolor(3);
     outtextxy(320,200,'arquivo de dados:');
     box_cria(150,210,490,230,2,1,5,3,'');
     outtextxy(320,250,'n£mero de curvas:');
     box_cria(230,260,410,280,2,1,5,4,'');
 (* Le o nome do arquivo de dados *)
     repeat nomearq:=le_tecla(160,220,150,160,225,180);
     until nomearq<>'';
     if nomearq=#27 then begin
                         sai;
                         exit;
                         end;
 (* Le o n£mero de curvas a serem tracadas *)
     repeat
      numcurvas:=le_tecla(240,270,150,160,225,180);
      if numcurvas=#27 then begin
                            sai;
                            exit;
                            end;
      val(numcurvas,numero_de_curvas,code);
     until (code=0) and (numero_de_curvas<100);
     le(nomearq);
     sai;
end;





Procedure plotar;
var  aux:string;
     code:integer;

begin
     settextstyle(defaultfont,horizdir,1);
     box_cria(135,150,505,420,1,2,7,4,'');
     box_cria(150,160,225,180,1,2,5,4,'Cancelar');
     setcolor(3);outtextxy(320,200,'intervalo dos n£meros');
     outtextxy(320,210,'eixo x                       eixo y');
     outtextxy(320,260,'intervalo dos tracinhos');
     outtextxy(320,270,'eixo x                       eixo y');
     outtextxy(320,320,'t¡tulo dos eixos');
     outtextxy(320,330,'eixo x                       eixo y');
     outtextxy(320,380,'t¡tulo do gr fico');
     box_cria(150,220,270,240,2,1,5,3,'');
     box_cria(370,220,490,240,2,1,5,3,'');
     box_cria(150,280,270,300,2,1,5,3,'');
     box_cria(370,280,490,300,2,1,5,3,'');
     box_cria(150,340,300,360,2,1,5,3,'');
     box_cria(340,340,490,360,2,1,5,3,'');
     box_cria(150,390,490,410,2,1,5,3,'');
     repeat
     aux:=le_tecla(160,230,150,160,225,180);
     if aux=#27 then exit;
     val(aux,intervalox,code);
     until code=0;
     repeat
     aux:=le_tecla(380,230,150,160,225,180);
     if aux=#27 then exit;
     val(aux,intervaloy,code);
     until code=0;
     repeat
     aux:=le_tecla(160,290,150,160,225,180);
     if aux=#27 then exit;
     val(aux,tracinhox,code);
     until code=0;
     repeat
     aux:=le_tecla(380,290,150,160,225,180);
     if aux=#27 then exit;
     val(aux,tracinhoy,code);
     until code=0;
     aux:=le_tecla(160,350,150,160,225,180);
     if aux=#27 then exit;
     titulox:=aux;
     aux:=' '+le_tecla(350,350,150,160,225,180);
     if aux=' '+#27 then exit;
     tituloy:=aux;
     aux:=le_tecla(160,400,150,160,225,180);
     if aux=#27 then exit;
     titulografico:=aux;
     pmo_semcursormouse;
     setfillstyle(solidfill,0);bar(14,114,getmaxx-14,getmaxy-14);
     pmo_comcursormouse;
     ja_plotou:=true;
     faz_escala(60,410,580,150,xminm,yminm,xmaxm,ymaxm);
     traca_grafico;
end;

Procedure plota_grande;
begin
     pmo_semcursormouse;
     cleardevice;
     box_cria(0,0,getmaxx,getmaxy,1,2,7,4,'');
     box_cria(4,22,getmaxx-4,getmaxy-4,2,1,0,0,'');
     faz_escala(55,440,585,70,xminm,yminm,xmaxm,ymaxm);
     traca_grafico;
     box_cria(4,4,79,20,1,2,5,4,'Ok');
     pmo_comcursormouse;
     repeat
     pmo_readmouse(x,y,b);
     until (x<75) and (y<21) and (b=1);
     box_press(4,4,79,20);
     pmo_semcursormouse;
     faz_tela;
     faz_escala(60,410,580,150,xminm,yminm,xmaxm,ymaxm);
     traca_grafico;
     pmo_comcursormouse;
end;

Procedure Click;
begin
     if (x>10) and (x<134) then begin
                                box_press(10,90,134,108);
                                ajuda;
                                end
       else if (x>134) and (x<258) then begin
                                   box_press(135,90,258,108);
                                   arquivo;
                                   end
       else if (x>258) and (x<382) then begin
                                   box_press(259,90,382,108);
                                   if ja_leu then plotar;
                                   end
       else if (x>382) and (x<506) then begin
                                   box_press(383,90,506,108);
                                   end
       else if (x>506) and (x<630) then begin
                                   box_press(507,90,629,108);
                                   if ja_plotou then plota_grande;
                                   end;

end;

Procedure fim;
var k,i:integer;
    pal:palettetype;
begin
     pmo_semcursormouse;
     getpalette(pal);
     for k:=16 downto 0 do
     begin
     if k<>3 then setRGBpalette(pal.colors[k],k,k,k);
     delay(100);
     end;
     setRGBpalette(3,0,0,0);
     delay(200);
     closegraph;
     textcolor(yellow);
     writeln('--------------------------------------------');
     writeln(' >>  Tra‡ador de gr ficos - outubro/1993  <<');
     writeln;
     writeln(' Autores  : Cassiano Lustosa Fr¢es da Silva');
     writeln('           Irineu Thiago de Oliveira Rangel');
     writeln('--------------------------------------------');
     textcolor(lightgray);
end;

Begin
     Inicia_grafico;
     ja_leu:=false;ja_plotou:=false;
     faz_tela;
     PMO_inimouse;PMO_comcursormouse;
     repeat
     PMO_readmouse(x,y,b);
     if (b=1)and(y>=90)and(y<=108) then click;
     until (b=1) and (y>=90) and (y<=108) and (x>382) and (x<506);
     fim;
end.