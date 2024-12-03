program testecurvabezier;
uses crt,graph,graphnce;
var vet:array[1..4]of pointtype;
    vetsai:array[1..50]of pointtype;
    i,k:integer;
begin
     ModoGrafico(def,def);
     for k:=-10 to 20 do begin
     vet[1].x:=0;vet[1].y:=200;
     vet[2].x:=200;vet[2].y:=200;
     vet[3].x:=400;vet[3].y:=200-k*6;
     vet[4].x:=500;vet[4].y:=k*20;
     Curvabezier(vet,4,vetsai,50);
     setcolor(white);
     for i:=1 to 49 do
         line(vetsai[i].x,vetsai[i].y,vetsai[i+1].x,vetsai[i+1].y);
         delay(50);
     setcolor(black);
         for i:=1 to 49 do
         line(vetsai[i].x,vetsai[i].y,vetsai[i+1].x,vetsai[i+1].y);
     end;

     fimgrafico;
end.