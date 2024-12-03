uses graph,graphnce;

var menu_principal:tabmenuboxopc;


procedure inicializa_variaveis;
var i:integer;
begin
     for i:=1 to 7 do begin
                       menu_principal[i].y1:=50;
                       menu_principal[i].y2:=69;
                       menu_principal[i].x1:=(i-1)*85+10;
                       menu_principal[i].x2:=(i-1)*85+84+10;
                       end;
     menu_principal[1].txt:='Arquivo';
     menu_principal[2].txt:='Editar';
     menu_principal[3].txt:='Procurar';
     menu_principal[4].txt:='Executar';
     menu_principal[5].txt:='Op‡“es';
     menu_principal[6].txt:='Ferramenta';
     menu_principal[7].txt:='?';
     selecprocmenu(1,def,def,def);
end;

procedure inic_grafico;
begin
     modografico(vga,def);
end;
procedure desenha_interface;
begin
     seleccorjan(def,darkgray,def,def,def,def);
     box_cria(0,0,getmaxx,getmaxy,'');
     semcursormouse;
     seleccorjan(def,lightgray,def,def,def,def);
     setcolor(darkgray);
     setfillstyle(solidfill,lightgray);
     rectangle(10,70,getmaxx-10,getmaxy-35);
     bar(10,70,getmaxx-10,getmaxy-35);
     rectangle(10,getmaxy-30,getmaxx-10,getmaxy-10);
     bar(10,getmaxy-30,getmaxx-10,getmaxy-10);

     setcolor(white);
     line(10,70,getmaxx-10,70);line(10,70,10,getmaxy-35);
     line(10,getmaxy-30,10,getmaxy-10);line(10,getmaxy-30,getmaxx-10,getmaxy-30);
     rectangle(14,74,getmaxx-14,getmaxy-39);
     rectangle(14,getmaxy-26,getmaxx-14,getmaxy-14);

     setcolor(darkgray);
     line(14,74,getmaxx-14,74);line(14,74,14,getmaxy-39);
     line(14,getmaxy-26,14,getmaxy-14);line(14,getmaxy-26,getmaxx-14,getmaxy-26);

     setcolor(yellow);
     settextstyle(defaultfont,horizdir,2);
     outtextxy(10,10,'Interpretador de linguagem PASCAL');
     settextstyle(defaultfont,horizdir,1);
     outtextxy(10,30,'Universidade Federal do Rio de Janeiro - curso de Linguagens de Programa‡ƒo');
     comcursormouse;
     desenhamenubox(menu_principal,7);
end;

procedure menu_arquivo;
var opcao:integer;
begin
     opcao:=menumouse(15,65,'Novo/Abrir/Fechar/Salvar/Salvar como.../'+
                              'Imprimir/DOS Shell/Sair');
     case opcao of
                2:ledir(240,130);
                5:ledir(240,130);
                end;
end;

procedure menu_opcoes;
var opcao:integer;
procedure menu_execucao;
var opcoes_menu:tabmenuboxopc;
    quadrinhos:tabquad;
    i:integer;
    opcaoligada:array[1..10]of boolean;
begin
     for i:=1 to 10 do
                    begin
                    quadrinhos[i].y:=i*20+135;
                    quadrinhos[i].x:=275;
                    quadrinhos[i].txt:=' ';
                    opcoes_menu[i].y1:=i*20+130;
                    opcoes_menu[i].y2:=i*20+149;
                    opcoes_menu[i].x1:=265;
                    opcoes_menu[i].x2:=375;
                    opcoes_menu[i].txt:='teste';
                    {opcaoligada[i]:=false;}
                    end;
     criajanela(240,130,400,355);
     setcolor(white);
     outtextxy(251,136,'Op‡“es de execu‡ƒo');
     setcolor(black);
     outtextxy(250,135,'Op‡“es de execu‡ƒo');
     desenhamenubox(opcoes_menu,10);
     criaquadrinho(10,quadrinhos);
     for i:=1 to 10 do if opcaoligada[i] then iluminaquadrinho(i,quadrinhos,lightgreen)
        else iluminaquadrinho(i,quadrinhos,black);
     repeat
     opcao:=menubox(opcoes_menu,10);
     opcaoligada[opcao]:=not(opcaoligada[opcao]);
     if opcaoligada[opcao] then iluminaquadrinho(opcao,quadrinhos,lightgreen)
        else iluminaquadrinho(opcao,quadrinhos,black);
     until opcao=10;

     removejanela;
end;
begin
     opcao:=menumouse(355,65,'Execucao/Pontos de parada');
     case opcao of
                1:menu_execucao;
                {2:}
                {3:}
                end;
end;
procedure edita;
var escolha:integer;
begin
     repeat
     escolha:=menubox(menu_principal,7);
     case escolha of
                  1:menu_arquivo;
                  2:menumouse(100,65,'Voltar/Recortar/Copiar/Colar');
                  3:menumouse(185,65,'Procurar por.../Substituir/Ir para');
                  {4:}
                  5:menu_opcoes;
                  {6:
                  7:}
                  end;
     if escolha=7 then escolha:=escolha+confirma(410,65,'',
                   '  Terminar a execu‡ƒo do','  programa','');
     until escolha=7;
end;
begin
     inic_grafico;
     inicmouse;
     inicializa_variaveis;
     desenha_interface;
     edita;
     closegraph;
end.