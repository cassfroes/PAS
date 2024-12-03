program qualquercoisa;
uses crt;

type tmatriz=array [1..10,1..10] of double;

var matriz:tmatriz;
    i,j,n:integer;
    ipvt:array [1..10] of integer;
    mult:tmatriz;

procedure pivoteamento;
var k,i,j:integer;
    aux,pivot:double;
begin
     for k:=1 to (n-1) do      { Modificado, era n-144444444444}
         begin
              pivot:=matriz[k,k];
              ipvt[k]:=k;
              for i:=k to n do
              if abs(matriz[k,i])>abs(pivot) then
                            begin            (* i,k *)
                            pivot:=matriz[k,i];
                            ipvt[k]:=i;
                            end;
              if pivot=0 then exit; { se o maior e' zero, termina o loop}

              aux:=matriz[k,ipvt[k]];
              matriz[k,ipvt[k]]:=matriz[k,k]; (*ipvt[k],k*)
              matriz[k,k]:=aux;

              for i:=k+1 to n do
                   mult[k,i]:=-matriz[k,i]/matriz[k,k]; (*i,k*)


              for j:=k+1 to n+1 do
              begin
                   aux:=matriz[j,k];       (*k,j*)
                   matriz[j,k]:=matriz[j,ipvt[k]];
                   matriz[j,ipvt[k]]:=aux; (*ipvt[],j*)

                   for i:=k+1 to n do
                   matriz[j,i]:=matriz[j,i]+mult[k,i]*matriz[j,k];
              end;

         end;
end;

procedure solucao;
var
   k,i : integer;
   aux : double;
begin
(*     for k := 1 to n-1 do  {Modificado , era n-1}
     begin
          aux := matriz[k,n+1];
          matriz[k,n+1] := matriz[ipvt[k],n+1];
          matriz[ipvt[k],n+1] := aux;

          for i := k+1 to n do
             matriz[i,n+1] := matriz[i,n+1] + mult[i,k]*matriz[k,n+1];
     end;
*)
     for k := n downto 1 do
     begin
          matriz[n+1,k] := matriz[n+1,k]/matriz[k,k];
          for i:=1 to k-1 do
              matriz[n+1,i] := matriz[n+1,i] - matriz[k,i]*matriz[n+1,k];
     end;
end;

PROCEDURE Resultado;
var
   i : integer;

BEGIN
    For i := 1 to n do
        writeln(matriz[n+1,i]:0:5);
    readln;
    readln;
END;

Procedure escreve_matriz;
begin
     for i:=1 to n do
         for j:=1 to n+1 do
             begin
             gotoxy(j*5-4,i+15);
             write(matriz[j][i]:0:3);

         end;
         readln;
end;
BEGIN
     clrscr;
     writeln('entre com a ordem da matriz');
     readln(n);
     writeln;
     writeln('entre com a matriz:');
     for i:=1 to n do
         for j:=1 to n+1 do
             begin
             gotoxy(j*5-4,i+5);
             read(matriz[j][i]);

         end;

    pivoteamento;
    escreve_matriz;
    solucao;
    escreve_matriz;
    resultado;
END.
