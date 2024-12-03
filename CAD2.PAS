(*********************************************)
(* PROGRAMA CADASTRO [AGENDA] - USES TACCESS *)
(*                              ============ *)
(*  AUTOR: CASSIANO LUSTOSA FR‡ES DA SILVA   *)
(*********************************************)

Program Cad2;
uses taccess,crt;
type tiporeg=record
             nome:string[40];
             endereco:string[40];
             cidade:string[15];
             cep:string[10];
             telefone:string[15];
             end;
var cadastro:datafile;
    indice:indexfile;
    nomearq,nomeindice:string;
    posicao:longint;
    j:integer;



procedure janela(x0,y0,x1,y1,corfundo,corborda:integer;
                 tipoborda:char);
var esqcima,esqbaixo,dircima,dirbaixo,vert,hor:char;
    i:integer;
begin
     if tipoborda='D' then begin
                                esqcima:=#201;esqbaixo:=#200;
                                dircima:=#187;dirbaixo:=#188;
                                vert:=#186;hor:=#205;
                           end
                      else begin
                                esqcima:=#218;esqbaixo:=#192;
                                dircima:=#191;dirbaixo:=#217;
                                vert:=#179;hor:=#196;
                           end;
     textbackground(corfundo);textcolor(corborda);
     window(x0,y0,x1,y1);clrscr;window(1,1,80,25);
     for i:=x0+1 to x1-1 do
                          begin
                          gotoxy(i,y0);write(hor);
                          gotoxy(i,y1);write(hor);
                          end;
     for i:=y0+1 to y1-1 do
                          begin
                          gotoxy(x0,i);write(vert);
                          gotoxy(x1,i);write(vert);
                          end;
     gotoxy(x0,y0);write(esqcima);
     gotoxy(x0,y1);write(esqbaixo);
     gotoxy(x1,y1);write(dirbaixo);
     gotoxy(x1,y0);write(dircima);
end;



procedure beep(a,b:integer);
begin
     sound(a);
     delay(b);
     nosound;
end;


procedure lenomearq;
begin
     readln(nomearq);
     nomeindice:=nomearq+'.NDX';
     nomearq:=nomearq+'.DAT';
end;

procedure cria_arquivo;
begin
     write('criar arquivo ');
     lenomearq;
     makefile(cadastro,nomearq,SizeOf(tiporeg));
     makeindex(indice,nomeindice,40,noduplicates);
end;


procedure abre_arquivo;
begin
     write('abrir arquivo ');
     lenomearq;
     openfile(cadastro,nomearq,SizeOf(tiporeg));
     openindex(indice,nomeindice,40,noduplicates);
end;

procedure apresenta;
var i:integer;
    opcao:char;
begin
     textbackground(lightgray);clrscr;
     i:=0;
     while i<20 do
         begin
              textbackground(black);
              window(40-i,13-i div 3,40+i,13+i div 3);clrscr;
              delay(100);
              i:=i+3
         end;
     janela(20,7,60,20,black,red,'f');
     janela(35,9,44,11,black,red,'f');
     beep(300,100);
     gotoxy(36,10);textcolor(white);
     writeln('CADASTRO');
     window(21,12,59,19);
     writeln('  (c) 1993 by Cassiano Lustosa Froes');
     writeln;textcolor(lightgray);
     writeln('   Tecle F1 para criar novo arquivo');
     writeln('         ou outra tecla para');
     write('      usar arquivo j† existente');
     repeat
     opcao:=readkey
     until opcao<>'';writeln;beep(700,100);writeln;
     if (opcao=#0) then opcao:=readkey;
     if ord(opcao)=59 then cria_arquivo
                 else abre_arquivo;
end;

procedure menu;
forward;

procedure fim;
var ch:char;
begin
     janela(30,10,50,14,yellow,blue,'D');
     window(31,12,49,13);
     writeln('   sair ?   N');
     gotoxy(13,1);
     repeat
     ch:=readkey
     until (upcase(ch)='S') or (upcase(ch)='N') or (ch=#13);
     if ch=#13 then ch:='N';
     writeln(ch);
     if (upcase(ch)<>'S') then menu
          else delay(1000);
end;


procedure incluir_nomes;
var incl:tiporeg;
    ch:char;
    posicao:longint;
begin
     repeat
       janela(25,11,78,22,black,yellow,'s');
       window(26,12,77,21);writeln('** Incluir Nomes **');
       textcolor(lightgray);
       writeln;write('nome : ');textcolor(yellow);
       readln(incl.nome);textcolor(lightgray);
       if incl.nome<>'' then begin
               write('endereáo : ');textcolor(yellow);
               readln(incl.endereco);textcolor(lightgray);
               write('cidade : ');textcolor(yellow);
               readln(incl.cidade);textcolor(lightgray);
               write('CEP : ');textcolor(yellow);
               readln(incl.cep);textcolor(lightgray);
               write('telefone : ');textcolor(yellow);
               readln(incl.telefone);
               writeln;textcolor(white);write(' Correto ? (s/n)');
               ch:=readkey;ch:=upcase(ch)
               end
               else ch:='S';
     if incl.nome<>'' then
              begin
                   addrec(cadastro,posicao,incl);
                   addkey(indice,posicao,incl);
              end;
     until incl.nome='';
     menu;
end; {incluir nomea}


procedure excluir_nomes;
var nomeaux:string[40];
    ch:char;
begin
     janela(30,10,77,24,black,magenta,'a');window(31,11,76,23);
     textcolor(lightmagenta);
     writeln('** excluir nomes **');window(31,13,76,23);
     textcolor(lightgray);
     writeln(' nome a ser exclu°do :');
     textcolor(lightmagenta);
     write(' ');readln(nomeaux);
     while nomeaux<>'' do
     begin
      findkey(indice,posicao,nomeaux);
      if ok then begin
                textcolor(lightgray);
                writeln;write(' Confirma ? (s/n)');
                ch:=readkey;
                if upcase(ch)='S' then begin
                                       deleterec(cadastro,posicao);
                                       deletekey(indice,posicao,nomeaux);
                                       writeln;textcolor(white);
                                       writeln;
                                       writeln(' ok.Exclusao conclu°da.');
                                       end
                                   else beep(500,100)
                end
      else begin
          beep(500,100);writeln;textcolor(lightgray);
          writeln(' nome n∆o registrado');
          end;
      ch:=readkey;
      clrscr;textcolor(lightgray);
      writeln(' nome a ser exclu°do :');textcolor(lightmagenta);
      write(' ');readln(nomeaux);
     end;
     menu;
end;{excluir nomes}




procedure alterar_dados;
var lido,auxiliar:tiporeg;
    ch:char;
begin
     janela(15,8,77,24,black,cyan,'s');
     textcolor(lightcyan);window(16,9,76,23);
     writeln('** alterar dados **');window(16,11,76,23);
     textcolor(lightgray);write(' nome : ');
     textcolor(lightcyan);readln(auxiliar.nome);
    while auxiliar.nome<>'' do
    begin
     findkey(indice,posicao,auxiliar.nome);
     if ok then
           begin
                clrscr;
                getrec(cadastro,posicao,lido);
                textcolor(lightgray);writeln(' nome : ',lido.nome);
                write(' novo nome : ');textcolor(lightcyan);
                readln(auxiliar.nome);
                if auxiliar.nome='' then begin
                                         auxiliar.nome:=lido.nome;
                                         gotoxy(14,2);
                                         writeln(auxiliar.nome);
                                         end;
                textcolor(lightgray);writeln(' endereáo : ',lido.endereco);
                write(' novo end. : ');textcolor(lightcyan);
                readln(auxiliar.endereco);
                if auxiliar.endereco='' then begin
                                        auxiliar.endereco:=lido.endereco;
                                        gotoxy(14,4);
                                        writeln(auxiliar.endereco);
                                        end;
                textcolor(lightgray);writeln(' cidade : ',lido.cidade);
                write(' nova cid. : ');textcolor(lightcyan);
                readln(auxiliar.cidade);
                if auxiliar.cidade='' then begin
                                      auxiliar.cidade:=lido.cidade;
                                      gotoxy(14,6);
                                      writeln(auxiliar.cidade);
                                      end;
                textcolor(lightgray);writeln(' CEP : ',lido.cep);
                write(' novo CEP  : ');textcolor(lightcyan);
                readln(auxiliar.cep);
                if auxiliar.cep='' then begin
                                   auxiliar.cep:=lido.cep;
                                   gotoxy(14,8);
                                   writeln(auxiliar.cep);
                                   end;
                textcolor(lightgray);writeln(' telefone : ',lido.telefone);
                write(' novo tel. : ');textcolor(lightcyan);
                readln(auxiliar.telefone);
                if auxiliar.telefone='' then begin
                                        auxiliar.telefone:=lido.telefone;
                                        gotoxy(14,10);
                                        writeln(auxiliar.telefone);
                                        end;
                textcolor(white);writeln;
                writeln(' confirma ? (s/n) ');ch:=readkey;
                if upcase(ch)='S' then begin
                                       if lido.nome=auxiliar.nome then
                                          putrec(cadastro,posicao,auxiliar)
                                          else begin
                                               deletekey(indice,posicao,lido);
                                               deleterec(cadastro,posicao);
                                               addkey(indice,posicao,
                                                        auxiliar.nome);
                                               addrec(cadastro,posicao,
                                                        auxiliar);
                                               end;
                                          writeln(' ok.Alteraá∆o efetuada');
                                       end;
           end
      else begin
           textcolor(white);writeln;writeln(' nome n∆o existente');
           ch:=readkey;
           end;
     clrscr;
     textcolor(lightgray);write(' nome : ');
     textcolor(lightcyan);readln(auxiliar.nome);
      end;
     menu;
end;

procedure ler_nomes;
var nomeaux:string[40];
    ch:char;
    lido:tiporeg;
begin
    janela(30,10,77,24,black,blue,'a');window(31,11,76,23);
    textcolor(lightblue);
    writeln('** Ler dados **');textcolor(lightgray);window(31,13,76,23);
    writeln(' procurar por:   ( <enter> retorna p/ menu )');writeln;
    textcolor(lightblue);write(' ');readln(nomeaux);
    while nomeaux<>'' do
          begin
               searchkey(indice,posicao,nomeaux);
               if not ok then begin
                                textcolor(white);
                                write('nome n∆o registrado');
                                end
               else

                 repeat
                    getrec(cadastro,posicao,lido);
                    clrscr;writeln;textcolor(lightgray);
                    writeln('nome');textcolor(lightblue);
                    writeln(lido.nome);textcolor(lightgray);
                    writeln('endereáo');textcolor(lightblue);
                    writeln(lido.endereco);textcolor(lightgray);
                    writeln('cidade           CEP');textcolor(lightblue);
                    writeln(lido.cidade,'':(17-length(lido.cidade)),
                                          lido.cep);textcolor(lightgray);
                    writeln('telefone');textcolor(lightblue);
                    writeln(lido.telefone);
              (*inicio muda*)
                  textcolor(white);writeln;writeln(' <',#26,'>pr¢ximo      <',
                                           #27,'>anterior');
                  writeln(' <enter>procurar outro');ch:=readkey;beep(800,20);
                  if (ch=#0) then begin
                                   ch:=readkey;
                                   case ord(ch) of
                                   77:nextkey(indice,posicao,nomeaux);
                                   75:prevkey(indice,posicao,nomeaux);
                                   end;
                                  end;
               until ch=#13;
             textcolor(lightgray);clrscr;
             writeln(' procurar por:  ( <enter> retorna p/ menu )');
             writeln;
             textcolor(lightblue);write(' ');
             readln(nomeaux);
          end;
          menu;
    end;


procedure menu;
var i:integer;
    ch:char;
    opcoes:array [1..5] of string[15];
begin
     opcoes[1]:='   Ler dados   ';opcoes[2]:=' Incluir nomes ';
     opcoes[3]:=' Excluir nomes ';opcoes[4]:=' Alterar dados ';
     opcoes[5]:='     F i m     ';
     window(1,1,80,25);
     textbackground(lightgray);clrscr;
     textcolor(black);writeln;
     writeln('   arquivo em uso ',#26,' ',nomearq);
     janela(10,5,45,23,black,green,'D');
     textcolor(darkgray);
          for i:=11 to 46 do begin
                        gotoxy(i,24);write(#178);end;
     for i:=6 to 23 do begin
                       gotoxy(46,i);write(#178);end;
     window(11,6,44,22);textcolor(lightgreen);
     gotoxy(12,2);writeln(#175,' M E N U ',#174);
     gotoxy(12,3);writeln('ÕÕÕÕÕÕÕÕÕÕÕ');
     textcolor(lightgray);
     gotoxy(11,15);writeln(#24,#25,' movem cursor');
     writeln('         <enter> seleciona');beep(300,100);
     {j=1;}
     repeat
           for i:=1 to 5 do
             if (i<>j) then begin
                             gotoxy(17-length(opcoes[i]) div 2,i+5);
                             writeln(opcoes[i]);
                            end
                       else begin
                            textbackground(green);textcolor(white);
                            gotoxy(17-length(opcoes[i]) div 2,i+5);
                            writeln(opcoes[i]);
                            textbackground(black);textcolor(lightgray);
                            end;
             repeat ch:=readkey until ch<>'';
             if ch=#0 then begin
                            beep(800,20);
                            ch:=readkey;
                            case ord(ch) of
                             72:j:=j-1;
                             80:j:=j+1;
                            end;
                            if j=0 then j:=5;
                            if j=6 then j:=1;
                           end;
             if (ord(ch)=13) then i:=10;
     until i=10;
     beep(500,50);
     case j of
         1:Ler_nomes;
         2:Incluir_nomes;
         3:Excluir_nomes;
         4:Alterar_dados;
         5:fim;
     end;
end;


(************ main ************)
begin
     apresenta;
     j:=1;
     menu;
     closefile(cadastro);
     closeindex(indice);window(1,1,80,25);
     textcolor(lightred);textbackground(black);clrscr;
end.