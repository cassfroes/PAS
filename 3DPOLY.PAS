program _3dpoly;
uses graph,graphnce;


type
     tipovertice=record
                       x,y,z:real;
                 end;
     tipoaresta=record
                      vert1,vert2,cor:word;
                end;
     tipotabvertices=array[1..300]of tipovertice;
     tipotabarestas=array[1..300]of tipoaresta;

var sai:boolean;
  {  Vsx, Vsy: real;
    Vcx, Vcy: integer;
  }
    xmaxM,xminM,ymaxM,yminM :real;
    bot, xcur, ycur: integer;
    corprisma:integer;

    tabvert:tipotabvertices;
    ultimovertice:word;
    tabarestas:tipotabarestas;
    ultimaaresta:word;

procedure inicializa_grafico;
begin
     modografico(EGA,EGAhi);
end;

procedure inicializa_variaveis;
begin
   { Vsx :=  0.063 / (getmaxx+1) * getmaxx;   (* 1/16 *)
    Vsy := -0.067 / (getmaxy+1) * getmaxy;    (* 1/17 *)
    Vcx := getmaxx div 2;
    Vcy := getmaxy div 2;
   }
    ultimovertice:=0;ultimaaresta:=0;
    xmaxM := 260;
    xminM := -260;
    ymaxM := 250;
    yminM := 0;
    corprisma:=white;
end;

{ conversao mundo-tela e tela-mundo }
{ 14,54,   540,305  --->  coordenadas da janela na tela }
procedure TelaMundo (xtela, ytela: integer;  var xm, ym: real);
begin
    xm := (xtela-15)*(xmaxM-xminM)/525 + XminM;
    ym := (ytela-55)*(yminM-ymaxM)/250 + ymaxM;
end;

procedure  MundoTela (xm, ym: real;  var xtela, ytela: integer);
begin
    xtela := trunc ( (xm-xminM)/(xmaxM-xminM)*525 + 15 );
    ytela := trunc ( (ym-ymaxM)/(yminM-ymaxM)*250 + 55 );
end;

procedure reta3d(x1,y1,z1 ,x2,y2,z2:real);
const D=40;
var xt1,yt1,xt2,yt2:integer;
    xm1,ym1,xm2,ym2:real;
begin
     xm1:=D*x1/y1  ;  xm2:=D*x2/y2;
     ym1:=D*z1/y1  ;  ym2:=D*z2/y2;

     MundoTela(xm1,ym1, xt1,yt1);
     MundoTela(xm2,ym2, xt2,yt2);

     line(xt1,yt1,xt2,yt2);
end;

procedure cria_tela;
begin
     box_cria(0,0,getmaxx,getmaxy,'');
     seleccorjan(def,black,def,darkgray,white,def);
     box_cria(10,50,getmaxx-95,getmaxy-40,'');
     box_cria(10,getmaxy-35,getmaxx-95,getmaxy-10,'');
     seleccorjan(def,lightgray,def,white,darkgray,def);
end;

procedure apresenta;
begin
     box_cria(20,20,getmaxx-20,200,'');
     box_cria(35,35,getmaxx-35,100,'');
     setcolor(cyan);
     settextstyle(installuserfont('tscr'),horizdir,4);
     settextjustify(centertext,toptext);
     outtextxy(320,40,'Computacao Grafica II');
     setcolor(blue);
     outtextxy(322,42,'Computacao Grafica II');
     readln;
     settextjustify(lefttext,toptext);
end;

procedure apagaareacomentarios;
begin
     semcursormouse;
     setfillstyle(solidfill,black);
     bar(14,getmaxy-32,getmaxx-98,getmaxy-13);
     comcursormouse;
end;

function criavertice3d(xvert,yvert,altvert:real):integer;
var i:integer;
    achou:boolean;
begin
    { achou:=false;
     for i:=0 to (ultimovertice-1) do
              if (xvert=tabvert[i].x)and(yvert=tabvert[i].y)
                                     and(altvert=tabvert[i].z)
                                     then begin
                                          achou:=true;
                                          criavertice3d:=i;
                                          end;
     if not achou then begin
    }
                       tabvert[ultimovertice].x:=xvert;
                       tabvert[ultimovertice].y:=yvert;
                       tabvert[ultimovertice].z:=altvert;
                       criavertice3d:=ultimovertice;
                       ultimovertice:=ultimovertice+1;
                   {    end;}

end;

procedure criaaresta(v1,v2,corv:integer);
begin
     { verificar se a aresta vert1-vert2 j  existe ...}
     tabarestas[ultimaaresta].vert1:=v1;
     tabarestas[ultimaaresta].vert2:=v2;
     tabarestas[ultimaaresta].cor:=corprisma;
     ultimaaresta:=ultimaaresta+1;
end;

procedure crianovoprisma;

type vertice2d=record
                     x,y:integer;
                    end;
var xprisma,yprisma:integer;
    tabvertices2d:array[0..50]of vertice2d;
    numvertice:integer;
    strg:string;
    ch:char;
    code:byte;
    codeval:integer;
    fim:boolean;
    altmax,altmin:real;

procedure inserevertice2d(xver,yver:integer);
begin
     semcursormouse;
     numvertice:=numvertice+1;
     tabvertices2d[numvertice].x:=xver;
     tabvertices2d[numvertice].y:=yver;
     if numvertice>1 then
                     begin
                          line(tabvertices2d[numvertice-1].x,
                               tabvertices2d[numvertice-1].y,
                               tabvertices2d[numvertice].x,
                               tabvertices2d[numvertice].y);
                     if (tabvertices2d[numvertice].x=tabvertices2d[1].x)and
                       (tabvertices2d[numvertice].y=tabvertices2d[1].y)then
                                           begin
                                           numvertice:=numvertice-1;
                                           fim:=true;
                                           end;
                     end;
     comcursormouse;
     
end; {insere vertice2d}

{insere todos os v‚rtices 2d lidos na tabela de vertices e de arestas}
procedure inseretabela;
var i:integer;
    xm,ym:real;
    itopo:array[0..50]of integer;
    ibase:array[0..50]of integer;
begin

{ fazer a conversao tela-mundo ..... }
     for i:=0 to numvertice do
         begin
              TelaMundo(tabvertices2d[i].x,tabvertices2d[i].y, xm,ym);
              itopo[i]:=criavertice3d(xm,ym,altmax);
              ibase[i]:=criavertice3d(xm,ym,altmin);
         end;

     for i:=0 to numvertice do
         begin
              criaaresta(itopo[i],itopo[(i+1)mod numvertice],corprisma);
              criaaresta(ibase[i],ibase[(i+1)mod numvertice],corprisma);
              criaaresta(itopo[i],ibase[i],corprisma);
         end;
end;
{ corpo principal da rotina crianovoprisma }
begin
     numvertice:=0;fim:=false;

     setcolor(corprisma);
     setwritemode(XORPUT);
     selecareamouse(15,55,535,305);
     posmouse(275,175);
     xprisma:=275;yprisma:=175;
     semcursormouse;
     rectangle(xprisma-2,yprisma-2,xprisma+2,yprisma+2);
     comcursormouse;
     repeat
           bot:=lemouse(xcur,ycur);
           if (abs(xcur-xprisma)>=10)then
                                  begin
                                  semcursormouse;
                                  rectangle(xprisma-2,yprisma-2,
                                                 xprisma+2,yprisma+2);
                                  if xprisma>xcur then xprisma:=xprisma-10
                                     else xprisma:=xprisma+10;
                                  rectangle(xprisma-2,yprisma-2,
                                                 xprisma+2,yprisma+2);
                                  comcursormouse;
                                  end;
           if (abs(ycur-yprisma)>=10)then
                                  begin
                                  semcursormouse;
                                  rectangle(xprisma-2,yprisma-2,
                                                 xprisma+2,yprisma+2);
                                  if yprisma>ycur then yprisma:=yprisma-10
                                     else yprisma:=yprisma+10;
                                  rectangle(xprisma-2,yprisma-2,
                                                 xprisma+2,yprisma+2);
                                  comcursormouse;
                                  end;
           if bot=1 then begin
                         soltamouse;
                         inserevertice2d(xprisma,yprisma);
                         end;
     until (bot=2)or(fim);
     selecareamouse(0,0,getmaxx,getmaxy);
     semcursormouse;
     rectangle(xprisma-2,yprisma-2,xprisma+2,yprisma+2);

     setcolor(yellow);
     seleccorjan(white,lightgray,def,white,darkgray,def);
     outtextxy(20,325,'altura m¡nima :');
     outtextxy(300,325,'altura m xima :');
     comcursormouse;

{??} strg:=CLF_Letextoxy(150,325,'0',5,code);      { verificar se }
{??} if keypressed then ch:=Readkey;               { conversao de string }
{??} val(strg,altmin,codeval);                     { p/ real   }
{??} strg:=CLF_Letextoxy(430,325,'10',5,code);     { foi Ok .... }
{??} if keypressed then ch:=Readkey;               { e tecla de sa¡da}
{??} val(strg,altmax,codeval);                     { na funcao letextoxy ...}

     apagaareacomentarios;
     seleccorjan(black,lightgray,def,white,darkgray,def);

     setwritemode(NORMALPUT);

     inseretabela;
end; { crianovoprisma }

{menu principal para o editor de prismas }
procedure menuedit;
var vetmenubox : TabMenuBoxOpc;
{ inicializa o vetor vetmenubox com os valores e strings do menu }
procedure inicializamenubox;
var i:integer;
begin
     for i:=1 to 8 do
              begin
              vetmenubox[i].x1:=550;vetmenubox[i].x2:=630;
              end;
     vetmenubox[1].y1:=50 ;vetmenubox[1].y2:=70 ;
     vetmenubox[1].txt:='sair';
     vetmenubox[2].y1:=70 ;vetmenubox[2].y2:=90 ;
     vetmenubox[2].txt:='visao 3d';
     vetmenubox[3].y1:=90 ;vetmenubox[3].y2:=110 ;
     vetmenubox[3].txt:='arquivo';
     vetmenubox[4].y1:=130 ;vetmenubox[4].y2:=150 ;
     vetmenubox[4].txt:='prisma';
     vetmenubox[5].y1:=150 ;vetmenubox[5].y2:=170 ;
     vetmenubox[5].txt:='cor';
     vetmenubox[6].y1:=170 ;vetmenubox[6].y2:=190 ;
     vetmenubox[6].txt:='voltar';
     vetmenubox[7].y1:=190 ;vetmenubox[7].y2:=210 ;
     vetmenubox[7].txt:='zoom +';
     vetmenubox[8].y1:=210 ;vetmenubox[8].y2:=230 ;
     vetmenubox[8].txt:='zoom -';


     vetmenubox[9].x1:=550 ;vetmenubox[9].y1:=220 ;
     vetmenubox[9].x2:=630 ;vetmenubox[9].y2:=240 ;
     vetmenubox[9].txt:='rota‡ao';
     vetmenubox[10].x1:=550 ;vetmenubox[10].y1:=240 ;
     vetmenubox[10].x2:=630 ;vetmenubox[10].y2:=260 ;
     vetmenubox[10].txt:='ir para';
     vetmenubox[11].x1:=550 ;vetmenubox[11].y1:=260 ;
     vetmenubox[11].x2:=630 ;vetmenubox[11].y2:=280 ;
     vetmenubox[11].txt:='voltar';
     vetmenubox[12].x1:=550 ;vetmenubox[12].y1:=280 ;
     vetmenubox[12].x2:=630 ;vetmenubox[12].y2:=300 ;
     vetmenubox[12].txt:='zoom +';
     vetmenubox[13].x1:=550 ;vetmenubox[13].y1:=300 ;
     vetmenubox[13].x2:=630 ;vetmenubox[13].y2:=320 ;
     vetmenubox[13].txt:='zoom -';
     vetmenubox[14].x1:=550 ;vetmenubox[14].y1:=320 ;
     vetmenubox[14].x2:=630 ;vetmenubox[14].y2:=340 ;
     vetmenubox[14].txt:='in¡cio';

end;

procedure cria_grade;
var i,j:integer;
begin
     { 14,54,   540,305  --->  coordenadas da janela na tela }
     semcursormouse;
     i:=15;
     repeat
     j:=55;
          repeat
          putpixel(i,j,yellow);
          j:=j+10;
          until j>305;
     i:=i+10;
     until i>=540;
     comcursormouse;
end;
procedure arquivo;
var opcao:integer;
    nomearq:string;
begin
     opcao:=menumouse(500,90,' novo/ abrir / salvar');
     nomearq:=ledir(450,90);
  {   case opcao of
                1:novoarquivo;
                2:abrearquivo;
                3:salvaarquivo;
     end;
  }
end;

procedure novacor;
var tabopcoes:tabquad;
    i:integer;
begin
     for i:=1 to 15 do
         begin
         tabopcoes[i].x:=460;
         tabopcoes[i].y:=150+i*11;
         end;
     tabopcoes[1].txt:='azul';tabopcoes[2].txt:='verde';
     tabopcoes[3].txt:='ciano';tabopcoes[4].txt:='vermelho';
     tabopcoes[5].txt:='magenta';tabopcoes[6].txt:='marrom';
     tabopcoes[7].txt:='cinza claro';tabopcoes[8].txt:='cinza escuro';
     tabopcoes[9].txt:='azul claro';tabopcoes[10].txt:='verde claro';
     tabopcoes[11].txt:='ciano claro';tabopcoes[12].txt:='vermelho claro';
     tabopcoes[13].txt:='magenta claro';tabopcoes[14].txt:='amarelo';
     tabopcoes[15].txt:='branco';
     criaJanela(445,150,600,330);
     setcolor(black);
     CriaQuadrinho(15,tabopcoes);
     semcursormouse;
     for i:=1 to 15 do
         begin
         setfillstyle(solidfill,i);
         bar(461,151+i*11,471,158+i*11);
         end;
     comcursormouse;

           corprisma:=selQuadrinho(15,tabopcoes);
           xisquadrinho(corprisma,tabopcoes);

     soltamouse;
     removejanela;
end;

{ corpo principal de menuedit       |  }
var opc:integer;
begin
     inicializamenubox;
     cria_tela;
     cria_grade;
     setcolor(red);settextstyle(InstallUserFont('tscr'),horizdir,4);
     outtextxy(0,3,' Editor de prismas');
     outtextxy(0,4,' Editor de prismas');
     settextstyle(defaultfont,horizdir,1);
     desenhamenubox(vetmenubox,8);
     repeat
     opc:=menubox(vetmenubox,8);
     case opc of
          3:arquivo;
          4:crianovoprisma;
          5:novacor;
          end; {fimcase}
     until (opc=1)or(opc=2);
     if opc=1 then sai:=true;
end;  { menuedit }

{ menu principal para visao perspectiva}
procedure menuperspectiva;
var vetmenubox : TabMenuBoxOpc;


procedure desenhacena;
var i:integer;
begin
     for i:=0 to (ultimaaresta-1) do
         begin
              setcolor(white{tabarestas[i].cor});
              reta3d(tabvert[tabarestas[i].vert1].x,
                     tabvert[tabarestas[i].vert1].y,
                     tabvert[tabarestas[i].vert1].z,
                     tabvert[tabarestas[i].vert2].x,
                     tabvert[tabarestas[i].vert2].y,
                     tabvert[tabarestas[i].vert2].z);
         end;
end;

procedure lexyz;
var strg:string;
    code:byte;
    ch:char;
begin
     seleccorjan(white,lightgray,def,white,darkgray,def);
     setcolor(yellow);
     outtextxy(20,325,'passo x:');
     outtextxy(200,325,'passo y:');
     outtextxy(380,325,'passo z:');
     strg:=CLF_Letextoxy(90,325,'10',5,code);
     if keypressed then ch:=Readkey;
     strg:=CLF_Letextoxy(270,325,'10',5,code);
     if keypressed then ch:=Readkey;
     strg:=CLF_Letextoxy(450,325,'10',5,code);
     if keypressed then ch:=Readkey;
     seleccorjan(black,lightgray,def,white,darkgray,def);
     apagaareacomentarios;
end;
{ inicializa o vetor vetmenubox com os valores e strings do menu }
procedure inicializamenubox;
begin
     vetmenubox[1].x1:=550 ;vetmenubox[1].y1:=50 ;
     vetmenubox[1].x2:=630 ;vetmenubox[1].y2:=70 ;
     vetmenubox[1].txt:='sair';
     vetmenubox[2].x1:=550 ;vetmenubox[2].y1:=70 ;
     vetmenubox[2].x2:=630 ;vetmenubox[2].y2:=90 ;
     vetmenubox[2].txt:='editor';
     vetmenubox[3].x1:=560 ;vetmenubox[3].y1:=130 ;
     vetmenubox[3].x2:=580 ;vetmenubox[3].y2:=150 ;
     vetmenubox[3].txt:=#24;
     vetmenubox[4].x1:=550 ;vetmenubox[4].y1:=150 ;
     vetmenubox[4].x2:=570 ;vetmenubox[4].y2:=170 ;
     vetmenubox[4].txt:=#27;
     vetmenubox[5].x1:=570 ;vetmenubox[5].y1:=150 ;
     vetmenubox[5].x2:=590 ;vetmenubox[5].y2:=170 ;
     vetmenubox[5].txt:=#26;
     vetmenubox[6].x1:=560 ;vetmenubox[6].y1:=170 ;
     vetmenubox[6].x2:=580 ;vetmenubox[6].y2:=190 ;
     vetmenubox[6].txt:=#25;
     vetmenubox[7].x1:=608 ;vetmenubox[7].y1:=150 ;
     vetmenubox[7].x2:=630 ;vetmenubox[7].y2:=170 ;
     vetmenubox[7].txt:='y+';
     vetmenubox[8].x1:=608 ;vetmenubox[8].y1:=170 ;
     vetmenubox[8].x2:=630 ;vetmenubox[8].y2:=190 ;
     vetmenubox[8].txt:='y-';

     vetmenubox[9].x1:=550 ;vetmenubox[9].y1:=200 ;
     vetmenubox[9].x2:=630 ;vetmenubox[9].y2:=220 ;
     vetmenubox[9].txt:='rota‡ao';
     vetmenubox[10].x1:=550 ;vetmenubox[10].y1:=220 ;
     vetmenubox[10].x2:=630 ;vetmenubox[10].y2:=240 ;
     vetmenubox[10].txt:='ir para';
     vetmenubox[11].x1:=550 ;vetmenubox[11].y1:=240 ;
     vetmenubox[11].x2:=630 ;vetmenubox[11].y2:=260 ;
     vetmenubox[11].txt:='voltar';
     vetmenubox[12].x1:=550 ;vetmenubox[12].y1:=260 ;
     vetmenubox[12].x2:=630 ;vetmenubox[12].y2:=280 ;
     vetmenubox[12].txt:='in¡cio';

end;

{ corpo principal da rotina menuperspectiva }
var opc:integer;
begin
     cria_tela;
     inicializamenubox;
     desenhamenubox(vetmenubox,12);
     setcolor(red);settextstyle(InstallUserFont('tscr'),horizdir,4);
     outtextxy(0,3,' Visao em perspectiva');
     outtextxy(0,4,' Visao em perspectiva');
     outtextxy(0,0,'    ~');
     settextstyle(defaultfont,horizdir,1);
                       (***************)
(*************  ---->> *) desenhacena; (***********)
                       (***************)
     repeat
     opc:=MenuBox(vetmenubox,12);
     case opc of
          9:menumouse(500,220,'horaria/anti-horaria');
          10:lexyz;
          end;
     until (opc=1)or(opc=2);
     if opc=1 then sai:=true;
end;   { menuperspectiva }



BEGIN
     sai:=false;
     inicializa_grafico;
     inicmouse;
     inicializa_variaveis;
     {apresenta;}
     repeat
     menuedit;
     if not sai then menuperspectiva;
     until sai;
     fimgrafico;
END.

