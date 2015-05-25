PROGRAM ARCANOID2;
USES  Crt,Graph,Dos;
TYPE  PLevel = record          {3anucb ypoBHeu}
	name: string[8];       {uM9I qpauJIa}
	Tiks: array [0..32,0..19] of byte;{MaccuB ILBETOB}
      end;

      TPlaces = record         {3anucb urpokoB}
	name  : string[25];    {uM9I urpoka}
	points: integer;       {koJIu4ecTBo o4koB}
      end;

      PCnucok = ^TCnucok;      {Список пунктов меню}
      TCnucok = record
	name  : string[12];    {Имя пункта меню}
	active: boolean;       {Показывает активный пункт меню или нет}
	next,last: PCnucok;    {Указатели на следующий и предыдущий элемент в списке}
      end;

      TBall=object             {Объект шарика}
	x, y, angle,           {Координаты шарика и угол отражения}
	dx, dy:real;           {Смещение шарика по X и по Y}
	procedure Init(xx, yy:integer);{Инициирование начальных координат шарика}
	procedure Move;        {Перемещение шарика}
      end;

      TBeat=object             {Объект доски}
	goBeat:integer;        {Расстоние от начала координат до начала доски}
	procedure Draw;        {Рисование доски}
      end;

      TMenu = object           {Объект меню}
	p : pointer;           {Указатель начала области памяти под список}
	name,Cnucok: PCnucok;  {Cnucok -  начальный  указатель на список,
				name  - "плавающий" указатель по списку}
	name2:PCnucok;         {Ячейка для дополнения в список}
	procedure Init(col:byte);{Заполнение списка элементами}
	procedure MoveItem(dx:shortint; var ind,stt:shortint; mve:boolean);
	{Устанавливает флаг активности (active) на элемент ind+dx и если
	 необходимо (mve=true) меняет значение (stt) параметра начального
			    индекса скроллируемого окна                  }
	procedure Scrolling(sst:byte);{Скроллирует меню с позиции sst}
	procedure Add(newFile :string);{Добавляет элемент в список}
      end;

CONST bdx    : shortint=     2;
      flExit : boolean = false; { выход из игры }
      flLeft : boolean = false; { клавиша влево }
      flRight: boolean = false; { клавиша вправо}
      flPlus : boolean = false; {  клавиша плюс }
      flMinus: boolean = false; { клавиша минус }
      flSpace: boolean = false; {    выстрел    }
      flShoot: boolean = false;
      flPause: boolean = false; {     пауза     }
      fl     : boolean = false; { игрок промахнулся}
      flEnter: boolean = false;
      flDown : boolean = false;
      flUp   : boolean = false;
      flTab  : boolean = false;
      flSave : boolean = false;
      flLoad : boolean = false;
      flBkSp : boolean = false;
      flClear: boolean = false;
      flIns  : boolean = false;
      flHole : boolean = false;
      flW    : boolean = false;
      flA    : boolean = false;
      flS    : boolean = false;
      flD    : boolean = false;
      flYes  : boolean = false;
      flNo   : boolean = false;
      flCheat: boolean = false;
      flNext : boolean = false;
      Mas_s1 : array [1.. 8] of char      ='Arcanoid';
      Mas    : array [1.. 4] of string[12]=('New Game','Level Editor','Options','Exit');
      arrStr : array [1..20] of string[12]=
      ('Level 01.map','Level 02.map','Level 03.map','Level 04.map','Level 05.map',
       'Level 06.map','Level 07.map','Level 08.map','Level 09.map','Level 10.map',
       'Level 11.map','Level 12.map','Level 13.map','Level 14.map','Level 15.map',
       'Level 16.map','Level 17.map','Level 18.map','Level 19.map','Level 20.map');
      SaveDialog    = 'Enter New File Name:';
      Dialog        = 'Enter   Your   Name:';
      ScoreFileName = 'Score.dat';
      Save          = #60; {  F2  }
      Load          = #61; {  F3  }
      Ins           = #82; {обратные цвета}
      Left          = #75; {переместить рамку влево  }
      Right         = #77; {     ...     ...  вправо }
      Up            = #72; {     ...     ...  вверх  }
      Down          = #80; {     ...     ...  вниз   }
      Clear         = #83; {очистить поле            }
      Space         = #32; {заполнить область        }
      Escape        = #27; {выход                    }
      Tab           =  #9; {переключение цвета вперёд}
      BkSp          =  #8; {      ...     ...  назад }
      Hole          =  #7; {очистка одной ячейки     }
      SelColor      =  10; {ILBET    BbIgeJIeHHoro MeHIO      }
      mnuColor      =  15; {ILBET He BbIgeJIeHHoro MeHIO      }
      Height        =  30; {paccTo5IHue Me>|<gy nyHkTaMu MeHIO}
      N             =  20; { no X }
      M             =  33; { no Y }

VAR   x,y,x1,y1,i :integer;
      j,a,d,k,xG  :integer;
      choose,v,g  :integer;
      xT0,xT,x0,y0:integer;
      maxTiks,l   :integer;
      lx,ly,Butt  :integer;
      n2,minTiks  :integer;
      count       :longint;
      flag,flBonus:boolean;
      flS1,flS2   :boolean;
      flVictory   :boolean;
      flOptions   :boolean;
      flExist     :boolean;
      flPanel     :boolean;
      sv,p,pMap   :pointer;
      f  ,fileMap :text;
      inF,fileLev :text;
      key         :char;
      pSize,Speed :word;
      bX,bY,_x,_y :byte;
      Live  	  :byte;
      Color,status:byte;
      PunkT,oo    :byte;
      PunkTEnd    :byte;
      ScaleX,sX   :real;
      ScaleY,sY   :real;
      Ball        :TBall;
      Beat        :TBeat;
      Menu        :TMenu;
      TLevel      :PLevel;
      Pl          :TPlaces;
      st,en,indX  :shortint;
      indL ,indR  :shortint;
      src         :SearchRec;
      fLevel      :File of PLevel;
      Champ       :File of TPlaces;
      outFile     :File;
      File_Name,s :string;
      Place       :string[2];
      points,s1   :string[12];
      UserSlotName:string[25];
      Mas_Dx,Mas_x:array [1..8] of integer;
      Mas_Dy,Mas_y:array [1..8] of integer;
      arrPlaces   :array [0..2] of TPlaces;
      arrLevel    :array [1..20]of string[12];
      Tiks        :array [0..32,0..19] of byte;
      Shoot       :array [1.. 2,1.. 2] of integer;
      dGameOver, dBeatDraw, dBonus, dChance, dSpeed,
      dMove, dEditor, dMenu, dNewGame, dTheEnd: integer;
{-----------------END--VARIABLES-----------------}
{---------------BEGIN--SUPPORT-------------------}
procedure SetDelay;
begin
  dGameOver:=150;
  dBeatDraw:=200;
  dNewGame:=1500;
  dChance:=9000; {3 cekyHgbI}
  dEditor:=100;
  dTheEnd:=20;
  dSpeed:=200;
  dBonus:=150;
  dMenu:=500;
  dMove:=150;
end;
{----------------END---SUPPORT-------------------}
{----------------BEGIN---SCAN--------------------}
procedure nHandler; Interrupt;
var b:byte;
begin
  b:=Port[$60];
  case b of
    $01: flExit :=true; {Esc}
    $0C: flMinus:=true;
    $0D: flPlus :=true;
    $0E: flBkSp :=true;
    $0F: flTab  :=true;
    $10: flHole :=true; {}
    $11: flW    :=true; {W}
    $12: flNext :=true; {}
    $13: flCheat:=true; {}
    $15: flYes  :=true; {Y}
    $19: flPause:=true; {P}
    $1C: flEnter:=true;
    $1E: flA    :=true;
    $1F: flS    :=true;
    $20: flD    :=true;
    $31: flNo   :=true; {N}
    $39: flSpace:=true;
    $3C: flSave :=true; {F2}
    $3D: flLoad :=true; {F3}
    $48: flUp   :=true;
    $4B: flLeft :=true;
    $4D: flRight:=true;
    $50: flDown :=true;
    $52: flIns  :=true;
    $53: flClear:=true; {}
    $81: flExit :=false;
    $8C: flMinus:=false;
    $8D: flPlus :=false;
    $8E: flBkSp :=false;
    $8F: flTab  :=false;
    $90: flHole :=false;
    $91: flW    :=false;
    $92: flNext :=false;
    $93: flCheat:=false;
    $99: flPause:=false;
    $9C: flEnter:=false;
    $9E: flA    :=false;
    $9F: flS    :=false;
    $A0: flD    :=false;
    $B9: flSpace:=false;
    $C8: flUp   :=false;
    $CB: flLeft :=false;
    $CD: flRight:=false;
    $D0: flDown :=false;
    $D2: flIns  :=false;
    $D3: flClear:=false;
  end;
  Port[$20]:=$20;
end;
{------------------------------------------------}
procedure SetHandler;
begin
  GetIntVec($09, sv);
  SetIntVec($09, @nHandler);
end;
{------------------------------------------------}
procedure RestoreHandler;
begin
  SetIntVec($09, sv);
end;
{-------------END----SCAN------------------------}
{------------BEGIN--ARCEDIT----------------------}
procedure TBall.Init(xx, yy:integer);
begin
  x:=xx;
  y:=yy;
  angle:=45;
end;
{------------------------------------------------}
procedure TBall.Move;
begin
  dx:=sin(angle*PI/180);
  dy:=cos(angle*PI/180);
  x:=x+dx;
  y:=y+dy;
  putpixel(round(x   ), round(y   ), 15);
  putpixel(round(x-dx), round(y-dy),  0);
end;
{------------------------------------------------}
procedure DrawLevel;
var
  i, j:integer;
begin
  for j:=0 to m-6 do
      for i:=0 to n-1 do begin
(*          if (i=bX) and (j=bY) {and (Tiks[j,i]<>0)} then Tiks[j,i]:=15;*)
	  setcolor(Tiks[j, i]);
	  rectangle(round(i*scaleX), round(j*scaleY),
		    round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
	  SetFillStyle(1,Tiks[j, i]);
	  FloodFill(round(i*scaleX)+1, round(j*scaleY)+1, Tiks[j, i]);
	  setColor(0);
	  rectangle(round(i*scaleX         ), round(j*scaleY         ),
		    round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
      end;
end;
{------------------------------------------------}
procedure TBeat.Draw;
begin
  if goBeat>getMaxX-100 then goBeat:=getMaxX-100;
  if goBeat<0 then goBeat:=0;
  setcolor(0);
  rectangle(goBeat-2, getMaxY-11, goBeat+ 98, getMaxY-4);
  rectangle(goBeat-1, getMaxY-11, goBeat+ 99, getMaxY-4);
  rectangle(goBeat+1, getMaxY-11, goBeat+101, getMaxY-4);
  rectangle(goBeat+2, getMaxY-11, goBeat+102, getMaxY-4);
  if flShoot then begin
     if flS1 then begin
	putpixel(Shoot[1,1],Shoot[1,2]+5, 0);
	putpixel(Shoot[1,1],Shoot[1,2],15);
     end;
     if flS2 then begin
	putpixel(Shoot[2,1],Shoot[2,2]+5, 0);
	putpixel(Shoot[2,1],Shoot[2,2],15);
     end;
     if not flS1 then begin
	Shoot[1,1]:=goBeat;
	putpixel(Shoot[1,1]-2,Shoot[1,2], 0);
	putpixel(Shoot[1,1]-1,Shoot[1,2], 0);
	putpixel(Shoot[1,1]+1,Shoot[1,2], 0);
	putpixel(Shoot[1,1]+2,Shoot[1,2], 0);
	putpixel(Shoot[1,1]  ,Shoot[1,2],15);
     end;
     if not flS2 then begin
	 Shoot[2,1]:=goBeat+100;
	 putpixel(Shoot[2,1]-2,Shoot[2,2], 0);
	 putpixel(Shoot[2,1]-1,Shoot[2,2], 0);
	 putpixel(Shoot[2,1]+1,Shoot[2,2], 0);
	 putpixel(Shoot[2,1]+2,Shoot[2,2], 0);
	 putpixel(Shoot[2,1]  ,Shoot[2,2],15);
     end;
  end;
  setcolor(15);
  rectangle(goBeat  , getMaxY-10, goBeat+100, getMaxY-5);
end;
{------------------------------------------------}
procedure ygap;
var x,o,y  :integer;
    x1S,y1S:integer;
    x2S,y2S:integer;
begin
  o:=count;
  x:=trunc(Ball.x/scaleX);
  y:=trunc(Ball.y/scaleY);
  if (x=bX) and (y=bY) then flBonus:=not flShoot;
  if Tiks[y, x]<>0 then begin
     if (Ball.x>=x*scaleX+1) and
	(Ball.x<=x*scaleX+scaleX-1) then Ball.angle:=180-Ball.angle;
     if (Ball.y>=y*scaleY+1) and
	(Ball.y<=y*scaleY+scaleY-1) then Ball.angle:=   -Ball.angle;
     Tiks[y, x]:=0;
     count:=count+2;
     inc(minTiks);
     setColor(Tiks[y, x]);
     rectangle(round(x*scaleX         ), round(y*scaleY         ),
	       round(x*scaleX+scaleX-1), round(y*scaleY+scaleY-1));
     SetFillStyle(1,Tiks[y, x]);
     FloodFill(round(x*scaleX)+1, round(y*scaleY)+1, Tiks[y, x]);
     setColor(0);
     rectangle(round(x*scaleX         ), round(y*scaleY         ),
	       round(x*scaleX+scaleX-1), round(y*scaleY+scaleY-1));
  end;

  if flShoot then begin
     x1S:=trunc(Shoot[1,1]/scaleX);
     y1S:=trunc(Shoot[1,2]/scaleY);
     if Tiks[y1S,x1S]<>0 then begin
	if (x1S=bX) and (y1S=bY) then flBonus:=not flShoot;
	inc(count);
	inc(minTiks);
	flS1:=false;
	Tiks[y1S,x1S]:=0;
	setColor(Tiks[y1S, x1S]);
	rectangle(round(x1S*scaleX         ), round(y1S*scaleY         ),
		  round(x1S*scaleX+scaleX-1), round(y1S*scaleY+scaleY-1));
	SetFillStyle(1,Tiks[y1S, x1S]);
	FloodFill(round(x1S*scaleX)+1, round(y1S*scaleY)+1, Tiks[y1S, x1S]);
	setColor(0);
	rectangle(round(x1S*scaleX         ), round(y1S*scaleY         ),
		  round(x1S*scaleX+scaleX-1), round(y1S*scaleY+scaleY-1));
	PutPixel(Shoot[1,1],Shoot[1,2],0);
	Shoot[1,2]:=460;
     end;

     x2S:=trunc(Shoot[2,1]/scaleX);
     y2S:=trunc(Shoot[2,2]/scaleY);
     if Tiks[y2S,x2S]<>0 then begin
	if (x2S=bX) and (y2S=bY) then flBonus:=not flShoot;
	inc(count);
	inc(minTiks);
	flS2:=false;
	Tiks[y2S,x2S]:=0;
	setColor(Tiks[y2S, x2S]);
	rectangle(round(x2S*scaleX         ), round(y2S*scaleY         ),
		  round(x2S*scaleX+scaleX-1), round(y2S*scaleY+scaleY-1));
	SetFillStyle(1,Tiks[y2S, x2S]);
	FloodFill(round(x2S*scaleX)+1, round(y2S*scaleY)+1, Tiks[y2S, x2S]);
	setColor(0);
	rectangle(round(x2S*scaleX         ), round(y2S*scaleY         ),
		  round(x2S*scaleX+scaleX-1), round(y2S*scaleY+scaleY-1));
	PutPixel(Shoot[2,1],Shoot[2,2],0);
	Shoot[2,2]:=460;
     end;
  end;
  if o<>count then begin
     SetColor(0);
     OutTextXY(10,440,points);
     Str(Count,points);
     SetColor(10);
     OutTextXY(10,440,points);
  end;
end;
{-----------------END---ARCEDIT------------------}
{----------------BEGIN--ARCANOID-----------------}
procedure BkSpCur;
begin
  SetColor(0);
  OutTextXY(x0,y0,s);
  Line(xg,y,xg,y1);
  xT:=xT-1;
  Delete(s,xT,1);
  xG:=xG-TextWidth(s[xT]);
  SetColor(15);
  OutTextXY(x0,y0,s);
  Line(xg,y,xg,y1)
end;
{------------------------------------------------}
procedure InsCur;
begin
  SetColor( 0);
  OutTextXY(x0,y0,s);
  Line(xg,y,xg,y1);
  Insert(key,s,xT);
  SetColor(15);
  OutTextXY(x0,y0,s);
  xT:=xT+1;
  xG:=xG+TextWidth(key);
  Line(xg,y,xg,y1)
end;
{------------------------------------------------}
procedure Vpravo;
begin
  SetColor( 0);
  Line(xg,y,xg,y1);
  xT:=xT+1;
  xG:=xG+TextWidth(s[xT]);
  SetColor(15);
  Line(xg,y,xg,y1)
end;
{------------------------------------------------}
procedure Vlevo;
begin
  SetColor( 0);
  Line(xg,y,xg,y1);
  xT:=xT-1;
  xG:=xG-TextWidth(s[xT]);
  SetColor(15);
  Line(xg,y,xg,y1)
end;
{------------------------------------------------}
procedure Del;
begin
  SetColor( 0);
  OutTextXY(x0,y0,s);
  Delete(s,xT,1);
  SetColor(15);
  OutTextXY(x0,y0,s);
  Line(xG,y,xG,y1);
end;
{------------------------------------------------}
function Login(flg:boolean):string;
begin
  SetColor(15);
  SetTextStyle(1,0,4);
  SetTextJustify(0,2);
{ if flg=true - Add_in_Champions else SaveMap (this is comment)}
  if flg then begin
     OutTextXY(5,10,Dialog);
     x0:=355;
     y0:=18;
     y:=45;
  end
  else begin
     OutTextXY(5,445,SaveDialog);
     x0:=350;
     y0:=452;
     y :=480;
  end;
  xT0:=1;
  SetTextStyle(1,0,3);
  s:='';
  xT:=1;
  xG:=x0;
  y1:=y-TextHeight('I');
  SetColor(15);
  Line(xG,y,xG,y1);
  repeat
    key:=readkey;
    case key of
      #8:BkSpCur;
      #32..#126:InsCur;
      #0:begin key:=readkey;
	   case key of
	     #77:if Length(s)+xT0-1>=xT then Vpravo;
	     #75:if xT>xT0 then Vlevo;
	     #83:if (s<>'') and (xT<=Length(s)) then Del;
	   end
	 end;
     #27:s:='';
    end;
  until (key=#13) or (key=#27);
  Login:=s;
  ClearViewPort;
end;
{------------------------------------------------}
procedure Add_In_Champions(_Name:string; _Points:integer);
var poz,OutSider:integer;
begin
  {From Fail in arrPlaces}
  Assign(Champ,ScoreFileName);
  Reset(Champ);
  i:=0;
  while not EOF(Champ) do begin
    read(Champ,pl);
    arrPlaces[i]:=Pl;
    i:=i+1;
  end;
  Close(Champ);
  {Check place}
  OutSider:=i;
  pl.name:=_Name;
  pl.points:=_Points;
  Poz:=OutSider;
  if Pl.Points>arrPlaces[0].points then Poz:=0
  else
    for i:=0 to OutSider do
	if (Pl.Points<=arrPlaces[ i ].points) and
	   (Pl.Points>=arrPlaces[i+1].points) then begin
	     Poz:=i+1;
	     Break;
	end;
  {Add in arrPlaces}
  for i:=OutSider downto poz do
      arrPlaces[i+1]:=arrPlaces[i];
  arrPlaces[poz]:=Pl;
  {Add in Fail}
  Assign(Champ,ScoreFileName);
  Reset(Champ);
  SetTextStyle(1,0,3);
  SetColor(Cyan);
  OutTextXY( 10,0, 'Name' );
  OutTextXY(565,0,'Points');
  SetTextStyle(1,0,1);
  SetColor(15);
  i:=0;j:=35;
  repeat
    Write(Champ,arrPlaces[i]);
    Str(arrPlaces[i].Points,points);
    SetTextJustify(0,2);
    outtextxy( 25,j,arrPlaces[i].name);
    SetTextJustify(2,2);
    outtextxy(620,j,points);
    i:=i+1;
    j:=j+20;
  until (arrPlaces[i].name='') or (i=23);
  SetColor(14);
  j:=47;
  SetTextStyle(1,0,1);
  for k:=1 to i do begin
      Str(k,Place);
      OutTextXY(20,j,Place);
      j:=j+20;
  end;
  Close(Champ);
  SetTextStyle(1,0,1);
  SetColor(9);
  Rectangle(1,38+20*Poz,630,38+20*Poz+TextHeight(_Name));
  SetTextJustify(0,2);
  repeat
  until keypressed;
  ClearViewPort;
end;
{------------------------------------------------}
procedure Pause;
begin
  ClearDevice;
  SetTextStyle(1,0,7);
  SetTextJustify(1,1);
  SetColor(15);
  OutTextXY(320,240,'Pause');
  flPause:=false;
  repeat
  until flPause;
  flPause:=false;
  SetColor(0);
  OutTextXY(320,240,'Pause');
  SetTextJustify(0,2);
  SetTextStyle(1,0,1);
  DrawLevel;
end;
{------------------------------------------------}
procedure GameOver;
const Mas_s: array [1..8] of Char='GameOver';
var   Mas_Dx,Mas_Dy:array [1..8] of integer;
      Mas_x ,Mas_y :array [1..8] of integer;
      procedure _Move(var _x,_y:integer; _s:string; El:integer);
      begin
	SetColor( 0);
	OutTextXY(_x,_y,_s);
	case El of
	     1,3,6,8:begin
		       _x:=320-round((130-El*30)*cos(j*pi/60));
		       _y:=210+round((130-El*30)*sin(j*pi/30));
		     end;
	     2,4,5,7:begin
		       _x:=320-round((130-El*30)*cos(j*pi/60));
		       _y:=210-round((130-El*30)*sin(j*pi/30));
		     end;
	end;
	SetColor(15);
	OutTextXY(_x,_y,_s);
	Delay(dGameOver);
	mas_x[el]:=mas_x[el];
	mas_y[el]:=mas_y[el];
      end;
begin
  ClearDevice;
  j:=250;
  for i:=1 to 8 do begin
      mas_x [i]:=j;
      mas_y [i]:=240;
      j:=j+20;
  end;
  SetTextStyle(1,0,4);
  j:=1;
  repeat
    for i:=1 to 8 do
       _Move(mas_x[i],mas_y[i],mas_s[i],i);
    j:=j+1;
  until flExit;
  flExit:=false;
end;
{------------------------------------------------}
procedure THE_END;
var dx,dy:shortint;
begin
  ClearDevice;
  dx:=2;
  dy:=2;
  SetTextStyle(1,0,4);
  Lx:=TextWidth ('-=THE END=-');
  Ly:=TextHeight('-=THE END=-');
  x:=250;
  y:=200;
  repeat
    Delay(dTheEnd);
    SetColor( 0);
    OutTextXY(x,y,'-=THE END=-');
    if x>=635-lx then Dx:=-Dx;
    if x<=5      then Dx:=-Dx;
    if y>=475-ly then Dy:=-Dy;
    if y<=5      then Dy:=-Dy;
    x:=x+dx;
    y:=y+dy;
    SetColor(15);
    OutTextXY(x,y,'-=THE END=-');
  until flExit;
  flExit:=false;
  ClearDevice;
end;
{------------------------------------------------}
procedure StartMenu;
begin
  ClearDevice;
  SetTextJustify(1,1);
  SetTextStyle(1,0,4);
  SetColor(SelColor);
  OutTextXY(320,320,mas[1]);
  SetColor(mnuColor);
  for i:=2 to 4 do
  OutTextXY(320,320+(i-1)*Height,mas[i]);
  i:=1;
end;
{------------------------------------------------}
procedure NewGame;
begin
  Assign(fLevel,'Levels.res');
  Reset(fLevel);
  minTiks:=0;
  maxTiks:=0;
  count:=0;
  fl:=false;
  flS1:=false;
  flS2:=false;
  flBonus:=false;
  flVictory:=true;
  Shoot[1,1]:=270;
  Shoot[1,2]:=460;
  Shoot[2,1]:=370;
  Shoot[2,2]:=460;
  ScaleX:=getmaxX/N;
  ScaleY:=getmaxY/M;
  Speed:=dSpeed;
  Live:=3;
  l:=-1;
  repeat
    ClearDevice;
    if flVictory then begin
       flVictory:=false;
       flShoot:=false;
       l:=l+1;
       SetColor(15);
       SetTextStyle(1,0,4);
       SetTextJustify(1,1);
       Seek(fLevel,l);
       Read(fLevel,TLevel);
       OutTextXY(320,240,TLevel.name);
       for j:=0 to M-6 do
	   for i:=0 to N-1 do begin
	       if TLevel.Tiks[j,i]<>0 then
	       maxTiks:=maxTiks+1;
	       Tiks[j,i]:=TLevel.Tiks[j,i];
	   end;
       Delay(dNewGame);
       SetColor(0);
       OutTextXY(320,240,TLevel.name);
    end;
    SetTextStyle(1,0,2);
    SetTextJustify(0,2);
    Str(Count,points);
    SetColor(10);
    OutTextXY(10,440,points);
    Ball.Init(320,467);
    Beat.goBeat:=270;
    DrawLevel;
    repeat
      putpixel(Beat.goBeat+50+2,467, 0);
      putpixel(Beat.goBeat+50-2,467, 0);
      putpixel(Beat.goBeat+50  ,467,15);
      Beat.Draw;
      delay(dBeatDraw);
      if flLeft  then Beat.goBeat:=Beat.goBeat-2;
      if flRight then Beat.goBeat:=Beat.goBeat+2;
    until flSpace;
    flSpace:=false;
    Ball.x:=Beat.goBeat+50;
    putpixel(round(Ball.x),467,0);
    repeat
      Ball.Move;
      Beat.Draw;

      if (Ball.x>getMaxX-1) or
	 (Ball.x<0) then Ball.angle:=   -Ball.angle;
      if (Ball.y<0) then Ball.angle:=180-Ball.angle;

      if (Ball.y>=getMaxY-11) then
	 if (Ball.x>=Beat.goBeat) and
	    (Ball.x<=Beat.goBeat+100) then
	     Ball.angle:=180-Ball.angle+Beat.goBeat+50-Ball.x
	 else fl:=true;
      if flCheat then flBonus:=true;
      if (g>=getMaxY-10) then
      if (v>=Beat.goBeat) and (v<=Beat.goBeat+100) then begin
	 bX:=random(20);
	 bY:=random(10);
	 g:=round(bY*scaleY);
	 v:=round(bX*scaleX);
	 flShoot:=true;
	 flBonus:=false;
	 Speed:=dSpeed;
      end;
      ygap;
      if flBonus then begin
	 Speed:=0;
	 PutImage(v,g,p^,1);
	 delay(dBonus);
	 PutImage(v,g,p^,1);
	 if (v<=0) or (v>=620) then bdx:=-bdx;
	 if g>=470 then begin
	    flBonus:=false;
	    Speed:=dSpeed;
	 end;
	 v:=v+bdx;
	 g:=g+2;
      end;
      delay(dSpeed);
      if flShoot then begin
	 if flS1 then begin
	    if Shoot[1,2]>=0 then
	       Shoot[1,2]:=Shoot[1,2]-5;
	    if Shoot[1,2]<=0 then begin
	       putpixel(Shoot[1,1],Shoot[1,2]+5,0);
	       Shoot[1,2]:=460;
	       flS1:=false;
	    end;
	 end;
	 if flS2 then begin
	    if Shoot[2,2]>=0 then
	       Shoot[2,2]:=Shoot[2,2]-5;
	    if Shoot[2,2]<=0 then begin
	       putpixel(Shoot[2,1],Shoot[2,2]+5,0);
	       Shoot[2,2]:=460;
	       flS2:=false;
	    end;
	 end;
      end;
      if flNext    then minTiks:=maxTiks;
      if flPause   then Pause;
      if flLeft    then Beat.goBeat:=Beat.goBeat-2;
      if flRight   then Beat.goBeat:=Beat.goBeat+2;
      if flPlus    then dSpeed:=dSpeed-1;
      if flMinus   then dSpeed:=dSpeed+1;
      if dSpeed>300 then dSpeed:=300;
      if dSpeed<100 then dSpeed:=100;
      if flSpace   then begin
	 if not flS1 then flS1:=true;
	 if not flS2 then flS2:=true;
      end;
      if flExit    then begin
	 ClearDevice;
	 SetColor(15);
	 SetTextJustify(1,1);
	 SetTextStyle(1,0,3);
	 OutTextXY(320,240,'Are You Sure? [<Y>es-<N>o]');
	 repeat
	 until flYes or flNo;
	 flNo:=false;
	 Setcolor(0);
	 OutTextXY(320,240,'Are You Sure? [<Y>es-<N>o]');
	 if flYes then Break
	 else
	   for j:=0 to m-6 do
	   for i:=0 to n-1 do begin
	       setcolor(Tiks[j, i]);
	       rectangle(round(i*scaleX), round(j*scaleY),
			 round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
	       SetFillStyle(1,Tiks[j, i]);
	       FloodFill(round(i*scaleX)+1, round(j*scaleY)+1, Tiks[j, i]);
	       setColor(0);
	       rectangle(round(i*scaleX         ), round(j*scaleY         ),
			 round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
	   end;
      end;
    until fl or (minTiks>=maxTiks);

    flExit:=false;
    if flYes then break;
    if (minTiks>=maxTiks) then
       if l>=19 then  Live:=0
       else flVictory:=true;
    if (minTiks< maxTiks) then
       if fl then begin
	  if Live>1 then begin
	     flVictory:=false;
	     SetTextJustify(1,1);
	     SetTextStyle(1,0,3);
	     Live:=Live-1;
	     Str(Live,s);
	     ClearDevice;
	     SetColor(15);
	     OutTextXY(320,240,'OCTAJIOCb '+s+' CHANCE');
	     Delay(dChance);{3 cekyHgbI}

	     SetColor(0);
	     OutTextXY(320,240,'OCTAJIOCb '+s+' CHANCE');
	  end
	  else break
       end;
    fl:=false;
    flShoot:=false;
  until Live<1;
  Close(fLevel);
  if not flYes then begin
     ClearDevice;
     if l>=19 then THE_END
     else GameOver;
     RestoreHandler;
     Add_In_Champions(Login(true),Count);
     flYes:=false;
     SetHandler;
  end;
  StartMenu;
end;
{------------------------------------------------}
procedure FlyBonus;
begin
  Rectangle(0,0,20,20);
  PutPixel( 4,14,15);
  PutPixel(16,14,15);
  Rectangle(2,16,18,18);
  pSize:=ImageSize(0,0,20,20);
  GetMem(p,pSize);
  GetImage(0,0,20,20,p^);
  PutImage(0,0,p^,4);
end;
{-------------END--ARCANOID----------------------}
{------------BEGIN--MAPLOAD----------------------}
procedure npopucoBka(Name:string; pozX,pozY:integer);
var l:byte;
begin
  Assign(f,Name);
  Reset(f);
  for j:=0 to m-6 do
      for i:=0 to n-1 do begin
	  Read(f,l);
	  setColor(7);
	  rectangle(pozX+round(i*sX),pozY+round(j*sY),
		    pozX+round(i*sX+sX-1),pozY+round(j*sY+sY-1));
	  SetFillStyle(1,l);
	  FloodFill(pozX+round(i*sX)+1,pozY+round(j*sY)+1,7);
      end;
  Close(f);
end;
{------------------------------------------------}
procedure FindMap;
begin
  FindFirst('map\*.map',$2F,src);
  PunkT:=0;
  new(Menu.Cnucok);
  Menu.name:=Menu.Cnucok;
  Menu.name^.last:=nil;
  while DosError = 0 do begin
    PunkT:=PunkT+1;
    Menu.name^.name:=src.name;
    Menu.name^.active:=false;
    FindNext(src);
    if DosError = 0 then begin
       new(Menu.name^.next);
       Menu.name^.next^.last:=Menu.name;
       Menu.name:=Menu.name^.next;
    end;
  end;
  PunkTEnd:=PunkT;
  Menu.Cnucok^.active:=true;
  Menu.name^.next:=nil;
end;
{------------------------------------------------}
procedure TMenu.Add(newFile:string);
begin
  New(name2);
  PunkTEnd:=PunkTEnd+1;
  name:=Cnucok;
  name2^.name:=newFile;
  name2^.active:=false;
  name2^.last:=nil;
  name2^.next:=name;
  name^.last:=name2;
  Cnucok:=name2;
end;
{------------------------------------------------}
procedure TMenu.Init(col:byte);
var ii: byte;
begin
  new(Cnucok);
  Mark(p);
  name:=Cnucok;
  name^.last:=nil;
  for ii:=1 to col do begin
      name^.name:='';
      name^.active:=false;
      if ii<>col then begin
	 new(name^.next);
	 name^.next^.last:=name;
	 name:=name^.next;
      end;
  end;
  Cnucok^.active:=true;
  name^.next:=nil;
end;
{------------------------------------------------}
procedure TMenu.MoveItem(dx:shortint; var ind,stt:shortint; mve:boolean);
begin
  if dx<0 then begin
     name^.active:=false;
     name:=name^.last;
     name^.active:=true;
  end
  else begin
     name^.active:=false;
     name:=name^.next;
     name^.active:=true;
  end;
  ind:=ind+dx;
  if mve then
  stt:=stt+dx;
  Scrolling(stt);
end;
{------------------------------------------------}
procedure TMenu.Scrolling(sst:byte);
var kk:byte;
    strng:string[12];
    noX:integer;
begin
  if flOptions then
       noX:=155
  else noX:=1;
  name:=Cnucok;
  for kk:=1 to sst do
      if kk<>sst then
	 name:=name^.next;

  for kk:=sst to sst+19 do begin
      setcolor(0);
      OutTextXY(noX,15*(kk-sst+1),name^.last^.name);
      OutTextXY(noX,15*(kk-sst+1),name^.next^.name);
      if name^.active then begin
	 strng:=name^.name;
	 setcolor(10);
      end
      else setcolor(15);
      OutTextXY(noX,15*(kk-sst+1),name^.name);
      if kk<>sst+19 then name:=name^.next;
      if name=nil then break;
  end;
  if flOptions then npopucoBka('map\'+strng,310,250)
  else npopucoBka('map\'+strng,310,10);
  name:=Cnucok;
  while not name^.active do
	name:=name^.next;
end;
{------------------------------------------------}
procedure Init(var Level:string; flag:boolean);
begin
  RestoreHandler;
  sX:=GetMaxX div 2/n;
  sY:=GetMaxY div 2/m;
  Mark(Menu.p);
  FindMap;
  PunkT:=1;
  s1:='';
  x:=300;
  st:=1;
  key:=#0;
  Menu.Scrolling(st);
  for j:=0 to m-6 do
      for i:=0 to n-1 do begin
	  setColor(Tiks[j,i]);
	  rectangle(310+round(i*sX     ), 240+round(j*sY     ),
		    310+round(i*sX+sX-1), 240+round(j*sY+sY-1));
	  SetFillStyle(1,Tiks[j, i]);
	  FloodFill(310+round(i*sX)+1   , 240+round(j*sY)+1, Tiks[j, i]);
	  setColor(7);
	  rectangle(310+round(i*sX     ), 240+round(j*sY),
		    310+round(i*sX+sX-1), 240+round(j*sY+sY-1));
      end;
  indx:=1;
  Menu.name:=Menu.Cnucok;
  repeat
    key:=readkey;
    case key of
      #13:Level:=Menu.name^.name;
      'n':if flag then begin
	     setcolor(0);
	     arc(305,230,90,270,40);
	     line(295,180,305,190);
	     line(300,205,305,190);
	     setcolor(15);
	     arc(305,310,90,180,40);
	     line(265,310,265,450);
	     line(255,440,265,450);
	     line(275,440,265,450);
	     s1:=Login(false)+'.MAP';
	     Menu.name:=Menu.Cnucok;
	     flExist:=false;
	     repeat
	       if Menu.name^.name =s1 then flExist:=true;
	       Menu.name:=Menu.name^.next;
	     until (Menu.name^.last^.name = s1) or (Menu.name = nil);
	     if flExist then begin
		SetTextStyle(1,0,3);
		SettextJustify(1,1);
		SetColor(4);
		OutTextXY(320,200,'This Is File EXIST');
		OutTextXY(320,240,'OWERITE This File? -=DA=--=HET=-');
		repeat
		  key:=readkey;
		until (key='y') or (key='n');
		if key='y' then begin
		   assign(f,'map\'+s1);
		   rewrite(f);
		   for j:=0 to m-6 do begin
		       write(f,#10#13);
		       for i:=0 to n-1 do
			   Write(f,Tiks[j,i],' ');
		   end;
		Close(f);
		end;
	     end;
	     break;
	  end;
       #0:case ReadKey of
	    #80: if (indx<>st+19) and
		    (indx<>PunkTEnd) then Menu.MoveItem( 1,indx,st,false)
	    else if (indx<>PunkTEnd) then Menu.MoveItem( 1,indx,st,true );
	    #72: if (indx<>st)       then Menu.MoveItem(-1,indx,st,false)
	    else if (indx<>1)        then Menu.MoveItem(-1,indx,st,true );
	  end;
    end;
  until (key=#27) or (key=#13);
  if s1<>''  then Level:=s1;
  if key=#27 then Level:='';
  key:=#0;
  Menu.name:=Menu.Cnucok;
  repeat
    if Menu.name^.name =Level then
       Menu.name^.name:=Level;
       Menu.name:=Menu.name^.next;
  until (Menu.name^.last^.name = Level) or (Menu.name = nil);
  Release(Menu.p);
  SetHandler;
  ClearDevice;
end;
{---------------END--MAPLOAD---------------------}
{--------------BEGIN--EDITOR---------------------}
procedure npopucoBka2;
begin
  for j:=0 to m-6 do
      for i:=0 to n-1 do begin
	  setColor(7);
	  rectangle(round(i*scaleX), round(j*scaleY),
		    round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
	  SetFillStyle(1,Tiks[j,i]);
	  FloodFill(round(i*ScaleX)+1,round(j*ScaleY)+1,7);
      end;
end;
{------------------------------------------------}
procedure Write_Menu;
begin
  npopucoBka2;
  SetColor(10);
  SetTextStyle(0,0,0);
  SetTextJustify(0,1);
  OutTextXY(170,412,'Help  - F1' );
  OutTextXY(170,422,'Save  - F2' );
  OutTextXY(170,432,'Load  - F3' );
  OutTextXY(170,442,'Clear - Del');

  OutTextXY(300,412,'Last Color - BkSp' );
  OutTextXY(300,422,'Next Color - Tab'  );
  OutTextXY(300,432,'Flood Fill - Space');
  OutTextXY(300,442,'Exit       - Esc'  );
  {----====PucoBaHue AKTuBHbIX ZBETOB====-----}
  OutTextXY( 20,442,'Current color');
  SetColor(7);
  Rectangle(                160, round(32*scaleY  ),
	    round(ScaleX-1)+160, round(33*scaleY-1));

  for i:=1 to 4 do begin
      SetColor(i);
      Rectangle(round(i*scaleX*2+         160), round(32*scaleY  ),
		round(i*scaleX*2+scaleX-1+160), round(33*scaleY-1));
      SetFillStyle(1,i);
      FloodFill(round(i*scaleX*2)+        161 , round(32*scaleY)+1,i);
  end;
end;
{------------------------------------------------}
procedure Move_Up;
begin
  for j:=0 to m-6 do
      for i:=0 to n-1 do
      Tiks[j,i]:=Tiks[j+1,i];
  npopucoBka2;
end;
{------------------------------------------------}
procedure Move_Down;
begin
  for i:=0 to n-1 do begin
      for j:=m-6 downto 1 do
	  Tiks[j,i]:=Tiks[j-1,i];
      Tiks[0,i]:=0;
  end;
  npopucoBka2;
end;
{------------------------------------------------}
procedure Move_Right;
begin
  for j:=0 to m-6 do begin
      for i:=n-1 downto 1 do
	  Tiks[j,i]:=Tiks[j,i-1];
      Tiks[j,0]:=0;
  end;
  npopucoBka2;
end;
{------------------------------------------------}
procedure Move_Left;
begin
  for j:=0 to m-6 do begin
      for i:=1 to n-1 do
	  Tiks[j,i-1]:=Tiks[j,i];
      Tiks[j,19]:=0;
  end;
  npopucoBka2;
end;
{------------------------------------------------}
procedure Main_Window;
begin
  for j:=0 to m-6 do
    for i:=0 to n-1 do begin
	setColor(7);
	rectangle(round(i*scaleX), round(j*scaleY),
		  round(i*scaleX+scaleX-1), round(j*scaleY+scaleY-1));
    end;
end;
{------------------------------------------------}
procedure LoadMap;
begin
  ClearDevice;
  SetColor(15);
  OutTextXY(390,230,' -=3ArPY3KA KAPTbI=- ');
  arc(305,230,90,270,40);
  line(293,257,305,270);
  line(290,280,305,270);
  Init(File_Name,false);
  if File_Name<>'' then begin
     Assign(f,'map\'+File_Name);
     Reset(f);
     for j:=0 to M-6 do
	 for i:=0 to N-1 do
	     Read(f, Tiks[j, i]);
     Close(f);
  end;
  Write_Menu;
  flLoad:=false;
end;
{------------------------------------------------}
procedure SaveMap;
begin
  ClearDevice;
  SetColor(15);
  OutTextXY(390,230,'-=COXPAHEHUE KAPTbI=-');
  arc(305,230,90,270,40);
  line(295,180,305,190);
  line(300,205,305,190);
  Init(File_Name,true);
  if (File_Name<>'') and (File_Name<>'.MAP') then begin
     Assign(f,'map\'+File_Name);
     ReWrite(f);
     for j:=0 to m-1 do begin
	 Write(f,#10#13);
	 for i:=0 to n-1 do
	     Write(f, Tiks[j, i],' ');
     end;
     Close(f);
     Menu.Add(File_Name);
     ClearDevice;
  end;
  Write_Menu;
  flSave:=false;
end;
{------------------------------------------------}
procedure _Clear;
begin
  for j:=0 to m-6 do
    for i:=0 to n-1 do
	Tiks[j,i]:=0;
  npopucoBka2;
end;
{------------------------------------------------}
procedure Invert;
begin
  for j:=0 to m-6 do
      for i:=0 to n-1 do
      Tiks[j,i]:=abs(Tiks[j,i]-4);
  npopucoBka2;
end;
{------------------------------------------------}
procedure InitEditor;
begin
  scaleX:=GetMaxX/n;
  scaleY:=GetMaxY/m;
  ClearDevice;
  SetTextStyle(0,0,0);
  SetTextJustify(0,1);
  for j:=0 to m-6 do
      for i:=0 to n-1 do
	  Tiks[j,i]:=0;
  Write_Menu;
  Color:=0;
  x :=0;
  y :=0;
  x1:=0;
  y1:=0;
  _x:=0;
  _y:=0;
  SetColor(0);
  Rectangle(0,0,round(ScaleX-1),round(ScaleY-1));
  repeat
    if flSave  then SaveMap;
    if flLoad  then LoadMap;
    SetColor(Color);
    x1:=round(_x*ScaleX);
    y1:=round(_y*ScaleY);
    Rectangle(x1,y1,round(x1+ScaleX-1),round(y1+ScaleY-1));
    delay(dEditor);
    if flLeft  then if _x= 0 then _x:=19 else _x:=_x-1;
    if flRight then if _x=19 then _x:= 0 else _x:=_x+1;
    if flUp    then if _y= 0 then _y:=27 else _y:=_y-1;
    if flDown  then if _y=27 then _y:= 0 else _y:=_y+1;
    if flClear then _Clear;
    if flIns   then Invert;
    if flHole  then begin
       Tiks[_y,_x]:=0;
       SetFillStyle(1,0);
       FloodFill(round(_x*ScaleX+1), round(_y*ScaleY+1),7);
    end;
    if flSpace then begin
       Tiks[_y, _x]:= Color;
       SetColor(7);
       rectangle(round(_x*scaleX), round(_y*scaleY),
		 round(_x*scaleX+scaleX-1),round(_y*scaleY+scaleY-1));
       SetFillStyle(1,Color);
       FloodFill(round(_x*ScaleX+2), round(_y*ScaleY+2),7);
    end;
    if flTab   then if Color=4 then Color:=0 else Color:=Color+1;
    if flBkSp  then if Color=0 then Color:=4 else Color:=Color-1;
    if flW     then Move_Up;
    if flA     then Move_Left;
    if flS     then Move_Down;
    if flD     then Move_Right;
    if flExit  then begin
       ClearDevice;
       SetColor(15);
       SetTextJustify(1,1);
       SetTextStyle(1,0,3);
       OutTextXY(320,240,'COXPAHUTb KAPTY? -=DA=--=HET=-');
       repeat
       until flYes or flNo;
       SetColor(0);
       OutTextXY(320,240,'COXPAHUTb KAPTY? -=DA=--=HET=-');
       if flYes then SaveMap;
       flNo:=false;
       flYes:=false;
       Break;
    end;
    SetColor(Color);
    Rectangle(50,460,82,475);
    SetFillStyle(1,Color);
    FloodFill(55,465,Color);
    SetColor(7);
    Rectangle(x1,y1,round(x1+ScaleX-1),round(y1+ScaleY-1));
    SetColor(Color);
    x :=round(_x*ScaleX);
    y :=round(_y*ScaleY);
    Rectangle(x ,y ,round(x +ScaleX-1),round(y +ScaleY-1));
  until flExit;
  flExit:=false;
  StartMenu;
  key:=#0;
end;
{-----------------END---EDITOR-------------------}
{----------------BEGIN---MEHU--------------------}
procedure o6pucoBka(flag:boolean);
begin
  SetColor(mnuColor);
  OutTextXY(320,320+(i-1)*Height,mas[i]);
  if flag then if i=1 then i:=4 else dec(i)
  else         if i=4 then i:=1 else inc(i);
  SetColor(SelColor);
  OutTextXY(320,320+(i-1)*Height,mas[i]);
end;
{------------------------------------------------}
procedure _Move(var _x,_y,_dx,_dy:integer; _s:string; El:integer);
begin
  SetColor( 0);
  OutTextXY(_x,_y,_s);
  if _x>=635-Lx then _Dx:=-_Dx;
  if _x<=5      then _Dx:=-_Dx;
  if _y>=315-Ly then _Dy:=-_Dy;
  if _y<=5      then _Dy:=-_Dy;
  _x:=_x+_dx;
  _y:=_y+_dy;
  Delay(dMove);
  SetColor(10);
  OutTextXY(_x,_y,_s);
  mas_x [el]:=mas_x [el];
  mas_y [el]:=mas_y [el];
  mas_dx[el]:=mas_dx[el];
  mas_dy[el]:=mas_dy[el];
end;
{------------------------------------------------}
procedure Nachalo;
begin
  j:=150;
  for i:=1 to 8 do begin
      mas_dx[i]:=-5;
      mas_dy[i]:=-5;
      mas_x [i]:= j;
      mas_y [i]:= j-50;
      j:=j+20;
  end;
  SetTextStyle(1,0,3);
  Lx:=TextWidth ('m');
  Ly:=TextHeight('G');
end;
{-----------------END----MEHU--------------------}
{----------------BEGIN--OPTIONS------------------}
procedure MoveItemLevels(pnkt:byte);
var jj:byte;
begin
  for jj:=1 to 20 do begin
      if jj=pnkt then
	   setcolor(10)
      else setcolor(15);
      OutTextXY(10,10+(jj-1)*15,arrStr[jj]);
  end;
  npopucoBka('Levels\'+arrStr[pnkt],310,10)
end;
{------------------------------------------------}
procedure Change(fLev, fMap:string);
var TiksLev,TiksMap:array [0..32,0..19] of byte;
begin
  Assign(fileLev,'Levels\'+fLev);
  Assign(fileMap,'Map\'   +fMap);
  Reset(fileLev);
  Reset(fileMap);
  for j:=0 to m-6 do
      for i:=0 to n-1 do begin
	  read(fileLev,TiksLev[j,i]);
	  read(fileMap,TiksMap[j,i]);
      end;
  Close(fileLev);
  Close(filemap);
  ReWrite(fileLev);
  ReWrite(fileMap);
  for j:=0 to m-6 do begin
      Write(fileLev,#10#13);
      Write(fileMap,#10#13);
      for i:=0 to n-1 do begin
	  Write(fileLev,TiksMap[j,i],' ');
	  Write(fileMap,TiksLev[j,i],' ');
      end;
  end;
  Close(fileLev);
  Close(fileMap);
  npopucoBka('Levels\'+fLev,310, 10);
  Menu.Scrolling(st);
end;
{------------------------------------------------}
procedure AddLevels;
begin
  assign(fLevel,'Levels.res');
  rewrite(fLevel);
  for oo:=1 to 20 do begin
      Assign(inF,'Levels\'+arrStr[oo]);
      Reset(inF);
      TLevel.name:=arrStr[oo];
      for j:=0 to m-6 do
	  for i:=0 to n-1 do begin
	      read(inF,Tiks[j,i]);
	      TLevel.Tiks[j,i]:=Tiks[j,i];
	  end;
      Write(fLevel,TLevel);
      Close(inF);
  end;
  Close(fLevel);
end;
{------------------------------------------------}
procedure Options;
var newfile:text;
begin
  ClearDevice;
  flOptions:=true;
  SetTextStyle(1,0,1);
  SetTextJustify(0,2);

  SetColor(10);
  OutTextXY(10,350,'Tab   -> Change active panel');
  OutTextXY(10,370,'Left  -> Add map in game');
  OutTextXY(10,390,'Right -> Add level in editor');
  OutTextXY(10,410,'Escape-> Exit to main menu');

 {Нарисовать двухстолбчатую панель с предварительным просмотром соответствующих
  выбранных уровней (С панели на панель можно переходить при помощи клавиши
  "Tab"). При нажатии клавиши "Enter", выбранные файлы меняются местами.
  Уменьшение количества уровней нельзя. При нажатии клавиши "Right", файл
  прохождения можно будет отредактировать только после выхода из меню "Options".}

  {Draw left panel (Arcanoid's Levels)}
  RestoreHandler;
  flPanel:=false;
  indL:=1;{Индекс пункта меню на левой  панели}
  indR:=1;{Индекс пункта меню на правой панели}
  MoveItemLevels(indL);
  {flPanel - false - Left Panel
   flPanel - true  - Right Panel}
  {Draw right panel (Editor's maps)}
  Mark(pMap);
  FindMap;
  Menu.name:=Menu.Cnucok;
  st:=1;
  Menu.Scrolling(1);
  SetColor(4);
  Rectangle(  0,5,140,320);
  Rectangle(300,5,635,220);
  {Work with two panels}
  repeat
    key:=readkey;
    case key of
       #0:case readkey of
	     Up :if flPanel then
		       if indR<>st then Menu.MoveItem(-1,indR,st,false)
		  else if indR<>1  then Menu.MoveItem(-1,indR,st,true ) else
		  else if indL<>1  then indL:=indL-1;
	    Down:if flPanel then
		       if (indR<>st+19) and
			  (indR<>PunkTEnd) then Menu.MoveItem( 1,indR,st,false)
		  else if (indR<>PunkTEnd) then Menu.MoveItem( 1,indR,st,true ) else
		  else if indL<>20 then indL:=indL+1;
	    Left:if flPanel then
		    Change(arrStr[indL],Menu.name^.name);
	   Right:if not flPanel then begin
		    Menu.name:=Menu.Cnucok;
		    flExist:=false;
		    repeat
		      if Menu.name^.name =arrStr[indL] then flExist:=true;
			 Menu.name:=Menu.name^.next;
		    until (Menu.name^.last^.name = arrStr[indL]) or (Menu.name = nil);
		    if not flExist then begin
		       Menu.Add(arrStr[indL]);
		       assign(fileMap,'map\'+arrStr[indL]);
		       assign(fileLev,'Levels\'+arrStr[indL]);
		       rewrite(fileMap);
		       reset(fileLev);
		       for j:=0 to m-6 do begin
			   write(fileMap,#10#13);
			   for i:=0 to n-1 do begin
			       read(fileLev,Tiks[j,i]);
			       write(fileMap,Tiks[j,i],' ');
			   end;
		       end;
		       Close(fileMap);
		       Close(fileLev);
		       Menu.Scrolling(st);
		       indR:=indR+1;
		       st:=1;
		    end;
		 end;
	  end;
      Tab:begin
	    flPanel:=not flPanel;
	    setcolor(0);
	       rectangle(  0,  5,140,320);
	       rectangle(300,  5,635,220);
	       rectangle(150,  5,285,320);
	       rectangle(300,245,635,460);
	    setcolor(4);
	    if not flPanel then begin
	       rectangle(  0,  5,140,320);
	       rectangle(300,  5,635,220);
	    end
	    else begin
	       rectangle(150,  5,285,320);
	       rectangle(300,245,635,460);
	    end;
	  end;
    end;
    if not flPanel then
       MoveItemLevels(indL);
  until key=#27;
  flOptions:=false;
  Release(pMap);
  ClearDevice;
  SetColor(15);
  SetTextStyle(1,0,4);
  SetTextJustify(1,1);
  OutTextXY(320,240,'Save this configure? -=DA=--=HET=-');
  repeat
    key:=readkey;
  until (key='y') or (key='n');
  if key='y' then AddLevels;
  SetHandler;
  SetTextStyle(1,0,4);
  SetTextJustify(1,1);
  StartMenu;
  flEnter:=false;
end;
{-----------------END-OPTIONS--------------------}
{----------------START-GAME----------------------}
var Driver, Mode: Integer;
    FontF: file;
    FontP: pointer;

BEGIN
  Assign(FontF,'Trip.chr');
  Reset(FontF, 1);
  GetMem(FontP, FileSize(FontF));
  BlockRead(FontF, FontP^, FileSize(FontF));
  if RegisterBGIfont(FontP) < 0 then begin
     WriteLn('Error registering Triplex font: ',
	      GraphErrorMsg(GraphResult));
     Halt(1);
  end;
  InitGraph(a,d,'d:\lexa\turbo_~1\bgi');
  SetDelay;
  Nachalo;
  FlyBonus;
  randomize;
  bX:=random(20);
  bY:=random(20);
  scaleX:=getMaxX/n;
  scaleY:=getMaxY/m;
  sX:=getMaxX div 2/n;
  sY:=getMaxY div 2/m;
  v:=round(bX*ScaleX);
  g:=round(bY*ScaleY);
  StartMenu;
  SetHandler;
  i:=1;
  repeat
    delay(dMenu);
    if flEnter then case i of
       1: NewGame;
       2: InitEditor;
       3: Options;
    end;
    if flUp    then o6pucoBka(true );
    if flDown  then o6pucoBka(false);
    for k:=1 to 8 do
	_Move(mas_x [k],mas_y [k],
	      mas_dx[k],mas_dy[k],mas_s1[k],k);
  until flExit or (flEnter and (i=4));
  RestoreHandler;
  CloseGraph;
END.
