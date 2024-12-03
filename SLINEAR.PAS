{     sistemas de equaá‰es lineares    }
{      UFRJ  -  1993 / 2o. per°odo     }

program sistemas_lineares;
uses crt,graph;
var elemento,
    clone         :  array[1..50] of array[1..50] of real;

    maxcol,maxlin,
    numicog,numeq,
    pos           :  integer;

    escolha       :  char;

    impossivel,
    passo_a_passo :  boolean;

    P,P1          :  pointer;


Procedure mostra_matriz;forward;
Procedure beep(som,tempo:integer);
begin
     sound(som);delay(tempo);
     nosound;
end;

Procedure box(x1,y1,x2,y2,cor1,cor2,cor3,cor4:integer;texto:string);
begin
     settextjustify(centertext,centertext);
     setlinestyle(solidln,0,normwidth);
     setcolor(cor1);setfillstyle(solidfill,cor1);
     bar(x1,y1,x2,y2);
     setcolor(cor2);
     moveto(x1,y2);
     lineto(x1,y1);lineto(x2,y1);
     setcolor(cor3);
     lineto(x2,y2);lineto(x1,y2);moveto(x1+1,y2-1);
     lineto(x2-1,y2-1);lineto(x2-1,y1+1);
     setcolor(cor2);moveto(x2-2,y1+1);
     lineto(x1+1,y1+1);lineto(x1+1,y2-2);
     setcolor(cor4);
     outtextxy((x1+x2)div 2,(y1+y2)div 2-3,texto);
end;

Procedure apresenta;
var dr,mo:integer;
    errorcode:integer;
    size:word;
    strg:string;
begin
     dr:=detect;
     InitGraph(dr,mo,'c:\bp\bgi');
     errorcode:=graphresult;
     if errorcode<>grok then begin
                             writeln('## ERRO :',grapherrormsg(errorcode));
                             halt;
                             end;
     setRGBpalette(1,35,0,0);      { cor de fundo }
     setRGBpalette(2,35,35,35);    { cinza escuro }
     setRGBpalette(3,50,50,50);    { cinza claro  }
     setRGBpalette(5,63,63,63);
     setRGBpalette(4,0,0,45);
     setbkcolor(1);
     box(10,10,getmaxx-10,120,3,5,2,4,'');
     setcolor(4);
     Settextjustify(centertext,toptext);
     settextstyle(Triplexfont,horizdir,4);
     setcolor(2);
     strg:='Sistemas de Equa'+#135+'oes Lineares';
     outtextxy(getmaxx div 2,20,strg);
     outtextxy(getmaxx div 2+63,18,#126);
     setcolor(4);
     outtextxy(getmaxx div 2 +2,22,strg);
     outtextxy(getmaxx div 2 + 65,20,#126);
     settextstyle(defaultfont,horizdir,1);
     outtextxy(getmaxx div 2,70,'Universidade Federal do Rio de Janeiro ');
     settextjustify(lefttext,toptext);
     outtextxy(50,85,'por Cassiano Lustosa Fr¢es da Silva');
     outtextxy(50,95,'    Irineu Thiago de Oliveira Rangel');
     outtextxy(50,105,'    Marcio de Almeida Monteiro');
     box(120,135,getmaxx-10,getmaxy-30,3,5,2,4,'');
     box(125,140,getmaxx-15,getmaxy-35,3,2,5,4,'');
     setfillstyle(1,7);
     bar(12,137,98,183);
     bar(10,248,115,273);
     size:=Imagesize(12,137,98,183);
     Getmem(P,size);
     getImage(12,137,98,183,P^);
     size:=Imagesize(12,248,115,273);
     Getmem(P1,size);
     getImage(12,248,115,273,P1^);
     pos:=137;
end;

Procedure zera_matriz;
var i,j:integer;
begin
     for i:=1 to 50 do
         for j:=1 to 50 do
          begin
           clone[i][j]:=0;
           elemento[i][j]:=0;
          end;
end;

Function menu:char;
var ch:char;
begin
     setfillstyle(solidfill,0);
     bar(8,137,117,305);
     settextstyle(Triplexfont,horizdir,1);
     SetUsercharsize(1,2,4,3);
     box(10,135,100,185,3,5,2,4,'Ler matriz');
     box(10,195,100,245,3,5,2,4,'Calcular');
     box(10,255,100,305,3,5,2,4,'Alterar');
     box(10,315,100,365,3,5,2,4,'Sair');
     PutImage(12,pos,P^,XORPut);
     repeat
     ch:=ReadKey;
     if (ch=#0) then
        begin
        PutImage(12,pos,P^,XORPut);
        ch:=Readkey;
        case ord(ch) of
          72:pos:=pos-60;
          80:pos:=pos+60;
          75:pos:=pos-60;
          77:pos:=pos+60;
          end;
        if pos>317 then pos:=137;
        if pos<137 then pos:=317;
        PutImage(12,pos,P^,XORPut);
        end;
     until (ch=#13);
     case pos of
          137:menu:='L';
          197:menu:='C';
          257:menu:='A';
          317:menu:='F';
          end;
end;

Function entra(x,y:integer):string;
var ch:char;
    strg:string;
    ok:integer;
begin
     strg:='';
     repeat
           repeat
           outtextxy(x,y,#177);delay(50);
           setcolor(3);outtextxy(x,y,#177);delay(50);
           setcolor(4);
           until keypressed;
           ch:=Readkey;
           if (ch<>#13) and (ch<>#0) and (ch<>#8) then begin
                           outtextxy(x,y,ch);
                           x:=x+7;
                           strg:=strg+ch;
                           end;
           if ch=#8 then begin
                         setcolor(3);outtextxy(x-7,y,strg[length(strg)]);
                         setcolor(4);
                         delete(strg,length(strg),1);
                         x:=x-7;
                         end;
     until ch=#13;
     entra:=strg;
end;


Procedure le_matriz;
var    contacol,contalin,ok,ok1:integer;
       strg:string;
begin
     zera_matriz;
     settextstyle(defaultfont,horizdir,1);
     settextjustify(lefttext,toptext);
     setfillstyle(1,3);bar(130,145,getmaxx-20,getmaxy-40);
     setviewport(130,145,getmaxx-20,getmaxy-40,true);
     setcolor(4);
     impossivel:=false;
     zera_matriz;
     repeat
      outtextxy(0,10,'n£mero de inc¢gnitas : ');strg:=entra(180,10);
       val(strg,numicog,ok);
      strg:='n'+#163+'mero de equa'+#135+#147+'es   : ';
      outtextxy(0,20,strg);strg:=entra(180,20);
       val(strg,numeq,ok);
     until (maxcol<=50) and (maxlin<=50);
     maxcol:=numicog+1;
     maxlin:=numeq;
     beep(500,50);
     outtextxy(10,35,'Entre com os coeficientes :');
     for contalin:=1 to maxlin do
     begin
         for contacol:=1 to maxcol do
             begin
              strg:=entra((contacol*35)-30,(contalin*11)+40);
              val(strg,elemento[contacol][contalin],ok);
              clone[contacol][contalin]:=elemento[contacol][contalin];
             end;
     end;
     setviewport(0,0,getmaxx,getmaxy,true);
end;

Procedure altera_matriz;
var i,j,ok:integer;
    strg:string;
    ch:char;
begin
     setviewport(130,145,getmaxx-30,getmaxy-40,true);
     setfillstyle(solidfill,3);
     bar(0,0,480,583);
     settextstyle(defaultfont,horizdir,1);
     settextjustify(lefttext,toptext);
     for j:=1 to maxlin do
         for i:=1 to maxcol do
             elemento[i][j]:=clone[i][j];
     setcolor(2);
     mostra_matriz;
     i:=1;j:=1;
     repeat
       setcolor(4);
       str(elemento[i][j]:3:2,strg);outtextxy(i*50-45,j*12+20,strg);
       ch:=Readkey;
       if ch=#0 then begin
                     setcolor(2);outtextxy(i*50-45,j*12+20,strg);
                     ch:=Readkey;
                     case ord(ch) of
                       75:i:=i-1;
                       77:i:=i+1;
                       72:j:=j-1;
                       80:j:=j+1;
                      end;
                     if i<1 then i:=maxcol;
                     if i>maxcol then i:=1;
                     if j<1 then j:=maxlin;
                     if j>maxlin then j:=1;
                     end;
      if ch=#13 then begin
                     bar(i*50-45,j*12+20,(i+1)*50-46,(j+1)*12+18);
                     strg:=entra(i*50-45,j*12+20);
                     val(strg,elemento[i][j],ok);
                     clone[i][j]:=elemento[i][j];
                     bar(i*50-45,j*12+20,(i+1)*50-46,(j+1)*12+18);
                     end;
     until ch=#27;
     setviewport(0,0,getmaxx,getmaxy,true);
end;


Procedure multiplica(linha:integer;escalar:real);
var i:integer;
begin
     for i:=1 to maxcol do
        elemento[i][linha]:=(elemento[i][linha])*escalar;
end;


Procedure divide(linha:integer;escalar:real);
var i:integer;
begin
     for i:=1 to maxcol do
        elemento[i][linha]:=elemento[i][linha]/escalar;
end;


Procedure diminui(lin1,lin2:integer);   {* faz lin1-lin2-- resultado *}
var i:integer;                          { fica em lin1                }
begin
     for i:=1 to maxcol do
         elemento[i][lin1]:=elemento[i][lin1]-elemento[i][lin2];
end;


Procedure troca(lin1,lin2:integer);
var i:integer;
    aux:real;
begin
     for i:=1 to maxcol do
      begin
         aux:=elemento[i][lin1];
         elemento[i][lin1]:=elemento[i][lin2];
         elemento[i][lin2]:=aux;
      end;
end;



Function verifica(var coluna:integer):boolean;
var i:integer;
begin
     if elemento[coluna][coluna]<>0 then verifica:=true
        else begin
               verifica:=false;
               i:=coluna+1;
               while i<=maxlin do
                begin
                   if elemento[coluna][i]<>0 then
                                               begin
                                                  troca(i,coluna);
                                                  verifica:=true;
                                                  i:=(maxlin+1);
                                               end;
                   i:=i+1;
                end;
             end;
end;



procedure mostra_matriz;
var x,y : integer;
    strg: string;
begin
     for x:=1 to maxlin do
         begin
         for y:=1 to maxcol do
             begin
             str(elemento[y][x]:3:2,strg);
             outtextxy(y*50-45,x*12+20,strg);
             end;
         end;
end;


Procedure simplifica;
var contalin,contacol:integer;
    diferentes_de_zero:integer;
    divisor:real;
begin
     diferentes_de_zero:=0;
     for contalin := 1 to maxlin do
         begin
         for contacol := 1 to (maxcol-1) do
              if elemento[contacol][contalin]<>0
                then begin
                         diferentes_de_zero:=diferentes_de_zero + 1;
                         divisor:=elemento[contacol][contalin];
                     end;
         if diferentes_de_zero=0 then
                                 if elemento[maxcol][contalin]<>0
                                      then impossivel:=true
                                  else
                                  numeq:=numeq-1;

         if diferentes_de_zero=1 then
                           divide(contalin,divisor);
         diferentes_de_zero:=0;
         end;
end;


function menu_calcula:boolean;
var ch:char;
    pos1:integer;
begin
     pos1:=278;
     setusercharsize(1,2,1,2);
     box(8,246,117,275,3,5,2,4,'passo a passo');
     box(8,276,117,305,3,5,2,4,'s¢ resultado');
     repeat
     PutImage(10,pos1,P1^,XORPut);
       ch:=Readkey;
       if ch=#0 then begin
                     ch:=ReadKey;
                     PutImage(10,pos1,P1^,XORPut);
                     if (ord(ch)=72) or (ord(ch)=80) then
                        if pos1=248 then pos1:=278
                           else pos1:=248;
                     end;
     until ch=#13;
     if pos1=248 then menu_calcula:=true
         else menu_calcula:=false;
end;

Procedure calcula;
var contalin,k:integer;
    aux:real;
    sege:boolean;
    le:char;
    strg:string;
begin
     passo_a_passo:=menu_calcula;
     settextstyle(defaultfont,horizdir,1);
     settextjustify(lefttext,toptext);
     setfillstyle(1,3);bar(130,145,getmaxx-30,getmaxy-40);
     setviewport(130,145,getmaxx-30,getmaxy-40,true);
     if passo_a_passo=true then begin
             bar(0,0,480,583);
             mostra_matriz;
             outtextxy(0,maxlin*12+40,
                   'pressione qualquer tecla para iniciar o escalonamento');
             le:=ReadKey;
             end;
     for contalin:=1 to maxlin do
     begin
          sege:=verifica(contalin);  {verifica se o elem contalin,contalin}
                                     {nao Ç zero;se for, troca a linha com}
          if sege=true               {a pr¢xima que n∆o seja zero.        }
          then                       {se h† linha com elemento dif. de zero}
          for k:=1 to maxlin do
          if (k<>contalin) and (elemento[contalin][k]<>0) then
                   begin
                     aux:=elemento[contalin][k];
                     multiplica(k,elemento[contalin][contalin]);
                     multiplica(contalin,aux);
                     diminui(k,contalin);
                     divide(contalin,aux);
                     if passo_a_passo=true then begin
                                           bar(0,0,480,583);
                                           mostra_matriz;
                                           outtextxy(0,maxlin*12+40,
                                             'qualquer tecla para continuar');
                                           le:=Readkey;
                                           end;
                   end;
     end;
     simplifica;
     bar(0,0,480,583);
     mostra_matriz;
     if impossivel=true then outtextxy(0,maxlin*10+50,
                        ' * * SISTEMA IMPOSSIVEL * * ')
        else
          if numicog-numeq<>0 then
                begin
                  outtextxy(0,maxlin*10+40,
                  'Dimensao do espaáo soluáao : ');
                  outtextxy(50,maxlin*10+37,#126);
                  outtextxy(193,maxlin*10+37,#126);
                  str((numicog-numeq),strg);
                  outtextxy(230,maxlin*10+40,strg);
                end
               else begin
                         outtextxy(0,maxlin*10+40,'A soluáao Ç um ponto');
                         outtextxy(57,maxlin*10+37,#126);
                    end;
     setviewport(0,0,getmaxx,getmaxy,true);
end;



(*******   PRINCIPAL  (vulgo main) ********)
BEGIN
     apresenta;
     repeat
       escolha:=menu;
       beep(700,50);
       case escolha of
          'L':le_matriz;
          'A':altera_matriz;
          'C':calcula;
          end;
     until escolha='F';
     closegraph;
     writeln('Sistemas de equaá',#148,'es lineares');
     writeln('Universidade Federal do Rio de Janeiro       setembro/1993');
     writeln;
     writeln('----------------------------------------------------------');
END.