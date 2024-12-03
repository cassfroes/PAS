{

        Jogo da Velha
        por Cassiano Lustosa Fr¢es
        abril / 1994

}
program velha;

uses crt,graph,graphnce;


const cor_xis=lightgreen;
      cor_circulo=lightred;
      cor_grade=darkgray;

var tab:array[0..2,0..2]of char;
    xmaximo,ymaximo:integer;
    fim_de_jogo:boolean;

    opc:integer;
    tabopc:tabmenuboxopc;

procedure inicializa_grafico;
begin
     modografico(vga,vgahi);
end;

procedure beep(p1,p2:integer);
begin
     sound(p1);
     delay(p2);
     nosound;
end;


procedure desenha_X(posx,posy:integer);
begin
     semcursormouse;
     setlinestyle(solidln,1,thickwidth);
     setcolor(cor_grade);
     line(3+posx*(xmaximo div 3)+25,3+posy*(ymaximo div 3)+25,
          3+(posx+1)*(xmaximo div 3)-25,3+(posy+1)*(ymaximo div 3)-25);
     line(3+posx*(xmaximo div 3)+25,3+(posy+1)*(ymaximo div 3)-25,
          3+(posx+1)*(xmaximo div 3)-25,3+posy*(ymaximo div 3)+25);
     setcolor(cor_xis);
     line(posx*(xmaximo div 3)+25,posy*(ymaximo div 3)+25,
         (posx+1)*(xmaximo div 3)-25,(posy+1)*(ymaximo div 3)-25);
     line(posx*(xmaximo div 3)+25,(posy+1)*(ymaximo div 3)-25,
         (posx+1)*(xmaximo div 3)-25,posy*(ymaximo div 3)+25);

     comcursormouse;
     setlinestyle(solidln,1,normwidth);
end;

procedure desenha_O(posx,posy:integer);
begin
     semcursormouse;
          setlinestyle(solidln,1,thickwidth);
     setcolor(cor_grade);
     circle(3+(posx*(xmaximo div 3)+(posx+1)*(xmaximo div 3))div 2,
            3+(posy*(ymaximo div 3)+(posy+1)*(ymaximo div 3))div 2,
            (ymaximo div 7));
     setcolor(cor_circulo);

     circle((posx*(xmaximo div 3)+(posx+1)*(xmaximo div 3))div 2,
            (posy*(ymaximo div 3)+(posy+1)*(ymaximo div 3))div 2,
            (ymaximo div 7));

     comcursormouse;
     setlinestyle(solidln,1,normwidth);
end;
procedure desenha_quadro;
begin
     semcursormouse;
     box_cria(0,0,xmaximo+2,ymaximo+2,'');
     setcolor(cor_grade);
     setlinestyle(solidln,1,thickwidth);
     line(xmaximo div 3+3    ,5+3                ,xmaximo div 3+3,
                                                  ymaximo-5+3);
     line((xmaximo div 3)*2+3,5+3                ,(xmaximo div 3)*2+3,
                                                  ymaximo-5+3);
     line(5+3                ,ymaximo div 3+3    ,xmaximo-5+3,
                                                  ymaximo div 3+3);
     line(5+3                ,(ymaximo div 3)*2+3,xmaximo-5+3,
                                                 (ymaximo div 3)*2+3);

     setcolor(lightblue);
     line(xmaximo div 3,5,xmaximo div 3, ymaximo-5);
     line((xmaximo div 3)*2,5,(xmaximo div 3)*2,ymaximo-5);
     line(5,ymaximo div 3,xmaximo-5,ymaximo div 3);
     line(5,(ymaximo div 3)*2,xmaximo-5,(ymaximo div 3)*2);
     comcursormouse;
     setcolor(yellow);
     setlinestyle(solidln,1,normwidth);
     settextstyle(installuserfont('bold'),horizdir,4);
     outtextxy(0,ymaximo,'Jogo da Velha');
end;

procedure inicializa_sistema;
begin
     inicializa_grafico;
     inicmouse;
     comcursormouse;

     xmaximo:=(getmaxx div 3) * 2;
     ymaximo:=(getmaxy div 3) * 2;

     tabopc[1].x1:=getmaxx *3 div 4;tabopc[1].x2:=getmaxx;
     tabopc[1].y1:=0;tabopc[1].y2:=ymaximo div 3-3;
     tabopc[1].txt:='S a i r';

     tabopc[2].x1:=getmaxx*3 div 4;tabopc[2].x2:=getmaxx;
     tabopc[2].y1:=ymaximo div 3+3;tabopc[2].y2:=(ymaximo div 3)*2-3;
     tabopc[2].txt:='Computador Inicia';

     tabopc[3].x1:=getmaxx*3 div 4;tabopc[3].x2:=getmaxx;
     tabopc[3].y1:=(ymaximo div 3)*2+3;tabopc[3].y2:=(ymaximo -3);
     tabopc[3].txt:='Jogador Inicia';

     desenhamenubox(tabopc,3);
     desenha_quadro;
end;
function horiz(i:integer):integer;
var aux:integer;
    num_X,num_O:integer;
begin
     num_X:=0;num_O:=0;
     for aux:=0 to 2 do
         begin
         if (tab[aux][i]='X') then num_X:=num_X+1;
         if (tab[aux][i]='O') then num_O:=num_O+1;
         end;
     if (num_X=2)and(num_O=0)then horiz:=10
        else if (num_O=2)and(num_X=0)then horiz:=20
        else
        begin
             if (tab[0][i]<>'X')and(tab[1][i]<>'X')and(tab[2][i]<>'X')
             then horiz:=1
             else horiz:=0;
        end;

end;
function vert(i:integer):integer;
var aux:integer;
    num_X,num_O:integer;
    vertaux:integer;
begin
     num_X:=0;num_O:=0;
     for aux:=0 to 2 do
         begin
         if (tab[i][aux]='X') then num_X:=num_X+1;
         if (tab[i][aux]='O') then num_O:=num_O+1;
         end;
     if (num_X=2)and(num_O=0)then vert:=10
        else if (num_O=2)and(num_X=0) then vert:=20
        else
        begin
             if (tab[i][0]<>'X')and(tab[i][1]<>'X')and(tab[i][2]<>'X')
             then vert:=1
             else vert:=0;
        end;
end;
function diag_princ:integer;
var aux:integer;
    num_X,num_O:integer;
    vertaux:integer;
begin
     num_X:=0;num_O:=0;
     for aux:=0 to 2 do
         begin
         if (tab[aux][aux]='X') then num_X:=num_X+1;
         if (tab[aux][aux]='O') then num_O:=num_O+1;
         end;
     if (num_X=2)and(num_O=0)then diag_princ:=10
        else if (num_O=2)and(num_X=0) then diag_princ:=20
        else
        begin
             if (tab[0][0]<>'X')and(tab[1][1]<>'X')and(tab[2][2]<>'X')
             then diag_princ:=1
             else diag_princ:=0;
        end;
end;
function diag_sec:integer;
var aux:integer;
    num_X,num_O:integer;
    vertaux:integer;
begin
     num_X:=0;num_O:=0;
     for aux:=0 to 2 do
         begin
         if (tab[aux][2-aux]='X') then num_X:=num_X+1;
         if (tab[aux][2-aux]='O') then num_O:=num_O+1;
         end;
     if (num_X=2)and(num_O=0)then diag_sec:=10
        else if (num_O=2)and(num_X=0) then diag_sec:=20
        else
        begin
             if (tab[0][2]<>'X')and(tab[1][1]<>'X')and(tab[2][0]<>'X')
             then diag_sec:=1
             else diag_sec:=0;
        end;
end;
procedure jogador;
var bot,xcur,ycur:integer;
    x,y:integer;
begin
     repeat
     repeat
     bot:=lemouse(xcur,ycur);
     if (bot<>0)and((xcur>xmaximo)or(ycur>ymaximo))then beep(200,150);
     until (bot<>0)and(xcur<=xmaximo)and(ycur<=ymaximo);

     x:=xcur div (xmaximo div 3);
     y:=ycur div (ymaximo div 3);
     if (tab[x][y]<>#0) then beep(200,150);
     soltamouse;
     until tab[x][y]=#0;
     desenha_X(x,y);
     tab[x][y]:='X';
end;
procedure computador;
var i,j:integer;
    possib:array[0..2,0..2]of integer;
    maior:integer;
    x,y:integer;
begin
     for i:=0 to 2 do
     for j:=0 to 2 do
          begin
          possib[i][j]:=0;
          if (tab[i][j]=#0)then
                begin
                     possib[i][j]:=horiz(j)+vert(i);
                     if i=j then possib[i][j]:=possib[i][j]+diag_princ;
                     if((i=0)and(j=2))or((i=1)and(j=1))or
                       ((i=2)and(j=0))then
                                 possib[i][j]:=possib[i][j]+diag_sec;
                end;
          end;

     maior:=-1;
     randomize;
     for i:=0 to 2 do
         for j:=0 to 2 do
             if (random(10)>=5)then
                  {1}  begin
                       if (possib[i][j]>=maior)and(tab[i][j]=#0)then
                                   begin
                                        maior:=possib[i][j];
                                        x:=i;y:=j;
                                   end
                  {1}  end

                       else {if_random...}
                       if (possib[i][j]>maior)and(tab[i][j]=#0)then
                                   begin
                                        maior:=possib[i][j];
                                        x:=i;y:=j;
                                   end;
     desenha_O(x,y);
     tab[x][y]:='O';
{     if maior=0 then fim_de_jogo:=true;}
end;

procedure ganhou(x1,y1,x2,y2:integer;ch:char);
var i:integer;
begin
     if ch='O'then
         for i:=1 to 20 do
         begin
              beep(100,10);
              beep(i*30,20);
         end
         else
         for i:=7 to 35 do
         begin
              beep(i*10,10);
              beep(200,10);
         end;
     fim_de_jogo:=true;
     setlinestyle(1,1,thickwidth);
     semcursormouse;
     setcolor(red);
     line(x1*(xmaximo div 3)+xmaximo div 6,
          y1*(ymaximo div 3)+ymaximo div 6,
          x2*(xmaximo div 3)+xmaximo div 6,
          y2*(ymaximo div 3)+ymaximo div 6);
     comcursormouse;
     setlinestyle(solidln,1,normwidth);


end;
procedure verifica(ch:char);
var i,j:integer;
    num:integer;
begin
     { horizontal }
     for i:=0 to 2 do
         begin
         num:=0;
         for j:=0 to 2 do
                  if tab[i][j]=ch then num:=num+1;
         if num=3 then ganhou(i,0,i,2,ch);
         end;
     { vertical }
     for j:=0 to 2 do
         begin
         num:=0;
         for i:=0 to 2 do
                  if tab[i][j]=ch then num:=num+1;
         if num=3 then ganhou(0,j,2,j,ch);{i,0,i,2);}
         end;
     { diag. principal }
     num:=0;
     for i:=0 to 2 do
            if tab[i][i]=ch then num:=num+1;
     if num=3 then ganhou(0,0,2,2,ch);
     { diag. secundaria }
     num:=0;
     for i:=0 to 2 do
              if tab[i][2-i]=ch then num:=num+1;
     if num=3 then ganhou(0,2,2,0,ch);

end;

procedure e_velha;
var i,j:integer;
    numvazias:integer;

begin
     numvazias:=0;
     for i:=0 to 2 do
              for j:=0 to 2 do
                  if tab[i][j]=#0 then numvazias:=numvazias+1;
     if numvazias=0 then
                    begin
                    fim_de_jogo:=true;
                    setlinestyle(solidln,1,thickwidth);
                    setcolor(red);
                    semcursormouse;
                    for i:=-5 to 5 do
                    begin
                    line(20+i,20,xmaximo div 2+i,ymaximo-20);
                    line(xmaximo div 2+i,ymaximo-20,xmaximo-20+i,20);
                    end;
                    comcursormouse;
                    setlinestyle(solidln,1,normwidth);
                    end;

end;

procedure jogo_comp;
var i,j:integer;
begin
     fim_de_jogo:=false;
     for i:=0 to 2 do
              for j:=0 to 2 do
                  tab[i][j]:=#0;
     desenha_quadro;
     repeat

 (**)
     computador;
     verifica('O');

     e_velha;
     if not fim_de_jogo then begin
                             jogador;
                             verifica('X');
                             end;
     until fim_de_jogo;
end;

procedure jogo_plr;
var i,j:integer;
begin
     fim_de_jogo:=false;
     for i:=0 to 2 do
              for j:=0 to 2 do
                  tab[i][j]:=#0;
     desenha_quadro;
     repeat
     jogador;
     verifica('X');
 (**)
     e_velha;
     if not fim_de_jogo then
     begin
     computador;
     verifica('O');
     end;
 (**)

     until fim_de_jogo;
end;

begin
     inicializa_sistema;
     beep(1000,50);beep(300,40);beep(700,50);
     repeat
     opc:=menubox(tabopc,3);
     if opc=2 then jogo_comp
        else if opc=3 then jogo_plr;
     until opc=1;
     fimgrafico;
end.