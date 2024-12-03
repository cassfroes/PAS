program teste;
uses crt,printer;
const n=4;
var abd,abd1:array[1..30,1..30]of real;


procedure inicializa;
var i,j:integer;
begin
     for i:=1 to n do
          for j:=1 to n do
              begin
              abd[i,j]:=0;
              abd1[i,j]:=0;
              end;

     for i:=1 to n do
          for j:=i to n do
              begin
              gotoxy(j*5,i);
              read(abd[i,j]);
              end;
end;

procedure multiplica;
var i,j,k:integer;
begin
     for k:=1 to N do
         for i:=1 to N do
             for j:=1 to N do
                 abd1[i,k]:=abd1[i,k]+(abd[i,j]*abd[j,k]);
end;

procedure imprime;
var i,j:integer;
begin
     for i:=1 to N do
         begin
         for j:=1 to N do
             write(lst,abd[i,j]:3:3,' ');
         write(lst,#13,#10)
         end;
     write(lst,#13,#10);
     write(lst,#13,#10);
     for i:=1 to N do
         begin
         for j:=1 to N do
             write(lst,abd1[i,j]:3:3,' ');
         write(lst,#13,#10)
         end;

end;
begin
     clrscr;
     inicializa;
     multiplica;
     imprime;
end.