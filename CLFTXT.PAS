{

    ษออออออออออออออออออออออออออออออออออออออออออป
    บ              Unit ClfTxt                 บ
    บ  TXTOBJ : objeto para ediฦo de textos   บ
    บ       por Cassiano Lustosa Frขes         บ
    บ            setembro / 1993               บ
    ศออออออออออออออออออออออออออออออออออออออออออผ

}


unit clftxt;

interface

uses crt,dos;

type
    noptr = ^tipono;
    tipono = record
                    strg:string;
                    prox:noptr;
                    ant:noptr;
               end;
    cursor = object
              tipotela:char;
              procedure getscrtype(var scrtype:char);
              procedure pequeno(scrtype:char);
              procedure grande(scrtype:char);
             end;
    txtobj = object
              csr:cursor;
              arquivo:text;
              linha:noptr;         { linha atual }
              lin,col,             { coord. do cursor }
              colunaatual:integer; { coluna do inicio da janela }
              linhaatual:noptr;    { aponta p/ linha do inicio da janela }
              xa,ya,xb,yb:integer; { coord. da janela }
              primeiro,ultimo:noptr;
              insertOn:boolean;
              cor_fundo,
              cor_moldura,cor_texto:integer;{ cores janela }
              abriu:boolean;       { arquivo aberto }
              procedure defcor(c1,c2,c3:integer);
              procedure beep;
              procedure posiciona_cursor;
              procedure le(nome:string;var x1,y1,x2,y2:integer);
              procedure InKey(var teclafuncao:boolean;
                                  var ch:char);
              procedure mostra(x1,x2:integer;linhainicio:noptr);
              procedure mostra_uma_linha;
              procedure sobelinha;
              procedure descelinha;
              procedure movdir;
              procedure movesq;
              procedure ultima_linha;
              procedure primeira_linha;
              procedure casa;
              procedure fimlinha;
              procedure sobepagina;
              procedure descepagina;
              procedure dltlinha;
              procedure input(var ch:char);
              procedure novalinha;
              procedure dltcaracter;
              procedure InsOnOff;
              procedure testa_tamanho_linha;
              procedure grava;
              procedure fecha;
              Function  prox_lin:string;
              Function  lin_atual:string;
            end;

  {**************************************}

implementation

Function txtobj.lin_atual:string;
begin
     lin_atual:=self.linha^.strg;
end;
Function txtobj.prox_lin;
     begin
          {if (self.lin<=(self.yb-self.ya)) and (self.linha<>self.ultimo) then self.lin:=self.lin+1
                         else begin
                               if (self.linha^.prox<>nil) and
                                       (self.linhaatual^.prox<>nil) then
                                      self.linhaatual:=self.linhaatual^.prox;
                               mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                              end;}
          if (self.linha^.prox<>nil) then
                                     begin
                                     self.linha:=self.linha^.prox;
                                     prox_lin:=self.linha^.strg;
                                     end
              else prox_lin:=#0;
{          testa_tamanho_linha;}
     end;



Procedure txtobj.defcor(c1,c2,c3:integer);
{define cores da moldura,fundo e texto}
     begin
          self.cor_moldura:=c1;
          self.cor_fundo:=c2;
          self.cor_texto:=c3;
     end;

Procedure txtobj.posiciona_cursor;
     begin
          gotoxy(self.col-self.colunaatual+1,self.lin);
     end;

Procedure txtobj.beep;
     var i:integer;
         car:char;
     begin
          i:=300;
          while i<1000 do begin
                sound(i);delay(5);
                i:=i+35;
                end;
          while i>300 do begin
                sound(i);delay(5);
                i:=i-35;
                end;
          nosound;
          while keypressed do car:=Readkey;
     end;

Procedure txtobj.le(nome:string;var x1,y1,x2,y2:integer);
{abre o arquivo NOME e cria a janela x1,y1,x2,y2 }
     var  i:integer;
     begin
          self.insertOn:=true;
          self.abriu:=true;
          csr.getscrtype(csr.tipotela);
          window(x1,y1,x2,y2);textbackground(self.cor_fundo);clrscr;
          textcolor(self.cor_moldura);
          window(1,1,80,24);
          for i:=x1+1 to x2-1 do begin
                                 gotoxy(i,y1);write(#205);
                                 gotoxy(i,y2);write(#205);
                                 end;
          for i:=y1+1 to y2-1 do begin
                                 gotoxy(x1,i);write(#186);
                                 gotoxy(x2,i);write(#186);
                                 end;
          gotoxy((x1+x2)div 2-((length(nome)+2)div 2),y1);
          write('[',nome,']');
          {gotoxy(x2-6,y2);write(' CLF ');}
          gotoxy(x1,y1);write(#201);gotoxy(x2,y1);write(#187);
          gotoxy(x1,y2);write(#200);gotoxy(x2,y2);write(#188);
          textcolor(self.cor_texto);window(x1+1,y1+1,x2-1,y2-1);
          self.xa:=x1+1;self.ya:=y1+1;self.xb:=x2-1;self.yb:=y2-1;
          self.primeiro:=nil;self.ultimo:=nil;
          {$I-}
          assign(self.arquivo,nome);
          reset(self.arquivo);
          {$I+}

          if IOresult<>0 then begin
                               {sound(300);delay(50);nosound;
                               writeln('arquivo inexistente');
                               exit;}
                               new(self.linha);
                               self.linha^.strg:='';
                               self.linha^.prox:=nil;
                               self.linha^.ant:=nil;
                               self.primeiro:=self.linha;
                               self.ultimo:=self.linha;
                               self.abriu:=false;
                              end

          else
          while not eof(self.arquivo) do
          begin
                new(self.linha);
                readln(self.arquivo,self.linha^.strg);
                self.linha^.prox:=nil;
                if self.primeiro=nil then
                   begin
                        self.primeiro:=self.linha;
                        self.linha^.ant:=nil;
                   end
                else begin
                          self.ultimo^.prox:=self.linha;
                          self.linha^.ant:=self.ultimo;
                     end;
                self.ultimo:=self.linha;
          end;
         self.col:=1;self.lin:=1;
         new(self.linhaatual);
         self.linhaatual:=self.primeiro;
         self.linha:=self.primeiro;
         self.colunaatual:=1;
         mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;  { txtobj.le }

Procedure txtobj.mostra(x1,x2:integer;linhainicio:noptr);
{exibe uma parte do texto}
     var aux:string;
         i:integer;
     begin
          clrscr;
          aux:=copy(linhainicio^.strg,x1,x2);
          for i:=1 to (self.yb-self.ya) do
          begin
              writeln(aux);
              if linhainicio^.prox<>nil then begin
                               linhainicio:=linhainicio^.prox;
                               aux:=copy(linhainicio^.strg,x1,x2);
                               end
                 else aux:='';
          end;
          write(aux);
     end;   { txtobj.mostra }

Procedure txtobj.descelinha;
     begin
          if (self.lin<=(self.yb-self.ya)) and (self.linha<>self.ultimo) then self.lin:=self.lin+1
                         else begin
                               if (self.linha^.prox<>nil) and
                                       (self.linhaatual^.prox<>nil) then
                                      self.linhaatual:=self.linhaatual^.prox;
                               mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                              end;
          if (self.linha^.prox<>nil) then self.linha:=self.linha^.prox
              else begin beep;end;
          testa_tamanho_linha;
     end;

Procedure txtobj.sobelinha;
     begin
          if self.lin>1 then self.lin:=self.lin-1
             else if self.linhaatual^.ant<>nil then
                            begin
                                   self.linhaatual:=self.linhaatual^.ant;
                                   mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);

                            end
                   else begin beep;end;
          if (self.linha^.ant<>nil) then
          self.linha:=self.linha^.ant;
          testa_tamanho_linha;
     end;

Procedure txtobj.sobepagina;
     var i:integer;
     begin
          i:=1;
          if self.linha=self.primeiro then begin beep;exit;end;
          if self.linhaatual=self.primeiro then begin
                                      self.linha:=self.primeiro;
                                      self.lin:=1;
                                      end
              else for i:=1 to (self.yb-self.ya) do
                 if (self.linhaatual<>self.primeiro) then
                                      begin
                                      self.linhaatual:=self.linhaatual^.ant;
                                      self.linha:=self.linha^.ant;
                                      end;
          testa_tamanho_linha;
          mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;

Procedure txtobj.descepagina;
     var i:integer;
     begin
          if self.linha=self.ultimo then begin beep;exit;end;
          for i:=1 to (self.yb-self.ya) do
              if self.linha<>self.ultimo then
                               begin
                               self.linhaatual:=self.linhaatual^.prox;
                               self.linha:=self.linha^.prox;
                               end;

          testa_tamanho_linha;
          mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;

Procedure txtobj.testa_tamanho_linha;
{verifica se o a posicao do cursor esta
 dentro da janela atual}
     begin
 { xx }   if self.linha^.strg='' then begin
                                 self.col:=1;
                                 if self.colunaatual<>1 then
                                    begin
                                    self.colunaatual:=1;
                                    mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                                    end;
                                 end
          else if (length(self.linha^.strg)<self.col) then
                  begin
                      self.col:=length(self.linha^.strg)+1;
                      if self.col<self.colunaatual then
                           begin
                           if self.col<(self.xb-self.xa) then self.colunaatual:=1
                                  else self.colunaatual:=self.col-(self.xb-self.xa)+1;
                           mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                           end;
                  end;
     end;

Procedure txtobj.InKey(var teclafuncao:boolean;
                            var ch:char);
{le a tecla pressionada}
     begin
          posiciona_cursor;
          teclafuncao:=false;
          ch:=ReadKey;
          if (ch=#0) then begin
                     teclafuncao:=true;
                     ch:=Readkey;
                     end;
     end;


Procedure txtobj.movdir;
     begin
         if self.col<255 then self.col:=self.col+1;
         if self.col>(length(self.linha^.strg)+1) then
                              begin
                              if self.linha<>self.ultimo then self.col:=1;
                              descelinha;
                              if self.colunaatual<>1 then
                                  begin
                                  self.colunaatual:=1;
                                  mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                                  end;
                              end;
         if self.col>self.colunaatual+(self.xb-self.xa) then
                          begin
                          self.colunaatual:=self.colunaatual+1;
                          mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                          end;
     end;

Procedure txtobj.movesq;
     begin
          if self.col>1 then self.col:=self.col-1
             else if self.lin>1 then
                  begin
                  sobelinha;
                  self.col:=length(self.linha^.strg)+1;
                  if self.col>self.colunaatual+(self.xb-self.xa) then
                     begin
                     self.colunaatual:=self.col-(self.xb-self.xa);
                     mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                     end;
                  end
                  else beep;
          if self.col<self.colunaatual then
                             begin
                             self.colunaatual:=self.colunaatual-1;
                             mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                             end;
     end;

Procedure txtobj.casa;
{tecla home pressionada: leva o cursor para a primeira coluna}
     begin
          self.col:=1;
          if self.colunaatual<>1 then
             begin
             self.colunaatual:=1;
             mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
             end;
     end;

Procedure txtobj.fimlinha;
     begin
          self.col:=length(self.linha^.strg)+1;
          if self.col>self.colunaatual+(self.xb-self.xa) then
                         begin
                         self.colunaatual:=self.col-(self.xb-self.xa)+1;
                         mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                         end;
                         {else colunaatual:=1;}
     end;


Procedure txtobj.ultima_linha;
     begin
          while self.linha^.prox<>nil do
              begin
              self.linha:=self.linha^.prox;
              self.linhaatual:=self.linhaatual^.prox;
              end;
          testa_tamanho_linha;
          mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;

Procedure txtobj.primeira_linha;
     begin
          self.linha:=self.primeiro;
          self.linhaatual:=self.primeiro;
          self.lin:=1;
          testa_tamanho_linha;
          mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;

Procedure txtobj.mostra_uma_linha;
     var aux:string;
     begin
            aux:=copy(self.linha^.strg,self.colunaatual,self.xb-self.xa);
            gotoxy(1,self.lin);write('':self.xb-self.xa);
            gotoxy(1,self.lin);
            write(aux);
     end;{ mostra uma linha }

Procedure txtobj.input(var ch:char);
{inclui o caracter CH na linha atual; se CH=#8 ,
 apaga o caracter da posicao anterior}
     begin
          if ord(ch)=8 then
{backspc}    if self.linha^.strg<>'' then
              begin
                 delete(self.linha^.strg,self.col-1,1);
                 if self.col>self.colunaatual then begin
                               self.col:=self.col-1;
                               mostra_uma_linha;
                               end
                    else if self.colunaatual>1 then
                           begin
                                self.col:=self.col-1;
                                self.colunaatual:=self.colunaatual-1;
                                mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                           end;
              end;
         if ord(ch)<>8 then
            begin
                  if self.insertOn=true then begin
                                     insert(ch,self.linha^.strg,self.col);
                                     self.col:=self.col+1;
                                      end
                  else begin
                       delete(self.linha^.strg,self.col,1);
                       insert(ch,self.linha^.strg,self.col);
                       self.col:=self.col+1;
                       end;
               mostra_uma_linha;
            end;
          if (self.col>self.colunaatual+(self.xb-self.xa)) then begin
                                       self.colunaatual:=self.colunaatual+1;
                                       mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
                                       end;
end;

Procedure txtobj.novalinha;
{ inclui uma linha em branco }
    var noaux:noptr;
    begin
               new(noaux);
               if (self.linha^.strg='')or (self.col>length(self.linha^.strg))
                               then  noaux^.strg:=''
               else
                   begin
                       noaux^.strg:=copy(self.linha^.strg,self.col,
                                       length(self.linha^.strg)-self.col+1);
                       delete(self.linha^.strg,self.col,length(self.linha^.strg)-self.col+1);
                   end;
              if self.linha<> self.ultimo then
                  begin
                    noaux^.prox:=self.linha^.prox;
                    noaux^.ant:=self.linha;
                    self.linha^.prox:=noaux;
                    noaux^.prox^.ant:=noaux;
                  end
               else begin
                         self.ultimo^.prox:=noaux;
                         self.ultimo:=noaux;
                         noaux^.ant:=self.linha;
                         noaux^.prox:=nil;
                    end;

             self.col:=1;self.colunaatual:=1;
             descelinha;
             mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
             end; { press enter }

Procedure txtobj.dltcaracter;
{apaga o caracter sob o cursor}
     begin
          if self.col<=length(self.linha^.strg)then
            begin
            delete(self.linha^.strg,self.col,1);
            mostra_uma_linha;
            end
          else beep;
     end;

Procedure txtobj.dltlinha;
{apaga a linha atual}
     var Paux:noptr;
     begin
          Paux:=self.linha;
          if self.primeiro=self.ultimo then begin
                                  self.linha^.strg:='';
                                  testa_tamanho_linha;
                                  end
            else if self.linha=self.primeiro then
                                  begin
                                  self.primeiro:=self.linha^.prox;
                                  self.linha:=self.linha^.prox;
                                  self.linha^.ant:=nil;
                                  self.linhaatual:=self.linha;
                                  testa_tamanho_linha;
                                  dispose(paux);
                                  end
            else if self.linha=self.ultimo then
                                  begin
                                  self.ultimo:=self.linha^.ant;
                                  self.linha^.ant^.prox:=nil;
                                  self.linha:=self.linha^.ant;
                                  if self.lin>1 then self.lin:=self.lin-1
                                     else self.linhaatual:=self.linhaatual^.ant;
                                  testa_tamanho_linha;
                                  dispose(paux);
                                  end
            else begin
                 self.linha^.ant^.prox:=self.linha^.prox;
                 self.linha^.prox^.ant:=self.linha^.ant;
                 self.linha:=self.linha^.prox;
                 testa_tamanho_linha;
                 dispose(paux);
                 end;
       mostra(self.colunaatual,self.xb-self.xa,self.linhaatual);
     end;

Procedure txtobj.InsOnOff;
{ ativa/desativa modo de insercao de caracteres}
     begin
          if self.insertOn=true then begin
                                self.insertOn:=false;
                                csr.grande(csr.tipotela);
                                end
             else begin
                  self.insertOn:=true;
                  csr.pequeno(csr.tipotela);
                  end;
     end;

Procedure txtobj.grava;
{grava as alteracoes do arquivo}
     begin
          self.linha:=self.primeiro;
          rewrite(self.arquivo);
          while self.linha<>self.ultimo do
          begin
                writeln(self.arquivo,self.linha^.strg);
                self.linha:=self.linha^.prox;
          end;
          write(self.arquivo,self.ultimo^.strg);
     end;

Procedure txtobj.fecha;
     begin
          if self.abriu then
          close(self.arquivo);
          window(1,1,80,25);
          gotoxy(1,self.yb+2);
     end;

Procedure cursor.GetScrType(var scrtype:char);
{detecta o padrao de video, M onocromatico ou C olorido}
     var regs:registers;
     begin
          regs.AH:=$0F;
          intr($10,regs);
          if regs.AL=7 then scrtype:='M'
             else scrtype:='C'
     end;

Procedure cursor.pequeno(scrtype:char);
     var regs:registers;
     begin
         Case scrtype of
         'M':begin
                  with regs do
                       begin
                       AH:=$01;
                       CH:=12;
                       CL:=13;
                       end;
             end;
         'C':begin
                  with regs do
                       begin
                       AH:=$01;
                       CH:=6;
                       CL:=7;
                       end;
             end;
         end;
         Intr($10,regs);
     end;

Procedure cursor.grande(scrtype:char);
     var regs:registers;
     begin
          case scrtype of
          'M':begin
              with regs do
                   begin
                   AH:=$01;
                   CH:=0;
                   CL:=13;
                   end;
              end;
          'C':begin
              with regs do
                   begin
                   AH:=$01;
                   CH:=0;
                   CL:=7;
                   end;
              end;
          end;
          Intr($10,regs);
          end;

end.




