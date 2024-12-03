program agenda_le;
uses taccess,crt;
type tiporeg=record
             nome:string [20];
             telefone:string[10];
             end;
var cadastro:datafile;
    indice:indexfile;
    posicao:longint;
    lido:tiporeg;
    nomeaux:string[20];
    escolha:char;

procedure busca_telefone;
begin
    getrec(cadastro,posicao,lido);
    writeln('nome:',nomeaux,'       tel.:',lido.telefone);
end;

procedure verifica_telefones;
begin
    clrscr;
    writeln('** ler nomes **');
    write('nome:');readln(nomeaux);
    while nomeaux<>'' do
    begin
        findkey(indice,posicao,nomeaux);
        if not ok then
        begin
         writeln('telefone nao registrado');
         nomeaux:='';
        end
        else
        begin
         busca_telefone;
         write('nome:');readln(nomeaux);
        end;
    end;
    writeln('pressione <enter> p/ retornar ao menu principal');
    readln;
end;{verifica telefone}

procedure processa_inclusoes;
begin
    clrscr;
    writeln('** incluir nomes **');
    write('nome a incluir : ');
    readln(lido.nome);
    while lido.nome<>'' do
    begin
        write('telefone : ');
        readln(lido.telefone);
        addrec(cadastro,posicao,lido);
        addkey(indice,posicao,lido.nome);
        write('nome a incluir : ');
        read(lido.nome);
    end;
end;

procedure inicio;

begin
    clrscr;textcolor(white);
    write('============================================================================');
    writeln;textcolor(yellow);
    write('              Agenda  -  Taccess    (c)1993 Cassiano Lustosa');
    writeln;textcolor(white);
    write('============================================================================');
    gotoxy(1,10);textcolor(green);
    writeln('              <L>er nomes');
    writeln('              <I>ncluir nomes');
    writeln('              <F>im');
    textcolor(white);
    gotoxy(1,17);write('>>>>');readln(escolha);
    escolha:=upcase(escolha);
end;

begin
    openfile(cadastro,'C:\CASSIANO\cad1.dat',32);
    openindex(indice,'C:\CASSIANO\cad1.ndx',20,noduplicates);
    escolha:='k';
    repeat
      inicio;
      case escolha of
        'L':verifica_telefones;
        'I':processa_inclusoes;
        end;
    until escolha='F';
    closefile(cadastro);
    closeindex(indice);
end.{consulta}
