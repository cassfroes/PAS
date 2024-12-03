(**********************************************)
(*  TRACADOR DE GRAFICOS DE EQUACOES POLARES  *)
(*CASSIANO LUSTOSA FROES - UFRJ/ DRE 931308024*)
(**********************************************)


program polar;

uses crt,graph;

var a,b,n:real;
    param1,param2:integer;
    angulo,raio:real;
    opcao:char;




procedure le_dados;
begin
    window(30,12,70,22);textbackground(green);textcolor(white);
    clrscr;writeln;
    writeln(' entre com os dados da');
    writeln(' equa‡ao polar da forma');
    writeln(' r = a + b*cos(n*',#225,')');writeln;
    write('  a = ');readln(a);
    write('  b = ');readln(b);
    write('  n = ');readln(n);
end;





procedure prepara_grafico;
begin
    param1:=detect;
    initgraph (param1,param2,'');setcolor(yellow);
    line (getmaxx div 2,0,getmaxx div 2,getmaxy);
    line (0,getmaxy div 2,getmaxx,getmaxy div 2);
    setcolor(green);
    settextjustify(lefttext,toptext);
    settextstyle(triplexFont,horizdir,6);
    outtextxy(0,0,'POLAR');
    settextjustify(lefttext,bottomtext);
    settextstyle(sansseriffont,horizdir,1);
    outtextxy(0,getmaxy-10,'<enter> p/ menu') ;
    setcolor(white);
end;


procedure desenha;
var escala,keepx,keepy:longint;
    x0,y0:integer;
    d:char;
begin
    prepara_grafico;
    escala:=20;x0:=getmaxx div 2;y0:=getmaxy div 2;
    angulo:=0;
    keepx:=x0 + round(raio*sin(angulo));
    keepy:=y0 + round(raio*cos(angulo));
    while (angulo<(2*Pi)) do
    begin
      raio:=escala*(a+b*cos(n*angulo));
      line(x0 + round(raio*sin(angulo)),y0 - round(raio*cos(angulo)),keepx,keepy);
      keepx:=x0 + round(raio*sin(angulo));
      keepy:=y0 - round(raio*cos(angulo));
      angulo:=angulo + Pi/180;
    end;
    readLN(d);
    closegraph;
end;

procedure mostra_atual;
begin
     window(40,6,80,12);
     textbackground(yellow);clrscr;
     gotoxy(2,3);
     writeln('Equa‡Æo na mem¢ria:');
     writeln;writeln(' r=',a:1:2,' + ',b:1:2,'*cos(',n:1:2,'*',#225,')');

end;

procedure beep;
begin
     sound(400);delay(100);
     sound(1000);delay(200);
     nosound;
end;

procedure menu;
const hileft=#201;
      horiz=#205;
      hiright=#187;
      loleft=#200;
      loright=#188;
      vert=#186;
var i:integer;
begin
     window(1,1,80,25); textbackground(black);clrscr;
     textcolor(darkgray);textbackground(blue);
     window(1,1,80,4);clrscr;
     for i:=2 to 79 do begin
                            gotoxy(i,1);write(horiz);
                            gotoxy(i,4);write(horiz);
                       end;
     for i:=2 to 3 do begin
                           gotoxy(1,i);write(vert);
                           gotoxy(80,i);write(vert);
                      end;
     window(1,1,80,25);
     gotoxy(1,1);write(hileft);
     gotoxy(80,1);write(hiright);
     gotoxy(1,4);write(loleft);
     gotoxy(80,4);write(loright);
     textcolor(white);
     gotoxy(22,2);write('EQUA€åES POLARES - tra‡ador de gr ficos');
     gotoxy(25,3);write('by Cassiano Lustosa Froes  ',#184,'1993');

     mostra_atual;window(1,1,80,25);
     textbackground(red);window(1,6,35,16);clrscr;
     textbackground(white);window(2,7,34,15);clrscr;
     window(1,1,80,25);
     textcolor(red);gotoxy(14,9);write(#16,' MENU ',#17);
     gotoxy(2,11);textcolor(red);
     write('      T');textcolor(darkgray);writeln('ra‡ar gr fico');
     gotoxy(2,12);
     textcolor(red);write('      E');textcolor(darkgray);
     writeln('ntrar com novos valores');
     gotoxy(2,13);
     textcolor(red);write('      F');textcolor(darkgray);writeln('im');

     textcolor(white);textbackground(blue);
     window(1,18,80,20);clrscr;writeln;
     write(' Fa‡a sua op‡Æo ( T , E , F ) e tecle   <ENTER> ');
     gotoxy(70,16);
     read(opcao);
     opcao:=upcase(opcao);
end;


procedure fim;
var x:integer;
begin
     for x:=1 to 20 do
         begin
         textbackground(white);window(1,1,x*4,x);
         clrscr;delay(25);
         end;
     for x:=20 downto 1 do
         begin
         textbackground(black);window(x*4,x,80,20);
         clrscr;delay(25);
         end;
         window(1,1,80,25);clrscr;
end;

  (********** principal *********)
  (******************************)

begin
     a:=0;b:=3;n:=3;
     repeat
          menu;
          case opcao of
          'T':desenha;
          'E':le_dados;
          else beep;
          end;
     until opcao='F';
     fim;
end.