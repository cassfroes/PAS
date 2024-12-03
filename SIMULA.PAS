Program MaquinaNua;

{ 00    MOV AX,[AR]   01    MOV [AR],AX   02    MOV AR,AX     03 vl MOV AX,vl
  04 ad MOV AX,[ad]   05 ad MOV [ad],AX   06    IN  AX        07    OUT AX
  08    INC AX        09    INC AR        0A    DEC AX        0B    DEC AR
  0C    NOT AX        0D    NOT [AR]      0E    NEG AX        0F    NEG [AR]

  10 vl ADD AX,vl     11 ad ADD AX,[ad]   12 vl ADC AX,vl     13 ad ADC AX,[ad]
  14 vl SUB AX,vl     15 ad SUB AX,[ad]   16 vl SBC AX,vl     17 ad SBC AX,[ad]
  18 vl CMP AX,vl     19 ad CMP AX,[ad]   1A vl MUL AX,vl     1B ad MUL AX,[ad]
  1C vl DIV AX,vl     1D ad DIV AX,[ad]   1E vl MOD AX,vl     1F ad MOD AX,[ad]

  20 vl XOR AX,vl     21 ad XOR AX,[ad]   22 vl OR  AX,vl     23 ad OR  AX,[ad]
  24 vl AND AX,vl     25 ad AND AX,[ad]   26 ad JMP ad        27 ad JMP [ad]
  28 ad JC  ad        29 ad JNC ad        2A ad JZ  ad        2B ad JNZ ad
  2C ad JN  ad        2D ad JNN ad        2E ad JV  ad        2F ad JNV ad

  30    ADD AX,[AR]   31    ADD [AR],AX   32    ADC AX,[AR]   33    ADC [AR],AX
  34    SUB AX,[AR]   35    SUB [AR],AX   36    SBC AX,[AR]   37    SBC [AR],AX
  38    CMP AX,[AR]   39    CMP [AR],AX   3A    MUL AX,[AR]   3B    MUL [AR],AX
  3C    DIV AX,[AR]   3D    DIV [AR],AX   3E    MOD AX,[AR]   3F    MOD [AR],AX

  40    XOR AX,[AR]   41    XOR [AR],AX   42    OR  AX,[AR]   43    OR  [AR],AX
  44    AND AX,[AR]   45    AND [AR],AX   46    JMP [AR]      47    JMP AX
  48    SHL [AR]      49    SHL AX        4A    SHR [AR]      4B    SHR AX
  4C    RL  [AR]      4D    RL  AX        4E    RR  [AR]      4F    RR  AX

  50    ADD AX,[SP]   51    ADD [SP],AX   52    ADC AX,[SP]   53    ADC [SP],AX
  54    SUB AX,[SP]   55    SUB [SP],AX   56    SBC AX,[SP]   57    SBC [SP],AX
  58    CMP AX,[SP]   59    CMP [SP],AX   5A    MUL AX,[SP]   5B    MUL [SP],AX
  5C    DIV AX,[SP]   5D    DIV [SP],AX   5E    MOD AX,[SP]   5F    MOD [SP],AX

  60    XOR AX,[SP]   61    XOR [SP],AX   62    OR  AX,[SP]   63    OR  [SP],AX
  64    AND AX,[SP]   65    AND [SP],AX   66    RET           67    HALT
  68    INC [SP]      69    INC [AR]      6A    DEC [SP]      6B    DEC [AR]
  6C    INC SP        6D vl ADD SP,vl     6E    DEC SP        6F vl SUB SP,vl

  70 vl MOV SP,vl     71    MOV AX,SP     72    MOV AR,SP     73    MOV SP,AX
  74 ad CALL ad       75 ad CALL [ad]     76    CALL AR       77    CALL [AR]
  78    PUSHF         79    PUSH AX       7A    PUSH AR       7B    PUSH [AR]
  7C    POPF          7D    POP AX        7E    POP AR        7F    POP [AR]  }

uses crt;

Const PrimLin = 11;  UltLin = 21;
      Break = 'G';  EndIO = 'O';  StartWrite = #82;  StartRead  = #83;

Const Carregador : array [ 0..$6F ] of byte =
      ( $70, $00, $03, $10, $79, $03, $21, $74,
        $25, $6E, $72, $74, $34, $7E, $18, $20,
        $2B, $17, $74, $34, $09, $26, $0E, $18,
        $54, $2A, $6F, $18, $74, $2A, $6F, $26,
        $05, $03, $0A, $0D, $3E, $02, $00, $18,
        $00, $2A, $33, $79, $09, $00, $07, $7D,
        $0A, $26, $27, $66, $03, $00, $01, $06,
        $18, $20, $2A, $37, $18, $2D, $78, $2B,
        $42, $06, $79, $14, $30, $2C, $4B, $18,
        $0A, $2C, $59, $14, $11, $2C, $53, $18,
        $16, $2C, $57, $14, $20, $2C, $66, $10,
        $0A, $19, $FF, $2D, $66, $6C, $79, $04,
        $FF, $3B, $7D, $31, $26, $41, $7D, $7C,
        $2B, $6B, $0F, $66,   0,   0,   0, $67 );


var Dado, Endereco, Chaves, Flags, AX, AR, SP, IP : shortint;
    Memoria : array [ shortint ] of shortint;
    Parado : boolean;  CarLido, IR : byte;
    EstadoFita : ( Deslig, MontLe, MontEsc, Lendo, Escrevendo );
    Arq : file of shortint;  NumLidos : word;

Procedure Separacao ( tam : byte;  carac : char );
  begin
  while tam > 0 do begin  write ( carac );  dec ( tam );  end;
  end;

Procedure MolduraFitaDePapel;
  const V1 = chr ( 179 );  V2 = chr ( 186 );
        H1 = chr ( 196 );  H2 = chr ( 205 );
  begin
  ClrScr;  Gotoxy ( 1, 23 );  TextColor ( lightred );  write ( #201 );
  Separacao ( 20, H2 );  TextColor ( 15 );
  write ( ' LEITORA/PERFURADORA DE FITA DE PAPEL ' );
  TextColor ( lightred );  Separacao ( 20, H2 );  write ( #187 );
  write ( V2, ' Leitora  Perfuradora  Tira fita  ', V1, V2 : 44 );
  write ( V2, '   <Del>      <Ins>      <End>    ', V1, V2 : 44 );
  write ( #200 );  Separacao ( 34, H2 );  write ( #207 );
  Separacao ( 43, H2 );  write ( #188 );  gotoxy ( 1, 1 );  InsLine;
  end;

Procedure Moldura;
  const V1 = chr ( 179 );  V2 = chr ( 186 );
        H1 = chr ( 196 );  H2 = chr ( 205 );
  begin
  MolduraFitaDePapel;
  write ( #201 : 4 );  Separacao ( 29, H2 );  textcolor ( 7 );
  write ( ' P A I N E L ' );  TextColor ( lightred );  Separacao ( 12, H2 );
  write ( chr ( $D1 ) );  Separacao ( 17, H2 );  writeln ( chr ( 187 ) );
  writeln ( V2 : 4, ' DADO    ', ' ' : 33, 'INC  DEC    ', V1, V2 : 18 );
  writeln ( V2 : 4, ' ENDERECO', ' ' : 33, '<>  <>    ',
            V1, ' <C> <Z> <N> <V> ', V2 );
  writeln ( V2 : 4, ' CHAVES   ', V1 : 45,  '   INDICADORES   ', V2 );
  write ( V2 : 4, ' ' : 9, '<7> <6> <5> <4> <3> <2> <1> <0> ', #218 );
  Separacao ( 12, H1 );  write (  #197 );
  Separacao ( 17, H1 );  writeln ( #182 );
  write ( #199 : 4 );  Separacao ( 15, H1 );
  write ( #194 );  Separacao ( 11, H1 );
  writeln ( ' AX ', H1, ' AR ', H1, ' SP ', #217, ' IP  MEMORIA',
            V1, '    <D> Desliga  ', V2 );
  WRITELN ( V2 : 4, ' PARA   <Home> ', V1,
            ' Escreve:   <X>  <R> <S>  <I>    <M>  ',
            V1, ' <PgUp> Zera IP  ', V2 );
  WRITE ( #199 : 4 );  Separacao ( 15, H1 );
  writeln ( #217, ' Le DADO:  <F1> <F2> <F3> <F4>  <F5>  ',
            V1, '    <', #26, '> Um passo ',  V2 );
  WRITELN ( V2 : 4, '    <E> CHAVES ', #26, ' ',
           'ENDERECO: <F6> <F7> <F8> <F9>  <F10> ',
           V1, ' <PgDn> Executa  ', V2 );
  write ( H2, H2, H2, #202 );  Separacao ( 27, H2 );  TextColor ( 15 );
  write ( ' T E L E T I P O ' );  TextColor ( lightred );  Separacao ( 10, H2 );
  write ( #207 );  Separacao ( 17, H2 );  write ( #202, H2, H2, H2 );
  window ( 1, PrimLin, 80, UltLin );  TextColor ( 15 );
  end;

procedure Lampadas ( NumBits : byte;  Pos, valor : word );
  const Lamp : array [ 0..1 ] of byte = ( $FA, $FE );
  begin
  valor := valor shl ( 9 - Numbits );
  repeat MemW [ $B800 : Pos ] := $0FFA + ( hi ( valor ) and 1 ) shl 2;
         inc ( Pos, 8 );   inc ( valor, valor );   Dec ( NumBits );
         until NumBits = 0;
  end;

Procedure Painel;
  Const PosFlags = 282;   PosDado = 160;   PosEnder = 320;
        PosChaves = 480;  PosPara = 980;   PosLeFita = 3684;
  Procedure Hexa ( Pos, Valor : word );
    const Hex : string [ 15 ] = '123456789ABCDEF';
    begin
    Hex [ 0 ] := '0';
    Mem [ $B800 : Pos ] := ord ( Hex [ ( Valor shr 4 ) and 15 ] );
    Mem [ $B800 : Pos + 2 ] := ord ( Hex [ Valor and 15 ] );
    end;
  begin
  Lampadas ( 4, PosFlags, Flags );
  Hexa ( PosDado, Dado );       Lampadas ( 8, PosDado + 28, Dado );
  Hexa ( PosEnder, Endereco );  Lampadas ( 8, PosEnder + 28, Endereco );
  Hexa ( PosChaves, Chaves );   Lampadas ( 8, PosChaves + 28, Chaves );
  Lampadas ( 1, PosPara, ord ( Parado ) );
  Lampadas ( 1, PosLeFita, ord ( EstadoFita = Lendo ) ); ;
  Lampadas ( 1, PosLeFita + 22, ord ( EstadoFita = Escrevendo ) );
  end;

function Busca : shortint;
  begin  Busca := Memoria [ IP ];  inc ( IP );  end;

Procedure LeNomeArq ( Escrita : boolean );
  var NomeArq : string;  Erro : boolean;
  begin
  repeat  gotoxy ( 1, 1 );
          write ( 'Arquivo? > ' );  readln ( NomeArq );
          Assign ( Arq, NomeArq );
          {$i-} if Escrita then rewrite ( Arq ) else Reset ( Arq );
                Erro := IOResult <> 0;  {$i+}
          if Erro then write ( 'Nome de arquivo invalido.' )
                  else if Eof ( Arq ) and not Escrita then begin
                          Erro := true;  write ( 'Arquivo vazio!', ' ' : 10 );
                          end;
          until not Erro;
  gotoxy ( 1, 1 );  write ( 'Arquivo ', NomeArq, ' ' : 10 );  gotoxy ( 1, 2 );
  if Escrita
     then begin
          EstadoFita := Escrevendo;  write ( '     0 bytes escritos.' );  end
     else begin
          EstadoFita := Lendo;
          write ( '     0 bytes lidos. ( Total ',
                  FileSize ( Arq ), ' bytes )' );
          end;
  NumLidos := 0;
  end;

procedure ESFita ( Cmd : byte );
  var x, y : byte;
  begin
  x := wherex;  y := wherey;  window ( 38, 23, 78, 24 );
  Case CMD of
       0: if EstadoFita <> Deslig then begin
             close ( Arq );  EstadoFita := DesLig;  clrscr;  end;
       1: case EstadoFita of
               Deslig, MontLe : LeNomeArq ( true );
               MontEsc : EstadoFita := Escrevendo;
               Escrevendo : EstadoFita := MontEsc;
               end;
       2: Case EstadoFita of
               Deslig, MontEsc : LeNomeArq ( false );
               MontLe : EstadoFita := Lendo;
               Lendo : EstadoFita := MontLe;
               end;
       3: if EstadoFita = Escrevendo then begin
             write ( Arq, AX );  inc ( NumLidos );  end;
       4: if EstadoFita = Lendo then begin
             Read ( Arq, AX );   inc ( NumLidos );
             if Eof ( Arq ) then begin
                Close ( Arq );  EstadoFita := Deslig;  clrScr;  end;
             end
       end;
  if EstadoFita <> Deslig then begin
     gotoxy ( 1, 2 );  write ( NumLidos : 6 );  end;
  window ( 1, PrimLin, 80, UltLin );  gotoxy ( x, y );
  end;

Procedure LeCarac;
  var Continua : boolean;
  begin
  Continua := CarLido = 0;
  while Continua and ( EstadoFita <> Lendo ) do begin
        Painel;  CarLido := ord ( ReadKey );
        if CarLido <> 0
           then Continua := false
           else Case ReadKey of
                     Break:  begin  Parado := true;  Continua := False;  end;
                     EndIO:  ESFita ( 0 );
                     StartWrite: ESFita ( 1 );
                     StartRead: begin  ESFita ( 2 );  Continua := false;  end;
                     end;
        end;
  if EstadoFita = Lendo then ESFita ( 4 ) else begin
     if CarLido = 0 then Dec ( IP ) else begin
        AX := CarLido;
        if CarLido = 13 then writeln else write ( chr ( AX ) );
        if EstadoFita = Escrevendo then ESFita ( 3 );
       end;
     end;
  CarLido := 0;
  end;

procedure InstMove;
  begin
  case IR of
       0: AX := Memoria [ AR ];
       1: Memoria [ AR ] := AX;
       2: AR := AX;
       3: AX := Busca;
       4: AX := Memoria [ Busca ];
       5: Memoria [ Busca ] := AX;
       6: LeCarac;
       7: begin  write ( chr ( AX ) );
                 if EstadoFita = Escrevendo then ESFita ( 3 )  end;
       end;
  end;

Procedure Inst08a0F;
  begin
  if IR < $C
     then if IR < $A then if IR = $8 then Inc ( AX ) else Inc ( AR )
                     else if IR = $A then Dec ( AX ) else Dec ( AR )
     else if IR < $E
             then if IR = $C then AX := not AX
                             else Memoria [ AR ] := not Memoria [ AR ]
             else if IR = $E then AX := -AX
                             else Memoria [ AR ] := -Memoria [ AR ];
  end;

Procedure AddSubCmp ( var Dest: shortint; var OP : integer );
  var MesmoSinal : byte;
  begin
  if ( IR and $F ) > 3 then OP := - OP;
  MesmoSinal := lo ( not ( ( Dest xor OP ) shr 7 ) );
  OP := OP + Dest + ( ( IR shr 1 ) and ( Flags shr 3 ) and 1 );
  Flags := MesmoSinal and ( ( Dest xor OP ) shr 7 ) and 1;
  if ( IR and $F ) < 8 then Dest := OP;
  end;

Procedure MulDivMod ( var Dest :shortint; var OP : integer );
  begin
  if ( IR and 7 ) < 4
     then begin OP := OP * Dest;  Dest := OP;
                Flags := ord ( ( OP < -128 ) or ( OP > 127 ) );  end
     else if OP = 0
          then Flags := 1
          else begin
               if ( IR and 2 ) = 0 then OP := Dest div OP
                                   else OP := Dest mod OP;
               Flags := 0;  Dest := OP;
               end;
  end;

Procedure XORORAND ( var Dest : shortint; var OP : integer );
  begin
  Flags := 0;
  case ( IR and 7 ) div 2 of  0: OP := Dest xor OP;
                              1: OP := Dest or OP;
                              2: OP := Dest and OP;  end;
  Dest := OP;
  end;

procedure Desvio ( OP : byte );
  begin
  if IR < $50
     then IP := OP
     else if IR = $66 then begin  IP := OP;  Inc ( SP );  end
                      else Parado := true;
  end;

Procedure AriLog ( Cod : byte;  var Dest : Shortint;  OP : integer );
  begin
  if Cod < $20
     then if Cod < $1A then AddSubCmp ( Dest, OP ) else MulDivMod ( Dest, OP )
     else if Cod < $26 then XorOrAnd  ( Dest, OP ) else Desvio ( OP );
  if Cod < $26
     then inc ( Flags,
                ( OP shr 6 ) and 2 + ord ( OP = 0 ) * 4 + ( OP shr 5 ) and 8 );
  end;

Procedure DesvCond ( Fl : shortint );
  var Dest, Aux : byte;
  begin
  Dest := Busca;  Aux := 3 - ( IR div 2 ) and 3;
  if odd ( Fl shr Aux ) then IP := Dest;
  end;

procedure Inst00a47;
  begin
  if IR < $28
     then if IR < $10
             then if IR < 8 then InstMove else Inst08a0F
             else if odd ( IR ) then Arilog ( IR, AX, Memoria [ Busca ] )
                                else AriLog ( IR, AX, Busca )
     else if IR < $30
             then if odd ( IR ) then DesvCond ( not Flags )
                                else DesvCond ( Flags )
             else if odd ( IR )
                     then Arilog ( IR - $20, Memoria [ AR ], AX )
                     else Arilog ( IR - $20, AX, Memoria [ AR ] )
  end;

procedure SHRot ( var Dest : shortint );
  var Aux : word;
  begin
  Aux := Dest;
  Case IR div 2 of
       $24: begin Aux := Aux shl 1 + ( Flags shr 3 ) and 1;
                  Flags := Aux shr 5;  end;
       $25: begin inc ( Aux, ( Flags and 8 ) shl 5 );
                  Flags := Aux shl 3;  Aux := Aux shr 1;  end;
       $26: begin Aux := Aux shl 1 + Aux shr 7;
                  Flags := Aux shl 3;  end;
       $27: begin Aux := Aux shl 7 + Aux shr 1;
                  Flags := Aux shl 3;  end;
       end;
  Dest := lo ( Aux );
  Flags := ( Flags and 8 ) + ord ( Dest = 0 ) shl 2 + ( Aux and $80 ) shr 7;
  end;

Procedure IncDecIndir;
  begin
  case IR of
       $68: inc ( Memoria [ SP ] );
       $69: inc ( Memoria [ AR ] );
       $6A: dec ( Memoria [ SP ] );
       $6B: dec ( Memoria [ AR ] );
       end;
  end;

procedure AddSubSP;
  var Aux : byte;
  begin
  if odd ( IR ) then Aux := busca else Aux := 1;
  if IR < $6E then inc ( SP, Aux ) else Dec ( SP, Aux );
  end;

procedure MovSP;
  begin
  if IR < $72 then if IR = $70 then SP := Busca else AX := SP
              else if IR = $72 then AR := SP else SP := AX;
  end;

procedure Call;
  var Dest : shortint;
  begin
  if IR < $76 then Dest := Busca else Dest := AR;
  if odd ( IR ) then Dest := Memoria [ Dest ];
  Dec ( SP );  Memoria [ SP ] := IP;  IP := Dest;
  end;

procedure PushPop;
  begin
  if IR < $7C
     then begin
          Dec ( SP );
          if IR < $7A
             then if IR = $78 then Memoria [ SP ] := Flags
                              else Memoria [ SP ] := AX
             else if IR = $7A then Memoria [ SP ] := AR
                              else Memoria [ SP ] := Memoria [ AR ];
          end
     else begin
          if IR < $7E
             then if IR = $7C then Flags := Memoria [ SP ]
                              else AX := Memoria [ SP ]
             else if IR = $7E then AR := Memoria [ SP ]
                              else Memoria [ AR ] := Memoria [ SP ];
          inc ( SP );
          end;
  end;

procedure Inst48a7F;
  begin
  if IR < $68
     then if IR < $50
             then if odd ( IR ) then SHROT ( AX )
                                else SHROT ( Memoria [ AR ] )
             else if odd ( IR )
                     then Arilog ( IR - $40, Memoria [ SP ], AX )
                     else Arilog ( IR - $40, AX, Memoria [ SP ] )
             else if IR < $70
                     then if IR < $6C then IncDecIndir else AddSubSP
                     else if IR < $78
                             then if IR < $74 then MovSP else Call
                             else PushPOP;
  end;

procedure Executa;
  begin
  Repeat Endereco := IP;  IR := Busca;  Dado := IR;
         IF IR < $80 then if IR < $48 then Inst00a47 else Inst48a7F;
         if KeyPressed and not Parado then begin
            CarLido := ord ( ReadKey );
            if CarLido = 0 then Case ReadKey of
               Break: Parado := true;
               EndIO: ESFita ( 0 );
               StartWrite: ESFita ( 1 );
               StartRead: ESFita ( 2 );
               end;
            end;
         Painel;  until Parado;
  end;

Procedure TeclaFuncao;
  const F1 = 59;    F2 = 60;    F3 = 61;    F4 = 62;    F5 = 63;
        F6 = 64;    F7 = 65;    F8 = 66;    F9 = 67;    F10 = 68;
        UpAr = 72;  PgUp = 73;  RgAr = 77;  Endd = 79;  DwAr = 80;
        PgDn = 81;  Ins = 82;   Del = 83;
  begin
  case ord ( ReadKey ) of
       F1: Dado:=AX;                 F2: Dado:=AR;
       F3: Dado:=SP;                 F4: Dado:=IP;
       F5: Dado:=Memoria[Endereco];  F6: Endereco:=AX;
       F7: Endereco:=AR;             F8: Endereco:=SP;
       F9: Endereco:=IP;             F10: Endereco:=Memoria[Endereco];
       UpAr: dec(Endereco);          PgUp: IP:=0;
       RgAr: Executa;                Endd: ESFita ( 0 );
       DwAr: inc(Endereco);          PgDn: begin Parado:=false; Executa; end;
       Ins: ESFita ( 1 );            Del: ESFita ( 2 );
       end;
  end;

function Acao : boolean;
  const OV = 1;  NG = 2;  ZR = 4;  CY = 8;
  var Opcao : char;
  begin
  Acao := true;  Opcao := ReadKey;
  if Opcao < '8'
     then if ord ( Opcao ) = 0
             then TeclaFuncao
             else begin
                  if Opcao >= '0'
                     then chaves := chaves xor
                                    ( 1 shl ( ord (Opcao) - ord ('0')  )  )
                  end
     else case UpCase ( Opcao ) of
               '8': chaves := chaves xor 1;   'C': flags := flags xor CY;
               'D': Acao := False;            'E': Endereco := Chaves;
               'I': IP := chaves;             'M': Memoria[endereco]:=chaves;
               'N': flags := flags xor NG;    'R': AR := Chaves;
               'S': SP := Chaves;             'V': flags := flags xor OV;
               'X': AX := chaves;             'Z': flags := flags xor ZR;
               end;
  end;

begin
Parado := true;  CarLido := 0;  EstadoFita := Deslig;  Moldura;  Painel;
Move ( Carregador, Memoria [ 0 ], Sizeof ( Carregador ) );
while Acao do Painel;  if EstadoFita <> Deslig then Close ( Arq );
end.
