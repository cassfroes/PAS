{

    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    º            Transformacoes Lineares              º
    º     Universidade Federal do Rio de Janeiro      º
    º          ¸1993 Cassiano Lustosa Froes           º
    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

}
program transformacoes_lineares;

uses crt,graph,graphnce,clmenu;

const cinza1=1;
      cinza2=2;
      cinza3=3;
      azul_esc=4;
      vinho=5;

var x, y, b : integer;
    fim     : boolean;
    matriz,
    matriz_inversa : array[1..2,1..2]of real;
    xmaxm,xminm,ymaxm,yminm:real;

procedure beep(fq,tm:integer);
begin
     sound(fq);delay(tm);
     nosound;
end;

procedure inicializa_grafico;
var pal:palettetype;
    dr,mo:integer;
begin
     MODOGRAFICO(vga,vgahi);
     getpalette(pal);
     setRGBpalette(pal.colors[cinza1],50,50,50);
     setRGBpalette(pal.colors[cinza2],25,25,25);
     setRGBpalette(pal.colors[cinza3],40,40,40);
     setRGBpalette(pal.colors[vinho],20,0,0);
     setRGBpalette(pal.colors[azul_esc],0,5,20);
     setRGBpalette(pal.colors[6],35,35,35);
     setRGBpalette(pal.colors[8],34,38,38);
end; { inicializa gr fico }

procedure faz_tela;
begin
     settextstyle(smallfont,horizdir,4);
     box_definecor(cinza1,cinza2,vinho,0);         { background }
     box_cria(0,0,getmaxx,getmaxy,'');
     box_definecor(cinza1,cinza2,cinza3,0);
     box_cria(10,10,getmaxx-10,68,'');
     box_definecor(cinza1,cinza2,6,0);
     box_cria(150,100,getmaxx-10,getmaxy-40,'');    { janela }
     box_cria(10,getmaxy-38,getmaxx-10,getmaxy-10,''); {area de comentarios}
     box_cria(10,200,148,314,'');   { boxes laterais -> das matrizes }
     box_cria(10,316,148,439,'');
     box_cria(10,100,148,198,'');

     box_definecor(cinza1,cinza2,cinza3,vinho);
     box_cria(12,73,88,95,'Ajuda');
     box_cria(89,73,165,95,'Intervalos');
     box_cria(166,73,242,95,'Ler Matriz');
     box_cria(243,73,319,95,'Ler Pontos');
     box_cria(320,73,396,95,'Transformar');
     box_cria(397,73,473,95,'Inversa');
     box_cria(474,73,550,95,'Sair');
     box_cria(551,73,628,95,'^');

     box_definecor(cinza2,cinza1,cinza3,0);
     box_cria(15,220,143,309,'');   { matrizes.2 }
     box_cria(15,336,143,434,'');
     box_cria(15,120,143,193,'');
     box_cria(155,105,getmaxx-15,getmaxy-45,'');
     box_cria(15,getmaxy-33,getmaxx-15,getmaxy-15,''); {coment.2}
     setcolor(azul_esc);outtextxy(79,212,'Matriz');
                     outtextxy(79,328,'Matriz inversa');
                     outtextxy(79,112,'Transformacao');
     settextstyle(defaultfont,horizdir,1);
     outtextxy(320,50,'Universidade Federal do Rio de Janeiro'+
                                    '   -  novembro / 1993');
     outtextxy(320,60,'Autor : Cassiano Lustosa Froes da Silva'+
                                    '   -   dre 931308024');
     settextstyle(installuserfont('tscr'),horizdir,4);
     setcolor(cinza2);
     outtextxy(320,21,'Transforma‡oes Lineares');
     setcolor(azul_esc);outtextxy(322,23,'Transforma‡oes Lineares');
end;        { faz_tela }

procedure comentario(strg:string);
begin
     setfillstyle(solidfill,cinza3);
     bar(17,getmaxy-31,getmaxx-17,getmaxy-17);
     outtextxy(25,getmaxy-25,strg);
end;
procedure ajuda;
begin
end;     { ajuda }

procedure intervalos;
var opc:integer;
    aux:string;
    P:pointer;
    tam:longint;
    code:integer;

    procedure le_x;
    begin
         outtextxy(25,getmaxy-25,'intervalos no eixo x : ');
         outtextxy(26,getmaxy-25,'intervalos no eixo x :');
         outtextxy(170,getmaxy-25,'m¡nimo : ');
         outtextxy(300,getmaxy-25,'m ximo : ');
         aux:=letextoxy(220,getmaxy-25,'<',6,'>');
         val(aux,xminm,code);
         aux:=letextoxy(350,getmaxy-25,'<',6,'>');
         val(aux,xmaxm,code);
         bar(18,getmaxy-30,getmaxx-18,getmaxy-18);
         if xmaxm<=xminm then begin beep(500,50);le_x;end;
    end;
    procedure le_y;
    begin
         outtextxy(25,getmaxy-25,'intervalos no eixo y : ');
         outtextxy(26,getmaxy-25,'intervalos no eixo y :');
         outtextxy(170,getmaxy-25,'m¡nimo : ');
         outtextxy(300,getmaxy-25,'m ximo : ');
         aux:=letextoxy(220,getmaxy-25,'<',6,'>');
         val(aux,yminm,code);
         aux:=letextoxy(350,getmaxy-25,'<',6,'>');
         val(aux,ymaxm,code);
         bar(18,getmaxy-30,getmaxx-18,getmaxy-18);
         if ymaxm<=yminm then begin beep(500,50);le_y;end;
    end;
begin
     settextstyle(smallfont,horizdir,4);
     opc:=menumouse(89,96,'  Eixo x  /  Eixo y  /  Ambos  ');
     setfillstyle(solidfill,cinza3);
     settextjustify(lefttext,centertext);
     setcolor(0);
     case opc of
      1:le_x;
      2:le_y;
      3:begin le_x;le_y;end;
      end;
end;    { le intervalos }

procedure ler_matriz;
var aux:string;
begin
     settextstyle(smallfont,horizdir,4);
     settextjustify(lefttext,centertext);
     setcolor(black);
     comentario('coluna 1, linha 1');
     aux:=letextoxy(25,250,'',8,'');
     comentario('coluna 2, linha 1');
     aux:=letextoxy(80,250,'',8,'');
     comentario('coluna 1, linha 2');
     aux:=letextoxy(25,280,'',8,'');
     comentario('coluna 2, linha 2');
     aux:=letextoxy(80,280,'',8,'');
end;   { le matriz }

procedure sair;
var x:integer;
begin
     x:=menumouse(474,96,'  Sim  /  Nao');
     if x=1 then fim:=true;
end;   { sair }

procedure clicou;
begin
     settextjustify(lefttext,toptext);
     seleccorjan(azul_esc,cinza1,cinza2);
     case ((x-12)div 77) of
     0:ajuda;
     1:intervalos;
     2:ler_matriz;
     {3:ler_pontos;
     4:
     5:
      }
     6:sair;
     {7:}
     end;
end;  { clicou }
BEGIN
     inicializa_grafico;
     inicmouse;
     faz_tela;
     comcursormouse;
     repeat
     b:=lemouse(x,y);
     if (b<>0)and(y<95)and(y>73)and(x>12)and(x<628) then
                               begin
                               box_press(((x-12)div 77)*77+12,73,
                                       ((x-12)div 77)*77+88,95);
                               b:=lemouse(x,y);
                               if b=0 then clicou;
                               end;
     until fim=true;
     fimgrafico;
END.    { Transformacoes lineares }