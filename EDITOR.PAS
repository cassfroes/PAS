{       Cassiano Lustosa Froes     }
{           setembro / 1993        }
unit editor;

interface
uses clftxt,crt;
var arq:string;
    xa,ya,xb,yb:integer;

(*Procedure textedit(x1,y1,x2,y2:integer;nome:string);*)
Function menubarra(x1,y1:integer;opcoes:string):integer;

implementation

Procedure menu_arquivo;
var opc:integer;
begin
     opc:=menubarra(3,3,'Abrir/Fechar/Novo/Sair');
end;
(*Procedure textedit(x1,y1,x2,y2:integer;nome:string);
var fk:boolean;
    ch:char;
    i:integer;
begin

     repeat;
     texto.Inkey(fk,ch);
     if fk=true then case ord(ch) of    { tecla de funcao }
{ setas }       80:texto.descelinha;
                72:texto.sobelinha;
                77:texto.movdir;
                75:texto.movesq;
{ home }        71:texto.casa;
{ end }         79:texto.fimlinha;
{ del }         83:texto.dltcaracter;
{ ins }         82:texto.insOnOff;
{ pgup }        73:texto.sobepagina;
{ pgdown }      81:texto.descepagina;

{alt-A}         30:menu_arquivo;
             end{ fim do C_A_S_E }
          else if ch<>#27 then                    {se nao e tecla de}
                case ord(ch) of
                13:texto.novalinha;
                3:texto.ultima_linha;
                18:texto.primeira_linha;
                25:texto.dltlinha;
                else if (ord(ch)>31)and(ord(ch)<176)then texto.input(ch);
                end;
     until ch=#27;
     writeln;
     {textcolor(yellow);textbackground(blue);
     repeat
     for i:=1 to 31 do
         begin
              gotoxy(i,1);write(#176);
              gotoxy(i,3);write(#176);
         end;
     gotoxy(1,2);
     writeln('  Gravar altera‡oes ? (s/n)    ');
     gotoxy(28,2);ch:=Readkey;write(ch);
     until (upcase(ch)='S') or (upcase(ch)='N');
     if upcase(ch)='S' then texto.grava;}
     texto.fecha;
end;
*)
Function menubarra(x1,y1:integer;opcoes:string):integer;
var i,n:integer;
    op:array[1..16]of string;
begin
     n:=1;
     op[1]:='';
     for i:=1 to length(opcoes) do
              begin
                   if opcoes[i]='/' then
                                    begin
                                         n:=n+1;
                                         op[n]:=''
                                    end
                   else op[n]:=op[n]+opcoes[i];
              end;
     textbackground(lightgray);
     textcolor(black);
     for i:=1 to n do
         begin
         gotoxy(x1+1,y1+i);
         write(op[i]);
         end;
     readln;

end;
end.
(*
begin
     writeln('nome do arquivo :');
     readln(arq);
     writeln('coordenadas da janela: x1,y1,x2,y2');
     readln(xa,ya,xb,yb);
     textedit(xa,ya,xb,yb,arq);
     {textedit(4,4,40,20,'c:\bp\bin\clfedit.pas');}
end.
*)