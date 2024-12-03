{       Cassiano Lustosa Froes     }
{           setembro / 1993        }
program teste;
uses clftxt,crt;
var arq:string;
    xa,ya,xb,yb:integer;

Procedure textedit(x1,y1,x2,y2:integer;nome:string);
var fk:boolean;
    ch:char;
    i:integer;
begin
     texto.defcor(lightblue,lightgray,blue);  {   define cores para  }
                                              {moldura,bkground,texto}
     texto.le(nome,x1,y1,x2,y2);   { le o arquivo e cria janela }
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
     textcolor(yellow);textbackground(blue);
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
     if upcase(ch)='S' then texto.grava;
     texto.fecha;
end;

begin
     writeln('nome do arquivo :');
     readln(arq);
     writeln('coordenadas da janela: x1,y1,x2,y2');
     readln(xa,ya,xb,yb);
     textedit(xa,ya,xb,yb,arq);
     {textedit(4,4,40,20,'c:\bp\bin\clfedit.pas');}
end.