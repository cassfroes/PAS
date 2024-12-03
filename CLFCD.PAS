program clf_chdir;
uses dos,crt;
var diretorio:string;
    fim:boolean;

procedure achei(diretorioachei:string);
var ch:char;
begin
     nosound;
     textcolor(white);
     writeln;
     write(' ACHEI '+diretorioachei);
     {write(' Continua ? (s/n)');
     ch:=readkey;
     if ch='n' then
               begin}
               chdir(diretorioachei);
               fim:=true;
              { end;}
end;
procedure linha;
var i:integer;
begin
     textcolor(red);
     writeln;
     for i:=0 to 79 do
         write(#205);
end;
function maiusculas(strg:string):string;
var i:integer;
begin
     maiusculas[0]:=strg[0];
     for i:=1 to (length(strg)) do
         maiusculas[i]:=upcase(strg[i]);
end;
procedure le_diretorio(nomedir:string);
var Sr:SearchRec;
begin
     findfirst(nomedir+'*',$10,sr);
     write(#178);
     while (DosError=0)and(not fim)do
           begin
           if (sr.name=diretorio)then achei(nomedir+sr.name)
                 else
                      begin
                      if (sr.name<>'..')and(sr.name<>'.')then
                         le_diretorio(nomedir+sr.name+'\');
                      findnext(sr);
                      end;
           end;
end;

begin
     fim:=false;
     linha;
     textcolor(lightgray);
     writeln(' (c) 1994 Cassiano Lustosa Fr¢es ');
     if paramstr(1)<>'\' then
        begin
        diretorio:=maiusculas(paramstr(1));
        writeln(' Procurando por '+diretorio);
        {chdir('\');}
        le_diretorio('\');
        end
     else begin
          chdir('\');
          fim:=true;
          end;
     textcolor(white);
     if fim=false then write(#13+#10+'diret¢rio n∆o encontrado ');
     linha;
     textcolor(lightgray);writeln;
end.