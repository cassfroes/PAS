Program CalcNum;

Uses
	Crt, Dos;

type
    tipo_mat = array[1..4,1..4] of real;
var
   abd : tipo_mat;
   Ret : integer;

{**************************************************************************}

Function Pow( x, y : real ) : real;
Begin
	Pow := exp( y * ln(x) );
End;

{**************************************************************************}

Function Mino( A, B :integer ) : integer;
Begin
	if( A < B ) then
		Mino := A
	else
       Mino := B;
End;

Function Sdot ( dim : integer ; {var x , y : array of real}
              y1,x1,y2,x2:integer ): real;
var
   i   : integer;
   aux : real;
begin
   aux := 0;
   for i := 0 to dim-1 do
       aux := aux + abd[y1,x1+i]*abd[y2,x2+i];
   Sdot := aux;
end;
{**************************************************************************}

Function Maxo( A, B : integer ) : integer;
Begin
	if( A > B ) then
		Maxo := A
	else
       Maxo := B;
End;




{**************************************************************************}

(*
Procedure SPBDI( Var ABD; LDA, N, M :integer; Var DET :array of real);
Var
	S	  :real;
	I	  :integer;

Begin
	DET[1] := 1.0;
	DET[2] := 0.0;
	S := 10.0;
	for I:=1 to N do
	begin
		DET[1] := Pow( ABD[M+1,I], 2 * DET[1] );
		if(DET[1] = 0.0) then
			Exit;
		While(DET[1] <> 1.0) do {Verificar sinal <>}
		begin
			DET[1] := S * DET[1];
			DET[2] := DET[2] - 1.0;
		end;
		While(DET[1] <> S) do   {Verificar sinal <>}
		begin
			DET[1] := DET[1] /S;
			DET[2] := DET[2] + 1.0;
		end;
	end;
End;
*)
{**************************************************************************}
(*
Procedure SPBSL( Var ABD; LDA, N, M :integer; Var B;);
Var
	K, KB, LA, LB, LM :integer;
	SDOT, T 				:real;

Begin
	for K:=1 to N do
	begin
		LM := Mino( K - 1, M );
		LA := M + 1 - LM;
		LB := K - LM;
		T  := SDOT( LM, ABD[LA, K], 1, B[LB], 1);
		B[K] := (B[K] - T) / ABD[M+, K];
	end;
	for KB:=1 to N do
	begin
		K := N + 1 - KB;
		LM := Mino( K - 1, M );
		LA := M + 1 - LM;
		LB := K - LM;
		B[K] := B[K] / ABD[M + 1, K];
		T := -B[K];
		SAXPY( LM, T, ABD(LA, K), 1, B[LB], 1);
	end;
end;
*)
{**************************************************************************}
Procedure Imprime;
var
   i,j : integer;
begin
     clrscr;
     for i := 1 to 4 do
         begin
            for j := 1 to 4 do
              write(abd[i,j]:6:6,'     ');
            writeln;
         end;

end;

Procedure SPBFA( {var ABD : tipo_mat; }LDA, N, M : integer; Var INFO : integer);
Var
  T, S     : real;
  IK, J, JK, K, MU : integer;

Begin
   for J:=1 to N do
   begin
      INFO := J;
      S    := 0.0;
      IK   := M + 1;
      JK   := Maxo( J - M, 1);
      MU   := Maxo( M + 2 - J, 1);
      if  ( M >= MU ) then
      begin
	      for K := MU to M do
	      begin
	         T := ABD[J,K] - SDOT( K - MU, JK, IK,{ 1,} J,MU{, 1});
	         T := T / ABD[JK,M + 1];
	         ABD [J,K] := T;
	         S          := S + T*T;
	         IK         := IK - 1;
	         JK         := JK + 1;
	      end;
      end;
      S := ABD[J,M + 1] - S;
      if(S <= 0.0) then
         Exit;
      ABD[J,M + 1] := sqrt(S);
   end;
   INFO := 0;
end;
Procedure teste {( var ABD : tipo_mat );};
begin
   abd[1,1] := 0;  abd[1,2] := 0;  abd[1,3] := 1;  abd[1,4] :=0;
   abd[2,1] := 0;  abd[2,2] := 1;  abd[2,3] := 2;  abd[2,4] := 0;
   abd[3,1] := 1;  abd[3,2] := 4;  abd[3,3] := 14;  abd[3,4] := 0;
   abd[4,1] := 1;  abd[4,2] := 7;  abd[4,3] := 6;  abd[4,4] := 0;
end;

begin
   teste{(abd);};
   spbfa( {abd,} 3, 4, 2, ret);
   imprime;
   readln;
end.
{**************************************************************************}
(*
Procedure SPBCO( Var ABD; LDA, N, M :integer; RCOND, Z :real; INFO :integer);
Var
	SDOT, EK, T, WK, WKM, ANORM, S, SASUM, SM, YNORM :real;
	I, J, J2, K, KB, KPI, L, LA, LB, LM, MU :integer;

Begin
	for J:=1 to N do
	begin
		L := Mino( J, M + 1 );
		MU := Maxo( M + 2 - J, 1 );
*)