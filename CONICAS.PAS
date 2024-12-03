program conicas;
uses crt,graph;
var t1,t2:real;
    a,b,c,d,e,f:real;
    u1,u2,v1,v2:real;          (* u1,u2,v1,v2 >> coordenadas *)
    etransl,dtransl:real;      (*      dos autovetores U e V *)


procedure inicia_grafico;
var dr,mo:integer;
begin
     dr:=detect;
     initgraph(dr,mo,'');
end;


procedure passo1;
var w1,w2:real;
begin
     clrscr;
     textcolor(white);
     writeln('primeiro passo :');
     writeln;textcolor(yellow);
     writeln('matriz associada:');textcolor(lightred);
     writeln(#179,a:6:2,' ',b:6:2,#179);
     writeln(#179,b:6:2,' ',c:6:2,#179);
     textcolor(yellow);
     writeln('autovalores:');textcolor(red);
     writeln('t',#253,' - tr(A)t + det(A) =0');
     writeln('tr(A) = a + c = ',(a+c):1:3);
     writeln('det(A) = ac - b',#253,' = ',(a*c-b*b):1:3);
     t1:=((a+c)+sqrt((a+c)*(a+c)-4*(a*c-b*b)))/2;
     t2:=((a+c)-sqrt((a+c)*(a+c)-4*(a*c-b*b)))/2;textcolor(lightred);
     writeln('t1 = ',t1:1:3);
     writeln('t2 = ',t2:1:3);
     textcolor(yellow);writeln('autovetores:');textcolor(red);
     writeln('AW = tW   =>   '#179,a:6:2,' ',b:6:2,#179,#179,
                                         'x',#179,'= t ',#179,'x',#179);
             writeln('               '#179,b:6:2,' ',c:6:2,#179,#179,
                                         'y',#179,'    ',#179,'y',#179);
     writeln('t1 = ',t1:1:3);textcolor(lightred);
     write('   U = Z / |Z|= (');(*CALCULO DE U*)
     w1:=1;w2:=(t1-a)/b;
     u1:=w1/sqrt(w1*w1+w2*w2);  (*u1=coord.x de U*)
     u2:=w2/sqrt(w1*w1+w2*w2);  (*u2=coord.y de U*)
     writeln(u1:7:4,' , ',u2:4:4,' )');
     writeln;textcolor(red);
     writeln('t2 = ',t2:1:3);textcolor(lightred);  (*CALCULO DE V*)
     write('   V = W / |W|= (');
     w2:=(t2-a)/b;
     v1:=w1/sqrt(w1*w1+w2*w2);
     v2:=w2/sqrt(w1*w1+w2*w2);
     writeln(v1:7:4,' , ',v2:7:4,' )');
     readln;
end;


procedure passo2;
begin
     clrscr;
     textcolor(white);writeln('segundo passo :');
     writeln;textcolor(yellow);
     writeln(#179,'x',#179,'=',#179,u1:7:4,' ',v1:7:4,#179,#179,'u',#179);
     writeln(#179,'y',#179,' ',#179,u2:7:4,' ',v2:7:4,#179,#179,'u',#179);
     writeln;textcolor(red);
     writeln('x = ',u1:7:4,'u + ',v1:7:4,'v');
     writeln('y = ',u2:7:4,'u + ',v2:7:4,'v');textcolor(lightred);
     writeln('L(x,y) = dx + ey = ',(d*u1+e*u2):7:4,'u + ',
                               (d*v1+e*v2):7:4,'v');
     dtransl:=d*u1+e*u2;
     etransl:=d*v1+e*v2;
     readln;
end;

procedure passo3;
begin
    clrscr;
    textcolor(white);writeln('terceiro passo :');
    writeln;textcolor(yellow);
    writeln(t1:6:3,'u',#253,' + ',t2:6:3,'v',#253,' + ',
             dtransl:6:3,'u + ',etransl:6:3,'v = ',(-f):6:3);
    textcolor(lightred);
    writeln('u''= (',(sqrt(t1)):6:3,'u + ',(dtransl/(2*sqrt(t1))):6:3,' )',#253);
    writeln('v''= (',(sqrt(t2)):6:3,'v + ',(etransl/(2*sqrt(t2))):6:3,' )',#253);
    readln;
end;

procedure desenha;
var x:real;
    deltay:real;
begin
     x:=1;
     inicia_grafico;
     repeat
       deltay:=(sqrt(-(x*x*(b*b-4*a*c)+2*x*(b*e-2*c*d)-4*c*f+e*e))-x*b-e)/(2*c);
       lineto(round(320+x),round(240-deltay));
       sound(100);delay(100);nosound;
       x:=x+1;

     until x=100;
end;


begin
     clrscr;
     writeln('eq. na forma ax',#253,' + bxy + cy',#253,' + dx + ey + f = 0');
     writeln('entre com a,b,c,d,e,f :');
     readln(a,b,c,d,e,f);
     writeln(a,b,c);
     b:=b/2;
     passo1;
     passo2;
     passo3;
     repeat until keypressed;
     closegraph;
end.

