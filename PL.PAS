{
---------------------------------------------------------

       Universidade Federal do Rio de Janeiro

   Curso de Programa‡Æo linear - 1994 / 2o. semestre
                  Professor : Fac¢

    programa para resolu‡Æo de sistemas lineares

         autor : Cassiano Lustosa Fr¢es
---------------------------------------------------------
}

program pl;

uses graph,        { bibliotecas para interface grafica e }
     graphnce,
     printer;     {                            impressao }

type tipomatriz=array[1..31,1..30]of double;

var princmenu : TabMenuBoxOpc;            { variavel p/ controle do menu }

    matriz,
    matrizcop : tipomatriz;               { matrizcop = c¢pia de matriz  }

    n         : integer;                  { ordem da matriz }

    linpvt    : array[1..50]of integer;   { cont‚m o no. da linha onde foi
                                            encontada o pivo }


{---------------------------------------------------}
{ Rotina de inicializacao                           }
{---------------------------------------------------}
Procedure inicia_variaveis;
var i : integer;
begin
     n := 30;             { ordem da matriz; default = 30 }
     for i := 1 to 5 do   { define a posicao do menu }
         begin
              princmenu[i].x1 := i*100-35;
              princmenu[i].x2 := i*100+65;
              princmenu[i].y1 := 35;
              princmenu[i].y2 := 55;

         end;
     princmenu[1].txt := 'Arquivo';
     princmenu[2].txt := 'Resolver';
     princmenu[3].txt := 'Nova Matriz';
     princmenu[4].txt := 'Mat.anterior';
     princmenu[5].txt := 'Sair';

     defpath('','*.mat'); { path onde estao os arquivos de dados }
end;


{------------------------------------------------------}
{    Rotinas para manipulacao da interface grafica     }
{------------------------------------------------------}
Procedure inicia_video;
{ Interface grafica  -  entra em modo grafico }
begin
     modografico(vga,def);
     inicmouse;
end;

Procedure janela(x1,y1,x2,y2:integer);
{ Interface gr fica  - desenha uma janela }
begin
     setcolor(darkgray);
     rectangle(x1,y1,x2,y2);
     setcolor(white);
     moveto(x2,y1);
     lineto(x2,y2);lineto(x1,y2);
end;

Procedure janela2(x1,y1,x2,y2:integer);
{ Interface gr fica }
begin
     setcolor(white);
     rectangle(x1,y1,x2,y2);
     setcolor(darkgray);
     moveto(x2,y1);
     lineto(x2,y2);lineto(x1,y2);
end;


Procedure desenha_interface;
{ desenha a tela }
begin
     setfillstyle(1,lightgray);
     bar(0,0,getmaxx,getmaxy);
     janela(10,10,getmaxx-10,60);
     janela2(11,11,getmaxx-11,59);

     desenhamenubox(princmenu,5);
     setcolor(blue);
     settextjustify(centertext,toptext);
     outtextxy(320,20,'Resolu‡ƒo de Sistemas Lineares');

     janela (10,getmaxy-40,getmaxx-10,getmaxy-10);
     janela2(11,getmaxy-39,getmaxx-11,getmaxy-11);

     setcolor(black);
     settextjustify(lefttext,toptext);
     outtextxy(18,getmaxy-35,'coluna  linha');
     janela (20,getmaxy-26,45,getmaxy-15);
     janela (85,getmaxy-26,110,getmaxy-15);
end;


Procedure desenha_grade(col,lin:integer);
{ desenha a matriz }
var i,j  : integer;
    strg : string;
begin
     semcursormouse;
     setfillstyle(solidfill,lightgray);
     bar(0,61,640,435);
     settextjustify(righttext,toptext);
     settextstyle(smallfont,horizdir,3);
     setusercharsize(10,15,1,1);

     for i:=1 to col do
         begin
         setcolor(black);
         str(i,strg);
         outtextxy(i*20+9,60,strg);
         for j:=1 to lin do
             begin
             setcolor(black);
             if (j mod 2)=0 then begin
                                 setfillstyle(solidfill,cyan);
                                 bar(i*20-10,j*12+60,i*20+8,j*12+71);
                                 end;
             if i=1 then begin
                         str(j,strg);
                         outtextxy(9,j*12+60,strg);
                         end;
             janela(i*20-10,j*12+60,i*20+9,j*12+71);
             end;
         end;
     setcolor(black);

     { termo independente - col = n+1 }
     outtextxy((col+1)*20+10,60,'b');
     for j:=1 to lin do
              begin
              if (j mod 2)=0 then begin
                                 setfillstyle(solidfill,cyan);
                                 bar((col+1)*20-6,j*12+60,(col+1)*20+12,j*12+71);
                                 end;
             janela((col+1)*20-6,j*12+60,(col+1)*20+13,j*12+71);
             end;
     settextjustify(lefttext,toptext);
     comcursormouse;
end;


procedure inic_porcentagem(strg:string);
{ interface grafica - inicializa barra de porcentagem }
begin
     settextstyle(defaultfont,horizdir,1);
     janela(400,460,601,465);
     setcolor(black);
     outtextxy(400,450,strg);
end;
procedure porcentagem(p:real);
{ interface grafica - atualiza porcentagem }
begin

     setfillstyle(1,blue);
     bar(401,461,400+trunc(p*200),464);

end;
procedure fecha_porcentagem;
{ interface grafica - remove barra de porcentagem }
begin
     begin
     setfillstyle(1,lightgray);
     bar(400,441,601,465);
     end;
end;


procedure escreve_valor(x,y:integer);
{ escreve na tela o valor da coluna 'x', linha 'y' da matriz atual }
var strg:string;
begin
     settextstyle(smallfont,horizdir,3);
     setusercharsize(10,15,1,1);
     semcursormouse;
     if (y mod 2)=0 then setfillstyle(solidfill,cyan)
                    else setfillstyle(solidfill,lightgray);
     { converte o valor para string e corta as casas excedentes ...}
     str(matriz[x,y]:4:1,strg);
     if (length(strg)>4) then delete(strg,5,length(strg)-4);

     setcolor(black);
     if x<(n+1) then
                begin   { escreve o novo elemento da matriz }
                     bar(x*20-9,y*12+61,x*20+8,y*12+70);
                     if matriz[x,y]<>0 then outtextxy(x*20-8,y*12+59,strg);
                end
                else
                begin   { se o valor lido pertence ao termo independente...}
                     bar(x*20-5,y*12+61,x*20+12,y*12+70);
                     if matriz[x,y]<>0 then outtextxy(x*20-4,y*12+59,strg);
                end;

     comcursormouse;
end;


procedure le_valor(x,y:integer);
{ entrada de dados : ler o valor da posicao x,y }
var code:byte;
    xrel,yrel,cod:integer;
    strg:string;
begin
     xrel:=x*20-15;yrel:=y*12+25;
     if (xrel>535) then xrel:=xrel-(xrel-535);
     settextstyle(defaultfont,horizdir,1);
     soltamouse;

     criajanela(xrel,yrel,xrel+100,yrel+50);
     str(x,strg);
     semcursormouse;
     if x=(n+1) then
                outtextxy(xrel+10,yrel+27,'T.indep.')
                else
                outtextxy(xrel+10,yrel+27,'coluna:'+strg);
     str(y,strg);
     outtextxy(xrel+10,yrel+36,'linha :'+strg);
     str(matriz[x,y]:10:5,strg);
     semcursormouse;

    janela(xrel+5,yrel+5,xrel+95,yrel+20);
    janela(xrel+5,yrel+24,xrel+95,yrel+46);
    janela2(xrel+6,yrel+25,xrel+94,yrel+45);
    strg:=CLF_letextoxy(xrel+10,yrel+10,strg,9,code);
    removejanela;

    val(strg,matriz[x,y],cod);
    escreve_valor(x,y);
    soltamouse;
end;


procedure escrevematriz;
{ mostra a matriz atual }
var i,j : integer;
begin
     desenha_grade(n,n);
     for i:=1 to n+1 do
         for j:=1 to n do
              if matriz[i,j]<>0 then escreve_valor(i,j);
end;


procedure mostra_result;
{ mostra o vetor resultado 'X' }
var strg  : string;
    i,x,y : integer;
begin
     settextstyle(defaultfont,horizdir,1);
     setfillstyle(1,lightgray);
     bar(500,65,633,433);
     janela2(500,65,633,433);
     janela(510,100,623,423);
     janela2(511,101,622,422);
     setcolor(black);
     outtextxy(510,75,'Resultado:');
     for i:=1 to n do
         begin
              str(matriz[n+1,i]:0:8,strg);
              outtextxy(515,105+i*10,strg);
         end;
     repeat until (keypressed) or (lemouse(x,y)<>0);
end;


{-------------------------------------------------}
{ Rotinas de E/S em disco                         }
{-------------------------------------------------}
procedure learq(nome:string);
{ le arquivo do disco }
var arquivo:text;
    i,j:integer;
begin
     defpath('','*.mat');
     inic_porcentagem(nome);
     assign(arquivo,nome);
     reset(arquivo);
     readln(arquivo,n);
     for i:=1 to n+1 do
         begin
         for j:=1 to n do
             read(arquivo,matriz[i][j]);
         porcentagem((i*j)/(n*n+n));
         end;
     close(arquivo);
     fecha_porcentagem;
     escrevematriz;
end;


procedure salvaarq(nome:string);
{ salva arquivo em disco }
var arquivo:text;
    i,j:integer;
    aux:double;
begin
     assign(arquivo,nome);
     rewrite(arquivo);
     writeln(arquivo,n);
     for i:=1 to n+1 do
         begin
         for j:=1 to n do
             write(arquivo,matriz[i][j],' ');
         writeln(arquivo);
         end;
     close(arquivo);
end;


{------------------------------------------------------}
{******************************************************}
{ Rotinas de Calculo                                   }
{******************************************************}
{------------------------------------------------------}

procedure solucao;
{ acha os valores de X, apos o pivoteamento ...
  - trabalha com a matriz 'Triangular superior' }
var
   k,i : integer;
   aux : double;
begin
     inic_porcentagem('substituicƒo');
     for k := n downto 1 do
     begin
          if matriz[k,k]<>0 then
          matriz[n+1,k] := matriz[n+1,k]/matriz[k,k];
          for i:=1 to k-1 do
              matriz[n+1,i] := matriz[n+1,i] - matriz[k,i]*matriz[n+1,k];
          porcentagem((n-k)/n);
     end;
     fecha_porcentagem;
end;


procedure pivoteamento;
{ transforma a matriz em TRIANGULAR SUPERIOR;
  OBS.: os valores dos multiplicadores sao guardados na propria matriz,
        abaixo da diagonal principal, ja que os valores dessas posicoes
        foram zerados.
        O multiplicador usado para zerar o elemento Axy esta em x,y
}
var k,i,j     : integer; { variaveis de controle dos LOOPs }
    aux,                 { aux e usada para trocar valores }
    pivot     : double;
begin
     matrizcop:=matriz;
     inic_porcentagem('pivoteamento');
     for k:=1 to (n-1) do      { percorre todas as colunas }
         begin
              pivot:=matriz[k,k];
              linpvt[k]:=k;
              for i:=k to n do
              if abs(matriz[k,i])>abs(pivot) then
                            begin { acha o maior elemento da coluna(pivot) }
                            pivot:=matriz[k,i];
                            linpvt[k]:=i;
                            end;
              if pivot=0 then exit; { se o maior e' zero, termina o iteracao}

              aux:=matriz[k,linpvt[k]]; { troca o elemento k,k com k,pivot }
              matriz[k,linpvt[k]]:=matriz[k,k];
              matriz[k,k]:=aux;

              for i:=k+1 to n do    { acha os multiplicadores }
                  matriz[k,i]:=-matriz[k,i]/matriz[k,k];

              for j:=k+1 to n+1 do
              begin
                   aux:=matriz[j,k];  { troca os demais elementos da linha }
                   matriz[j,k]:=matriz[j,linpvt[k]];
                   matriz[j,linpvt[k]]:=aux;

                   for i:=k+1 to n do { faz a contas }
                   matriz[j,i]:=matriz[j,i]+matriz[k,i]*matriz[j,k];
              end;
              porcentagem(k/(n));
         end;
     fecha_porcentagem;
end;


procedure impressao;
var i,j:integer;
    n1:integer;
begin
     if n>20 then n1:=20 else n1:=n;
     write(lst,#27,#15);    { modo compactado }
     write(lst,#13,#10);    { CR e LF }
     write(lst,'  ');
     for i:=1 to n1+1 do    { imprime no. das colunas }
         write(lst,i:6);

     write(lst,#13,#10);    { CR e LF }
     write(lst,'  ');
     for i:=1 to n1+1 do
         write(lst,'------');

     for i:=1 to n do
         begin
         if i<10 then write(lst,#13,#10,i,' |')
                 else write(lst,#13,#10,i,'|');
         for j:=1 to n1+1 do
             if matriz[j][i]<>0 then write(lst,matriz[j][i]:6:2)
                                else write(lst,'     0');
         end;

     if n1<n then      { se n1 e menor que n , a matriz nao cabe inteira
                         na pagina. Solucao -> dividir a matriz }
             begin
                  write(lst,#13,#10);write(lst,#13,#10);
                  write(lst,'  ');
                  for i:=n1+2 to n+1 do    { no. das colunas }
                  write(lst,i:6);

                  write(lst,#13,#10);

                  write(lst,'  ');
                  for i:=n1+2 to n+1 do
                      write(lst,'------');

                  for i:=1 to n do
                           begin
                                    if i<10 then write(lst,#13,#10,i,' |')
                                       else write(lst,#13,#10,i,'|');
                                    for j:=n1+2 to n+1 do
                                    if matriz[j][i]<>0 then
                                       write(lst,matriz[j][i]:6:2)
                                       else write(lst,'     0');
                           end;
             end;
end;


{------------------------------------------------}
{ Rotinas para controle dos menus                }
{------------------------------------------------}
procedure menu;
var bot,xm,ym:integer;
    col,lin:integer;
    opc:integer;
    fim:boolean;

procedure menuarquivo;
{ opcao arquivo do menu principal }
var opc:integer;
    nome:string;
begin
     settextstyle(defaultfont,horizdir,1);
     opc:=menumouse(100,50,'Ler arquivo/Salvar arquivo/Imprimir');
     if opc<=2 then
               begin
               nome:=ledir(140,70);
               if nome<>'' then
                  case opc of
                    1:learq(nome);
                    2:salvaarq(nome);
                  end;
               end
     else impressao;

end;
procedure novamat;
{ opcao nova matriz do menu principal }
var code:byte;
    cod,i,j:integer;
    strg:string;
begin
     settextstyle(defaultfont,horizdir,1);
     if confirma(230,117,'','A matriz atual na mem¢ria','ser  perdida','')=0
        then begin
                  criajanela(240,117,445,157);
                  janela(250,130,280,145);
                  setcolor(black);
                  outtextxy(285,135,'n£mero de ic¢gnitas');
                  strg:=CLF_letextoxy(255,135,'30',2,code);
                  removejanela;
                  val(strg,n,cod);
                  for i:=1 to n do
                      for j:=1 to n+1 do
                          matriz[j,i]:=0;
                  escrevematriz;
             end;
end;
procedure restauramatriz;
{ opcao restaura mariz do menu principal }
begin
     settextstyle(defaultfont,horizdir,1);
     setcolor(black);
     if confirma(230,170,'',' Restaurar a matriz',' original ?','')=0 then
                                             begin
                                                  matriz:=matrizcop;
                                                  escrevematriz;
                                             end;
end;
procedure desmarca(col,lin:integer);
{ interface grafica - desmarca o elemento sob o mouse }
begin
     if col=(n+1) then
     janela(col*20-6,lin*12+60,col*20+13,lin*12+71)
     else
     janela(col*20-10,lin*12+60,col*20+9,lin*12+71)
end;
procedure marca(col,lin:integer);
{ interface grafica - marca o elemento sob o mouse }
var strg:string;
begin
     if col=(n+1) then
     janela2(col*20-6,lin*12+60,col*20+13,lin*12+71)
     else
     janela2(col*20-10,lin*12+60,col*20+9,lin*12+71);
     setfillstyle(solidfill,lightgray);
     settextstyle(smallfont,horizdir,4);
     setcolor(black);
     bar(21,getmaxy-25,44,getmaxy-16);
     bar(86,getmaxy-25,109,getmaxy-16);
     str(col,strg);
     outtextxy(25,getmaxy-27,strg);
     str(lin,strg);
     outtextxy(90,getmaxy-27,strg);
end;
begin
     fim:=false;
     repeat
     bot:=lemouse(xm,ym);
     if(xm>=10)and(xm<=n*20+9)and(ym>=72)and(ym<=n*12+71)then
             begin { o mouse esta dentro da matriz }
                 if (trunc((xm+10)/20)<>col)or
                    (trunc((ym-60)/12)<>lin)then
                    begin
                         semcursormouse;
                         desmarca(col,lin);{ desmarca elem. anterior }
                         col:=trunc((xm+10)/20);
                         lin:=trunc((ym-60)/12);
                         marca(col,lin);   { marca elem. atual }
                         if (bot<>0)then le_valor(col,lin);
                                          { se clicou - ler novo valor }
                         comcursormouse;
                    end
                 else  if (bot<>0)then le_valor(col,lin);
            end
     else if (xm>=(n+1)*20-6)and(xm<=(n+1)*20+13)and
             (ym>=72)and(ym<=(n*12+71))then
             begin       { o mouse esta dentro do termo independente }
                  if (trunc((xm+6)/20)<>col)or
                    (trunc((ym-60)/12)<>lin)then
                    begin
                         semcursormouse;
                         desmarca(col,lin);
                         col:=trunc((xm+6)/20);
                         lin:=trunc((ym-60)/12);
                         marca(col,lin);
                         if bot<>0 then le_valor(col,lin);
                         comcursormouse;
                    end
                 else  if bot<>0 then le_valor(col,lin);
             end
     else  { senao, verificar menu principal }
     if bot<>0 then
          begin
          opc:=menubox(princmenu,5);
          case opc of
          1:menuarquivo;
          2:begin { opcao 2 = resolver a matriz atual }
                 pivoteamento; { pivoteia a matriz. }
                 solucao;      { acha os valores do vetor solucao, a partir
                                 da matriz diagonal. }
                 mostra_result;{ mostra o vetor solucao. }
                 escrevematriz;{ escreve a matriz escalonada }
            end;
          3:begin
                 novamat;
                 if col>n+1 then col:=n+1; { faz os ajustes no caso de a }
                 if lin>n then lin:=n;     { nova matriz ser menor }
            end;
          4:restauramatriz;
          5:begin
                 settextstyle(defaultfont,horizdir,1);
                 if confirma(230,170,'','','  Sair para o DOS','')=0 then
                                                   fim:=true;
            end;
          end;
          end;

     until fim;
end;

{------------------------------------------------}
{ corpo do programa principal                    }
{------------------------------------------------}
begin
     inicia_video;
     inicia_variaveis;
     desenha_interface;
     desenha_grade(n,n);
     menu;
     semcursormouse;
     fimgrafico;
end.