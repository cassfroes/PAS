program catalog;
uses dos,crt;
var quedir:dirstr;
    quearq:namestr;
    queext:extstr;
    sr:searchrec;
    path,pathcompleto:pathstr;
    atrib:word;
    espaco,conta_arquivo,
    bytes_disponiveis,
    bytes_capacidade,conta_arquivoaux:longint;
    taxa_ocup:real;
    ch:char;
    data:DateTime;
begin
     clrscr;
     conta_arquivo:=0;
     conta_arquivoaux:=19;
     if paramcount=0 then path:='*.*'
         else path:=paramstr(1);
     textcolor(lightgreen);
     writeln('Path fornecido : ',path);
     pathcompleto:=fexpand(path);
     writeln('Listagem de ',pathcompleto);
     writeln('---------------------------------------------');
     window(1,4,80,24);
     atrib:=$3f;
     textcolor(white);
     findfirst(path,atrib,sr);
         if dosError=2 then writeln('Arquivo n∆o encontrado');
         while dosError=0 do
               begin
                    unpacktime(sr.time,data);
                    write(sr.name,'':15-length(sr.name),sr.size,
                    '     ',data.day,'/',data.month,
                       '/',data.year,'   ',data.hour,':',data.min);
                       if data.min=0 then writeln('0')
                       else writeln;
                    espaco:=espaco+sr.size;
                    if conta_arquivo=conta_arquivoaux then
                       begin
                            ch:=ReadKey;
                            conta_arquivoaux:=conta_arquivoaux+19;
                       end;
                    inc(conta_arquivo);
                    findnext(sr);
               end;
         textcolor(lightgreen);
         writeln('---------------------------------------------');
         writeln(conta_arquivo:0,' arquivos ocupando ',espaco:0,' bytes');
         fsplit(pathcompleto,quedir,quearq,queext);
         bytes_disponiveis:=diskfree(ord(quedir[1])-ord('A')+1);
         bytes_capacidade:=disksize(ord(quedir[1])-ord('A')+1);
         taxa_ocup:=(bytes_capacidade-bytes_disponiveis)/
                                    bytes_capacidade*100;
         textcolor(green);
         writeln('Drive ',quedir[1],' :');
         writeln('Capacidade : ',bytes_capacidade,'     espaáo livre : ',
                             bytes_disponiveis);
         writeln('Taxa de ocupaá∆o : ',taxa_ocup:5:2,'%');
         window(1,1,80,25);
         gotoxy(1,24);
         textcolor(lightgray);
end.