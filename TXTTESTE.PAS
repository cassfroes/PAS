program teste;
uses clftexto,crt;
var arq:string;
    xa,ya,xb,yb:integer;

Procedure textedit(x1,y1,x2,y2:integer;nome:string);
var fk:boolean;
    ch:char;
    col,lin,colunaatual:integer;
begin
     col:=1;lin:=1;
     texto.le(nome,x1,y1,x2,y2);
     texto.mostra(1,x2-x1,1,y2-y1);
     gotoxy(col,lin);
     colunaatual:=1;
     repeat;
     texto.Inkey(fk,ch);
     if fk=true then case ord(ch) of
                80:begin
                        if lin<(y2-y1) then lin:=lin+1
                        else  texto.mostra(colunaatual,x2-x1,
                                                  y2-y1-1,y2-y1);
                        texto.descelinha;
                   end;
                72:begin
                        if lin>1 then lin:=lin-1
                        else  texto.mostra(colunaatual,x2-x1,
                                                  2,y2-y1);
                        texto.sobelinha;
                   end;
                77:begin
                        if col<255 then col:=col+1;
                        if col>(x2-x1)then begin
                              colunaatual:=colunaatual+1;
                              texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                              end;
                   end;
                75:begin
                        if col>1 then col:=col-1;
                        if col<colunaatual then begin
                              colunaatual:=colunaatual-1;
                              texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                              end;
                   end;
                71:begin
                        colunaatual:=1;
                        col:=1;
                        texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                   end;
                79:begin
                        col:=length(texto.linha^.strg);
                        colunaatual:=col;
                        texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                   end;
{ del }         83:begin
                        texto.dlt(col);
                        texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                   end;
{ ins }         82:texto.insOnOff;
             end;{ fim do C_A_S_E }
          if fk=false then begin
                      texto.input(ch,col);
                      texto.mostra(colunaatual,x2-x1,lin,y2-y1);
                      end;
     gotoxy(col-colunaatual+1,lin);
     until ch=#27;
end;

begin
     {writeln('nome do arquivo :');
     readln(arq);
     writeln('coordenadas da janela: x1,y1,x2,y2');
     readln(xa,ya,xb,yb);
     textedit(xa,ya,xb,yb,arq);}
     textedit(1,1,50,15,'c:\cassiano\txtteste.pas');
end.