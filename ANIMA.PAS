program jogo;

uses graph,graphnce,crt;

const maxicone=1;

type iconetype=array[0..799]of byte;

var mascara0:{array[0..9]of }iconetype;
    mascara1:iconetype;

procedure pinta(x,y,cor:word);external;
{$L c:\cassiano\jogo3\jogo3.obj}
procedure icone(x,y:word;var icone:iconetype);external;
{$F+}
function detectmode:integer;
begin
     detectmode:=0;
end;
{$F-}
procedure inicvideo;
var driver,modo,testdriver:integer;
begin
     modografico(cga,0);
     closegraph;

     testdriver:=installuserdriver('svga256',@detectmode);
     if graphresult<>grok then halt;
     driver:=detect;
     modo:=0;
     initgraph(driver,modo,'c:\bp\bgi');
     if graphresult<>grok then halt;
end;


procedure le2;
var numbyte:integer;
    arquivo1:file of byte;
begin
     assign(arquivo1,'c:\cassiano\jogo3\cassiano.ico');
     reset(arquivo1);
              for numbyte:=0 to 799 do
             read(arquivo1,mascara1[numbyte]);
     close(arquivo1);
end;

procedure leicones;
var arquivo,arquivo1:file of byte;
    numbyte,numicone:integer;
begin
     assign(arquivo,'c:\cassiano\jogo3\cassian2.ico');
     reset(arquivo);
    { for numicone:=0 to maxicone do}
         for numbyte:=0 to 799 do
             read(arquivo,mascara0{ <-- seria numicone}[numbyte]);
     close(arquivo);
     le2;
end;


procedure anima;
var posy,
    posx,
    frame:integer;
begin
     cleardevice;
     frame:=0;
     for posy:=96 downto 1 do
         begin
         pinta((posy+1)*3,100,0);
         if frame=0 then icone(posy*3,100,mascara1)
            else icone(posy*3,100,mascara0);
         delay(75);
         if frame=1 then frame:=0
            else frame:=1;
         end;

end;

begin
        inicvideo;
        leicones;
        anima;
        closegraph;
end.