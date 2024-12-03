program cubo3d;
uses crt,graph;
const
     d=40;
     vcx=220;
     vcy=240;
     vsx=640/20;
     vsy=-480/20;
     alfa=pi/60;
     esc=50;

procedure inicia_grafico;
var dr,mo:integer;
begin
     Dr:=detect;
     Initgraph(dr,mo,'c:\bp\bgi');
end;

procedure line3d(x0,y0,z0, x1,y1,z1:real);
var xt1,yt1,xt2,yt2,
    zp,yp,zp1,yp1:integer;

begin
   z0:=z0+d*15;
   z1:=z1+d*15;
   y0:=y0-d;
   y1:=y1-d;
   zp:=round(z0*cos(alfa)+y0*sin(alfa));
   yp:=round(-z0*sin(alfa)+y0*cos(alfa));
   zp1:=round(z1*cos(alfa)+y1*sin(alfa));
   yp1:=round(-z1*sin(alfa)+y1*cos(alfa));


   xt1:=trunc(((x0*d/zp)*vsx+vcx));
   yt1:=trunc(((yp*d/zp)*vsy+vcy));

   xt2:=trunc(((x1*d/zp1)*vsx+vcx));
   yt2:=trunc(((yp1*d/zp1)*vsy+vcy));

   line(xt1,yt1,xt2,yt2);
end;


procedure cubo;
var x1,x2,x3,x4,
    z1,z2,z3,z4:real;
    i:integer;
    aux:real;
    teta:real;
begin
     teta:=pi/50;
     SetWriteMode(XORPut);
     x1:=-esc;z1:=-esc;
     x2:=esc;z2:=-esc;
     x3:=esc;z3:=esc;
     x4:=-esc;z4:=esc;
     while not keypressed do
     begin
     for i:=1 to 2 do
          begin
          setcolor(lightred);
          line3d(x1,-esc,z1, x2,-esc,z2);
          line3d(x2,-esc,z2, x3,-esc,z3);
          line3d(x3,-esc,z3, x4,-esc,z4);
          line3d(x4,-esc,z4, x1,-esc,z1);

          setcolor(yellow);
          line3d(x1,esc,z1, x2,esc,z2);
          line3d(x2,esc,z2, x3,esc,z3);
          line3d(x3,esc,z3, x4,esc,z4);
          line3d(x4,esc,z4, x1,esc,z1);

          setcolor(green);
          line3d(x1,esc,z1, x1,-esc,z1);
          line3d(x2,esc,z2, x2,-esc,z2);
          line3d(x3,esc,z3, x3,-esc,z3);
          line3d(x4,esc,z4, x4,-esc,z4);

          setcolor(blue);
          line3d(x4,esc,z4, x1,-esc,z1);
          if i=1 then delay(50);
          end;
     aux:=x1;
     x1:=round(x1*cos(teta)+z1*sin(teta));
     z1:=round(-aux*sin(teta)+z1*cos(teta));

     aux:=x2;
     x2:=round(x2*cos(teta)+z2*sin(teta));
     z2:=round(-aux*sin(teta)+z2*cos(teta));

     aux:=x3;
     x3:=round(x3*cos(teta)+z3*sin(teta));
     z3:=round(-aux*sin(teta)+z3*cos(teta));
     aux:=x4;
     x4:=round(x4*cos(teta)+z4*sin(teta));
     z4:=round(-aux*sin(teta)+z4*cos(teta));
     end;
end;

begin
     inicia_grafico;
     setcolor(green);
     cubo;
     closegraph;
end.