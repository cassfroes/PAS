uses nce3d, texto3d,pcx;

procedure DesenhaCena;
begin
    selecCorPolig3d(branco);
    InicTransf3d;
    {Translada3d (-35,-1.5,-10);}
    semiesfera3d(5,8);


    selecCorPolig3d(branco);
    InicTransf3d;
    Translada3d (-35,-1.5,-10);
    Cubo3d(46,1,20);

    InicTransf3d;
    Translada3d (-35,0,9);
    Cubo3d(46,10,1);

    InicTransf3d;
    Translada3d (-35,0,-10);
    Cubo3d(1,10,20);

{    seleccorpolig3d(azul);
    InicTransf3d;
    RodaX3d(-pi/2);
    cone3d(16,3,10);}

    SelecCorPolig3d(azul);
    InicTransf3d;
    Escala3d(5,5,5);
    Translada3d(-30,8,-5);
    Escreve3d ('Engenharia');

    SelecCorPolig3d(azul);
    InicTransf3d;
    Escala3d(5,5,5);
    Translada3d(-30,3,-5);
    Escreve3d ('de Software');

    SelecCorPolig3d(dourado);
    InicTransf3d;
    Escala3d(3,3,3);
    Translada3d (-5,1.5,-11);
    Escreve3d ('UFRJ/95');

{    SelecCorPolig3d (branco);
    InicTransf3d;
    Translada3d(11.5,4.5,3.5);
    esfera3d(3,3);

    SelecCorPolig3d (branco);
    InicTransf3d;
    Translada3d(-13,3.5,-2);
    Toro3d(36,18,6,1);}
end;
procedure cena1;
var x:real;
    i:integer;
    txt:string;
begin
     txt:='UFRJ ';
    selecCorPolig3d(branco);
    InicTransf3d;
    {Translada3d (-35,-1.5,-10);}
{    esfera3d(10,11);}
     TORO3D(30,20,6,6);

    x:=1*pi/5;
    SELECPROFLETRA3D(2);
    SELECCORPOLIG3D(AZUL);
    INICTRANSF3D;
    for i:=1 to 4 do
    begin
    InicTransf3d;
    RodaY3d(x);
{    RODAX3D(X/7);}
    Translada3d (-2*sin(x),-0.4,-2*cos(x));
    escala3d(7,7,7);
    Escreve3d(txt[i]);
    x:=x-pi/6;
    end;


end;
begin
    { Inicializacoes ... }
    InicVideo3d(svga256);
    Observador3d (45,55,-80, -10,-10,0);

    Janela3d (40, 400, 20.0,15.0, 0,0,getmaxx+1, getmaxy+1);
    SelecLuzAmbiente3d(0);
    SelecLuz3d (45,10,-60);
    InicZBuffer3d(getmaxy+1,0,'c:');

    { Carrega fonte }
    InicFonte3d('\cassiano\nce3d\avalon');
    SelecAlinhamentoTexto3d (direita);

    AbreArqImagem3d ('teste');
    {DesenhaCena;}
    cena1;
    FechaArqImagem3d;
    gravaPCX('imagem',0,0,getmaxx,getmaxy);
    readln;
    Termina3d;
end.