program linha;

uses graph,crt,dos;

var cor,x1,y1,x2,y2,maximx,maximy:integer;
    constx1,consty1,constx2,consty2,conta:integer;
    param1,param2:integer;
    a,b,c,d:array [1..200] of integer;

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




begin
    inicia_SVGA;
    randomize;
    cor:=random(getmaxcolor)+1;
    x1:=random(640);x2:=random(640);y1:=random(200);y2:=random(200);conta:=1;
    constx1:=-3;constx2:=3;consty1:=3;consty2:=3;
    settextjustify(bottomtext,lefttext);
    settextstyle(triplexfont,horizdir,5);
    maximx:=getmaxx;maximy:=getmaxy;
    repeat
      repeat
      a[conta]:=x1;b[conta]:=y1;c[conta]:=x2;d[conta]:=y2;
      conta:=conta+1;
      line (x1,y1,x2,y2);
      x1:=x1+constx1;y1:=y1+consty1;
      x2:=x2+constx2;y2:=y2+constx2;
      if x1>maximx then constx1:=-(1+(random(6)))+2;
      if x1<0 then constx1:=(1+(random(6)))+2;
      if y1>maximy then consty1:=-(1+random(6))+2;
      if y1<0 then consty1:=(1+random(6))+2;
      if x2>maximx then constx2:=-(1+random(6))+2;
      if x2<0 then constx2:=(1+random(6))+2;
      if y2>maximy then consty2:=-(1+random(6))+2;
      if y2<0 then consty2:=(1+random(6))+2;
      randomize;
      if (random(30))=9 then begin
                             cor:=random(getmaxcolor-1)+1;
                             setcolor(cor);
                             outtextxy(0,maximy-20,
                                     'linhas - by Cassiano');
                             end;
      if conta=200 then
           begin
             conta:=1;
             param2:=3;
           end;
      until param2=3;
      setcolor(256-cor);line(a[conta],b[conta],c[conta],d[conta]);
      setcolor(cor);
    until keypressed;
    closegraph;
end.