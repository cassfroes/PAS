Program Xyznnh;
Uses Crt,Graph,Dos;
type tipoopcao=array[1..7] of string[10];

{$I svga256.inc}

procedure Inicia_SVGA;
var
  AutoDetect : pointer;
  erro, GraphMode, GraphDriver, x : integer;

{$F+}					(* Forca chamadas longas *)
function DetectVGA : Integer;
var Vid : Integer;
begin
   VID  := 4;
   clrscr;
  DetectVGA := Vid;
end;
{$F-}

begin
  AutoDetect := @DetectVGA;
  GraphDriver := InstallUserDriver('SVGA256',AutoDetect);
  erro := graphresult;
  if erro <> 0 then
     begin
          writeln ( 'Erro : ' , grapherrormsg ( erro ) );
          readln;
          halt;
     end;
  GraphDriver := Detect;
  InitGraph(GraphDriver,GraphMode,'');
  erro := graphresult;
  if erro <> 0 then
     begin
          writeln ( 'Erro : ' , grapherrormsg ( erro ) );
          readln;
          halt;
     end;
end;
          {==================}
          {PROCEDURE OPCOES: }
          {DEFINIR No. DE OPCOES E TAMANHO MAXIMO DA STRING !!}

Procedure opcoes(opcao:tipoopcao);
var i:integer;
    ch:char;
begin
     settextstyle(triplexfont,horizdir,3);
     for i:=1 to 7 do outtextxy(380,i*50+50,opcao[i]);
     i:=1;
     setcolor(119);
     repeat
          setfillstyle(1,120);
          fillellipse(250,i*50+60,20,10);
          ch:=readkey;
          if (ch=#0) then begin
                               setfillstyle(1,119);
                               fillellipse(250,i*50+60,20,10);
                               ch:=readkey;
                               case ord(ch) of
                               72:i:=i-1;
                               80:i:=i+1;
                               end;
                         end;
          if i=0 then i:=7;
          if i=8 then i:=1;
     until (ch=#13);
end;
Procedure cria_menu;
var a,b:integer;
    arrstr:tipoopcao;
begin
     for a:=1 to 7 do arrstr[a]:='opcao '+chr(a+96);
     setviewport(0,0,getmaxx,getmaxy,false);
     clearviewport;
     for a:=0 to 55 do setRGBpalette(a,0,a,0);
     for a:=1 to 55 do setRGBpalette(a+55,a,55-A ,0);
     for a:=110 to 118 do setRGBpalette(a,30,0,0);
     a:=0;
     repeat
           setcolor(a);
           moveto(a,a);lineto(1024-a,a);
           lineto(1024-a,760-a);
           lineto(a,760-a);
           lineto(a,a);

           a:=a+1;
     until a=118;
     setRGBpalette(119,45,50,40);
     setRGBpalette(120,22,22,22);
     setfillstyle(1,119);
     bar(123,123,901,637);
     setviewport(130,130,890,626,true);
     setcolor(120);
     settextstyle(Triplexfont,horizdir,5);
     settextjustify(centertext,toptext);
     outtextxy(380,10,'M E N U');
     settextstyle(triplexfont,horizdir,2);
     outtextxy(380,470,' Setas movem cursor  ,    <enter> seleciona ');
     opcoes(arrstr);
end;

BEGIN
     inicia_SVGA;
     cria_menu;
     repeat until keypressed;
     closegraph;
END.
