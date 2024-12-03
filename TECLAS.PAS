
program teclas;

uses crt;

var  ch : char;
     i  : integer;
     fim: boolean;

Procedure finaliza;
var sn:char;
begin
     writeln;writeln(' Sair ? (s/n)');
     sn:=readKey;
     if (upcase(sn)='S') then fim:=true
        else fim:=false;
     if sn=#0 then sn:=readkey;
end;

Procedure testach;
begin
     if ch=#0 then begin
                   writeln('Tecla de Fun‡Æo :  #0+');
                   ch:=readkey;
                   writeln('#',ord(ch));
                   end
       else begin
            writeln(ch);
            writeln('#',ord(ch));
            end;
end;


Begin
     repeat
           gotoxy(1,24);
           for i:=1 to 25 do begin
                             writeln;
                             delay(50);
                             end;
           gotoxy(1,1);
           writeln(' T e c l a s');
           writeln;
           writeln('Pressione qualquer tecla para saber o c¢digo ASC II');
           writeln;
           ch:=readKey;
           testach;
           finaliza;
     until fim=true;
end.

