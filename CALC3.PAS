{
   ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
   บ                                                                 บ
   บ            UNIVERSIDADE FEDERAL DO RIO DE JANEIRO               บ
   บ                                                                 บ
   บ       Trabalho de C lculo Numrico - 1994 / 2o. semestre        บ
   บ                       Professor Bordoni                         บ
   บ                                                                 บ
   บ                                                                 บ
   บ                     Cassiano Lustosa Frขes                      บ
   บ                     Cกntia Medeiros Soares                      บ
   บ                                                                 บ
   บ                                                                 บ
   ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ


   A rotina SPBFA fatora uma matriz A positiva-definida de banda,
armazenada na forma compactdada.

Parmetros :

Na chamada :
   ABD : array[1..N,1..M+1]
         Matriz a ser fatorada, na forma compactada. As diagonais
         da matriz A sฦo armazenadas como colunas de ABD.
   N   : integer
         ordem da matriz A
   M   : integer
         nฃmero de diagonais acima da diagonal principal.
         0 <= M <= N

Retornam :
   ABD : Matriz triangular superior R, armazenada na forma compactada,
         tal que A = Trans(R)*R
   INFO: integer
         se igual a zero, a fatoraฦo foi bem sucedida;
         se diferente de zero, a matriz nฦo  positiva-definida e retorna
            a linha de ABD onde ocorreu o erro.

Armazenamento de matrizes positivas definidas de banda:

 | g  d  b  0 |         | *  *  g |
 | d  h  e  c |   ==>   | *  d  h |
 | b  e  i  f |         | b  e  i |
 | 0  c  f  j |         | c  f  j |

        | a e h 0 |
 Se R = | 0 b f i |
        | 0 0 c g |
        | 0 0 0 d |

 entฦo :
                  | aý   ae      ah         0    |
 A = trans(R)*R = | ae  eý+bý   he+bf      ib    |
                  | ah  he+bf  hý+fý+cý   fi+cg  |
                  |  0   ib     fi+cg    iý+gý+dý|


 Na forma compactada de matriz de banda as contas ficam f ceis.

     |   *      *     aý        |              | *  *  a |
 A = |   *     ae     eý+bý     |     e    R = | *  e  b |
     |  ah    he+bf   hý+fý+cý  |              | h  f  c |
     |  ib    fi+cg   iý+gý+dý  |              | i  g  d |



Sub-rotinas utilizadas :

Function Maxo : retorna o maior de dois valores;

Function Sdot : retorna o produto interno de dois vetores.

}



Program CalcNum;

type
     tmat = array [1..900] of real;

var
     abd : array[0..6,0..6]of real;
     Ret : integer;



{**************************************************************************}

Function Maxo( A, B : integer ) : integer;
Begin
	if( A > B ) then
		Maxo := A
	else
       Maxo := B;
End;

{**************************************************************************}

Function Sdot ( dim       : integer ;
                var x , y : array of real): real;
var
   i   : integer;
   aux : real;
begin
   aux := 0;
   for i := 0 to dim-1 do
        aux := aux + x[i]*y[i];
   Sdot := aux;
end;

{**************************************************************************}

Procedure SPBFA( var ABD  ;
                 LDA, N, M : integer;
                 Var INFO  : integer);
Var
  T, S     : real;
  IK, J, JK, K, MU : integer;
Begin

   for J:=1 to N do
   begin
      INFO := J;
      S    := 0;
      IK   := M + 1;
      JK   := Maxo( J - M, 1);
      MU   := Maxo( M + 2 - J, 1);
      if  ( M >= MU ) then
	  for K := MU to M do
	      begin
	         T := tmat(ABD)[ J,K ] - SDOT( K - MU, tmat(abd)[ JK,IK ],tmat(abd)[ J,MU ]);
	         T := T / tmat(ABD)[ JK , M+1 ];
	         tmat(ABD) [ J,K ] := T;
	         S           := S + T*T;
	         IK          := IK - 1;
	         JK          := JK + 1;
	  end;
      S := tmat(ABD)[ J , M+1 ] - S;
      if(S <= 0.0) then Exit;
      tmat(ABD)[ J, M+1 ] := sqrt ( S );
   end;
   INFO := 0;
end;

{**************************************************************************}

Procedure ImprimeResult;
var
   i,j : integer;
begin
     for i := 1 to 4 do
         begin
            for j := 1 to 4 do
              write(abd[i,j]:3:3,'   ');
            writeln;
         end;

     writeln(Ret);

end;

{**************************************************************************}

Procedure teste;
begin
   abd[1,1] := 0;  abd[1,2] := 0;  abd[1,3] := 1;  abd[1,4] :=0;
   abd[2,1] := 0;  abd[2,2] := 1;  abd[2,3] := 2;  abd[2,4] := 0;
   abd[3,1] := 1;  abd[3,2] := 4;  abd[3,3] := 14;  abd[3,4] := 0;
   abd[4,1] := 1;  abd[4,2] := 7;  abd[4,3] := 6;  abd[4,4] := 0;
end;

{**************************************************************************}

begin
   teste;
   spbfa(abd, 3, 4, 2, ret);
   imprimeResult;
   readln;
end.
