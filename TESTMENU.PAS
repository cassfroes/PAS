
{

       ษอออออออออออออออออออออออออออออออออออออออออออป
       บ  þ TestMenu.pas                           บ
       บ    ======== ===                           บ
       บ                                           บ
       บ  þ Teste de Rotinas da Unit GraphNce      บ
       บ                                           บ
       บ  þ Cassiano Lustosa Frขes em Janeiro / 94 บ
       บ                                           บ
       ศอออออออออออออออออออออออออออออออออออออออออออผ

}

program testmenu;

uses crt,graph,graphnce;

var opc          :integer;
    xcur,ycur,bot:integer;
    pal          :palettetype;
    quadro       :tabquad;
    strg         :string;
    code         :byte;
    conta        :integer;
    var menuboxes:TabMenuBoxOpc;

Procedure defcores;
begin
     getpalette(pal);
     case conta of
     1:begin
             setRGBpalette(pal.colors[red],0,0,35);
             setRGBpalette(pal.colors[lightred],0,0,53);
             setRGBpalette(pal.colors[brown],0,0,10);
             seleccorjan(lightgray,red,yellow,lightred,brown,darkgray);
       end;
     2:begin
             setRGBpalette(pal.colors[red],35,0,0);
             setRGBpalette(pal.colors[lightred],53,0,0);
             setRGBpalette(pal.colors[brown],10,0,0);
             seleccorjan(lightgray,red,lightgray,lightred,brown,darkgray);
       end;
     3:begin
             setRGBpalette(pal.colors[red],0,35,0);
             setRGBpalette(pal.colors[lightred],0,53,0);
             setRGBpalette(pal.colors[brown],0,10,0);
             seleccorjan(white,red,lightcyan,lightred,brown,darkgray);
       end;
     4:begin
            seleccorjan(black,lightgray,red,white,darkgray,black);
            conta:=0;
       end;
     end;
     conta:=conta+1;
end;

procedure testa_quadrinho;
begin
     criaJanela(105,105,240,200);
     quadro[1].x:=130;quadro[1].y:=120;quadro[1].txt:='sai';
     quadro[2].x:=130;quadro[2].y:=135;quadro[2].txt:='teste2';
     quadro[3].x:=130;quadro[3].y:=150;quadro[3].txt:='teste3';
     setcolor(darkgray);
     CriaQuadrinho(3,quadro);
     iluminatodosquadrinhos(3,quadro,black);
     repeat
     opc:=selQuadrinho(3,quadro);
     iluminaquadrinho(opc,quadro,lightgreen);
     (*xisquadrinho(opc,quadro);*)
     until opc=1;
     delay(350);
     (*apagatodosxis(3,quadro);
     delay(1500);*)
     opc:=4;
     soltamouse;
     removejanela;
end;

Procedure cria_quadro;


begin
     MenuBoxes[1].x1:=400;MenuBoxes[1].y1:=100;
     MenuBoxes[1].x2:=490;MenuBoxes[1].y2:=120;MenuBoxes[1].txt:='teste';

     MenuBoxes[2].x1:=300;MenuBoxes[2].y1:=100;
     MenuBoxes[2].x2:=390;MenuBoxes[2].y2:=120;MenuBoxes[2].txt:='Ok';

     MenuBoxes[3].x1:=500;MenuBoxes[3].y1:=100;
     MenuBoxes[3].x2:=590;MenuBoxes[3].y2:=120;MenuBoxes[3].txt:='jgh';

     setfillstyle(solidfill,cyan);
     bar(0,0,getmaxx,getmaxy);

     DesenhaMenuBox(menuboxes,3);
end;


procedure menubox_quadrinho;
var menuboxe:TabMenuBoxOpc;
    quadrinhos:tabquad;
begin
     MenuBoxe[1].x1:=400;MenuBoxe[1].y1:=200;
     MenuBoxe[1].x2:=490;MenuBoxe[1].y2:=219;MenuBoxe[1].txt:='teste';
     quadrinhos[1].x:=410;quadrinhos[1].y:=205;
     quadrinhos[1].txt:=' ';
     desenhamenubox(menuboxe,1);
     criaquadrinho(1,quadrinhos);iluminaquadrinho(1,quadrinhos,lightred);

     menubox(menuboxe,1);
     iluminaquadrinho(1,quadrinhos,lightgreen);
end;

begin
     conta:=1;
     ModoGrafico(def,def);
     InicMouse;
     cria_quadro;
     opc:=1;
     repeat
     box_cria(10,70,201,99,'M  E  N  U');
     selecprocmenu(opc,def,def,def);
     opc:=Menumousefixo(10,100,200,218,'Sai/troca cor/proc. LeDir/'+
                        'proc. MenuMouse/testa quadrinhos/testa MenuBox/'+
                        'MenuBox+quadrinho');
     bot:=lemouse(xcur,ycur);
     if opc=0 then opc:=-1;
      case opc of
           1:opc:=confirma(xcur,ycur,'','Esta opcao termina a',
                                           'execucao do programa e',
                                           'retorna ao DOS.');
           2:begin
                  defcores;
                  cria_quadro;
             end;
           3:strg:=ledir(320,200);
           4:menumouse(130,ycur,'  teste/  opcao 2 /  opcao 3/  opcao 4');
           5:testa_quadrinho;
           6:MenuBox(MenuBoxes,3);
           7:menubox_quadrinho;
       end;

     until opc=0;
     FimGrafico;
end.
