(*   exibe caracteres ASCII   *)
(*   Cassiano Lustosa Fr¢es   *)
(*       junho - 1993         *)

program ascII;

uses crt,graph;

var i,cor:integer;
    dr,mo:integer;
procedure cabecalho;
begin
     window(1,1,80,4);
     textbackground(magenta);
     clrscr;
     textcolor(white);
     writeln('':29,'* C¢digos ASC II *');
     textcolor(blue);
     writeln('':18,'copyright',#184,'1993  by Cassiano Lustosa Fr¢es');
     writeln('':20,'Universidade Federal do Rio de Janeiro');
end;

procedure fim;
begin
 repeat
       textcolor(red);gotoxy(1,20);
       write('pressione qualquer tecla para sair');delay(200);
       textcolor(green);
       gotoxy(1,20);
       write('pressione qualquer tecla para sair');delay(200);
 until keypressed;
 textcolor(yellow);
 clrscr;
end;

begin
    dr:=detect;
    initgraph(dr,mo,'c:\bp\bgi');
    {window(1,1,80,25);clrscr;
    cabecalho;
    window(1,4,80,25);
    textcolor(lightgray);
    textbackground(black);
    clrscr;}
    for i:=0 to 255 do
        begin
              write(i);
              write(chr(i),' ');
        end;

    writeln;
    readln;
    {fim;}

end.