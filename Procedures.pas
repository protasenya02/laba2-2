

unit Procedures;

interface
uses
System.SysUtils, Types, Windows, DateUtils;

procedure ReadFile;
function  SearchHead:TAddressWorkList;
procedure SaveFile( HeadAddress:TAddressWorkList );
procedure OutputElement(CurrentElement:TAddressWorkList);
procedure AddElements(HeadAddress: TAddressWorkList);
procedure WatchTheList(HeadAddress:TAddressWorkList);
procedure clrscr;
function  PrintMenuTasks:string;
procedure MainMenu;
Procedure DeleteElement(HeadAddress:TAddressWorkList);
procedure EditElement(HeadAddress:TAddressWorkList);
procedure SortElements(HeadAddress:TAddressWorkList);
procedure SortByDate(HeadAddress:TAddressWorkList);
procedure SearchByNameOfWorker(HeadAddres: TAddressWorkList;NameOfWorker:string);
procedure SearchElements(HeadAddres: TAddressWorkList);
procedure SearchByNameOfTheProject(HeadAddres: TAddressWorkList;NameOfTheProject:string);
procedure SearchByTask (HeadAddres: TAddressWorkList;Task:string);
procedure SearchByDateBeforeDo (HeadAddres: TAddressWorkList;Date:string);
procedure SearchByStartTime (HeadAddres: TAddressWorkList;Time:string);
procedure SearchByFinishTime (HeadAddres: TAddressWorkList;Time:string);
procedure WorkerTaskOverMonth(HeadAddres:TAddressWorkList);
function  CompareDates (FirstElement,SecondElement:TAddressWorkList):boolean;
function  GetPreviousMonth: TDateTime;
function  SearchMonthName(k:word): string;
procedure SumTimeOfWork (HeadAddress:TAddressWorkList);
procedure ClearMemory( HeadAddress: TAddressWorkList);
procedure SwapElementsOfWorkList (FirstElement, SecondElement:TAddressWorkList);

implementation

procedure ReadFile;   //������ �� �����
begin
   AssignFile( WorkFile, 'File Of Work.txt');
   if FileExists('File Of Work.txt') then
   Reset(WorkFile) //������
   else
   Rewrite(WorkFile);  //������
end;

function SearchHead:TAddressWorkList;
var   Head, Temp: TAddressWorkList;
begin
  Reset(WorkFile); //������
  New(Head);
  Head^.address:=nil;
  result:= Head;  // ����� ������ ������� ��������
  Temp:=Head;
  while not(Eof(WorkFile)) do
  begin
  New(Temp^.Address);
  Temp:=Temp^.Address;
  Read(WorkFile,Temp^.Work);
  Temp^.Address:=nil;
  end;
end;

procedure SaveFile( HeadAddress:TAddressWorkList);   //���������� �����
var CurrentElement: TAddressWorkList;
begin
  writeln;
  AssignFile( WorkFile, 'File Of Work.txt');
  Rewrite(WorkFile);
  CurrentElement:= HeadAddress;
    if CurrentElement^.Address<>nil then
      begin
         while CurrentElement^.Address<>nil do
          begin
          CurrentElement:=CurrentElement^.Address;
          write(WorkFile,CurrentElement^.Work);
         end;
         CloseFile(WorkFile);
         writeln('��������� ���� ���������');
         ClearMemory(HeadAddress);
      end;
end;

procedure OutputElement(CurrentElement:TAddressWorkList);    //����� 1 ��������
begin
    with  CurrentElement^.Work do
          begin
               write('��� �����������: ');
               writeln (NameOfWorker);
               write('�������� �������: ');
               writeln(NameOfTheProject);
               write('������� � ������ ������� �������: ');
               writeln( Task);
               write('���� ����� �������: ');
               writeln(DateBeforeDo);
               write('����� ������ ������: ');
               writeln(StartTime);
               write('����� ��������� ������: ' );
               writeln(FinishTime);
               writeln;
          end;
end;

procedure AddElements( HeadAddress: TAddressWorkList); //���������� ��������� � ������
var CurrentAddress: TAddressWorkList;
    NumberOfElements,i: integer;
begin
  CurrentAddress :=HeadAddress;
  while (CurrentAddress^.Address<>nil) do
  CurrentAddress:= CurrentAddress^.address;
  writeln('������� ���������� ���������, ������� �� ������ ��������:');
  readln(NumberOfElements );
      for i := 1 to NumberOfElements do
      begin
       writeln;
       New(CurrentAddress^.Address);
       CurrentAddress:=CurrentAddress^.Address;
         with  CurrentAddress^.Work do
            begin
         write('��� �����������: ');
         readln (NameOfWorker);
         write('�������� �������: ');
         readln(NameOfTheProject);
         write('������� � ������ ������� �������: ');
         readln( Task);
         write('���� ����� �������: ');
         readln(DateBeforeDo);
         write('����� ������ ������: ');
         readln(StartTime);
         write('����� ��������� ������: ' );
         readln(FinishTime);
         writeln;
        end;
        CurrentAddress^.address:=nil;
      end;
      writeln;
      if NumberOfElements=1 then
      writeln('������� ��������.')
      else
      writeln ('�������� ���������.');
end;

procedure WatchTheList(HeadAddress:TAddressWorkList);  // �������� ����� ������
var CurrentAddress: TAddressWorkList;
begin
  CurrentAddress:=HeadAddress;
 if   CurrentAddress^.Address=nil then
  writeln('������ ������. �������� ��������!')
   else
     begin
        writeln('���� ������ �����:');
        writeln;
       while CurrentAddress^.Address<>nil do
         begin
            with CurrentAddress^.Address^.Work do
            begin
             write('��� �����������: ');
             writeln (NameOfWorker);
             write('�������� �������: ');
             writeln(NameOfTheProject);
             write('������� � ������ ������� �������: ');
             writeln( Task);
             write('���� ����� �������: ');
             writeln(DateBeforeDo);
             write('����� ������ ������: ');
             writeln(StartTime);
             write('����� ��������� ������: ' );
             writeln(FinishTime);
             writeln;
            end;
          CurrentAddress:=CurrentAddress^.Address;
         end;

   end;
end;

procedure clrscr;  // ������� �������
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

function PrintMenuTasks:string;        //����� ������� ����
begin
    writeln('�������� ����� ����: ');
    writeln;
    writeln('1. ������ ������ �� �����');
    writeln('2. �������� ����� ������ ');
    writeln('3. ���������� ������  �� ���� ��� ���������� ');
    writeln('4. ����� ������ � �������������� ��������');
    writeln('5. ���������� ������ � ������ ');
    writeln('6. �������� ������ �� ������ ');
    writeln('7. �������������� ������ ');
    writeln('8. C����� ����������� � ��������� ���������� ������� �� ������ �� ��������� ����� ');
    writeln('9. ������ ���� �����, ������ ��� �������� ������ ����� ����������� �� ������� �����');
    writeln('10. ����� �� ��������� ��� ���������� ���������');
    writeln('11. ����� � ����������� ���������');
    writeln;
end;

procedure MainMenu;           //����
var Choise: integer;

begin
    PrintMenuTasks;
    readln(Choise);

    if (Choise>11) or (Choise<1)  then
    begin
    writeln('�� ����� �������� ��������. ���������� ��� ���!');
    writeln;
    MainMenu;
    end;


    case  Choise of
     1:
             begin
              ReadFile;
              writeln('���� ��������');
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;

     2:
              begin
              WatchTheList(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;

      3:
              begin
              SortElements(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;

      4:
              begin
              SearchElements(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;


     5:
              begin
              AddElements(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;

     6:
              begin
              DeleteElement(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;

     7:
             begin
              EditElement(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
             end;
     8:
            begin
              SumTimeOfWork (HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
            end;

     9:
            begin
              WorkerTaskOverMonth(HeadAddress);
              writeln('������� enter ��� ����������� � ������� ����');
              readln;
              clrscr;
              MainMenu;
            end;


     10:  ClearMemory(HeadAddress);

     11:   SaveFile(HeadAddress);

  end;
end;

Procedure DeleteElement(HeadAddress:TAddressWorkList);  //�������� �������� ������
var CurrentElement, PrevElement: TAddressWorkList;
    Choise: integer;
    Found: boolean;
    NameOfWorker, NameOfTheProject,Answer: string;
begin
   CurrentElement:=HeadAddress;
   if CurrentElement^.Address=nil then
   begin
   writeln('������ ������. �������� ��������!');
   writeln('������� enter ��� ����������� � ������� ����');
   readln;
   clrscr;
   MainMenu;
   end
    else
  begin
       writeln('�� ������ �������� ������ �������?');
       writeln('1. ��� �����������      2. �������� �������');
       readln(Choise);
       if (Choise<>1) and (Choise<>2) then
       begin
         writeln('�� ����� �������� ��������. ���������� ��� ���');
         DeleteElement(HeadAddress);
       end;

       case Choise of
        1:     // ��� �����������
            begin
              Found:=False;
              writeln('������� ��� �����������');
              readln(NameOfWorker);

             while (CurrentElement^.Address<>nil)  and Not(Found) do
                begin
                PrevElement:=CurrentElement;
                CurrentElement:= CurrentElement^.Address;
                  if  (CurrentElement^.Work.NameOfWorker= NameOfWorker)then
                  Found:=True;
                end;

                if Found then
                begin
                 OutputElement(CurrentElement);
                 PrevElement^.Address:=CurrentElement^.Address;
                 Dispose(CurrentElement);
                 CurrentElement:=nil;
                 writeln('������� ������ ������');
                end
                  else
                  begin
                   writeln('��������� ������� ������ �� ������');
                  end;
            end;

        2:  // �������� �������
              begin
              Found:=False;
              writeln('������� �������� �������');
              readln(NameOfTheProject);

              while (CurrentElement^.Address<>nil) and Not(Found) do
                begin
                PrevElement:=CurrentElement;
                CurrentElement:= CurrentElement^.Address;
                  if  (CurrentElement^.Work.NameOfTheProject= NameOfTheProject)then
                  Found:=True;
                end;

                if Found then
                begin
                 OutputElement(CurrentElement);
                 PrevElement^.Address:=CurrentElement^.Address;
                 Dispose(CurrentElement);
                 CurrentElement:=nil;
                 writeln('������� ������ ������');
                end
                  else
                     begin
                     writeln('��������� ������� ������ �� ������');
                    end;
            end;
       end;
     end;
end;

procedure ClearMemory( HeadAddress: TAddressWorkList);         //������� ������
var   TempElement,CurrElement:  TAddressWorkList;
begin
    CurrElement:=HeadAddress;
    while CurrElement^.Address<>nil do
    begin
      TempElement:=CurrElement;
      CurrElement:=CurrElement^.Address;
      HeadAddress^.Address:= TempElement^.Address;
      Dispose(TempElement);
    end;
    Dispose(HeadAddress);
    TempElement:=nil;
    HeadAddress:=nil;
end;

function ProjectExist(HeadAddres:TAddressWorkList; SearchProject: string): boolean;     // �������� ������������� �������
var   CurrentElement: TAddressWorkList;
begin
  CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and  (CurrentElement^.Work.NameOfTheProject<> SearchProject) do
   begin
     CurrentElement:= CurrentElement^.Address;
     if  CurrentElement^.Work.NameOfTheProject=SearchProject then
     result:= True
     else
     result:= false;
   end;
end;

function WorkerExist(HeadAddres:TAddressWorkList; SearchWorker: string): boolean;  //�������� ���. ���������
var   CurrentElement: TAddressWorkList;
begin
    CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and (CurrentElement^.Work.NameOfWorker<> SearchWorker)  do
   begin
     CurrentElement:= CurrentElement^.Address;
     if CurrentElement^.Work.NameOfWorker=SearchWorker then
     result:= True
     else
     result:= false;
   end;
end;

function TaskExist(HeadAddres:TAddressWorkList; SearchTask: string): boolean;  //�������� ���. ������
var   CurrentElement: TAddressWorkList;
begin
  CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and  (CurrentElement^.Work.Task<> SearchTask) do
   begin
     CurrentElement:= CurrentElement^.Address;
     if  CurrentElement^.Work.Task=SearchTask then
     result:= True
     else
     result:= false;
   end;
end;

function DateBeforeDoExist(HeadAddres:TAddressWorkList; SearchDate: string): boolean;   //�������� ���. ���� ����� �������
var   CurrentElement: TAddressWorkList;
begin
  CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and  (CurrentElement^.Work.DateBeforeDo<> SearchDate) do
   begin
     CurrentElement:= CurrentElement^.Address;
     if  CurrentElement^.Work.DateBeforeDo=SearchDate then
     result:= True
     else
     result:= false;
   end;
end;

function StartTimeExist(HeadAddres:TAddressWorkList; SearchTime: string): boolean;      //�������� ���. ������� ������
var   CurrentElement: TAddressWorkList;
begin
  CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and  (CurrentElement^.Work.StartTime<> SearchTime) do
   begin
     CurrentElement:= CurrentElement^.Address;
     if  CurrentElement^.Work.StartTime=SearchTime then
     result:= True
     else
     result:= false;
   end;
end;

function FinishTimeExist(HeadAddres:TAddressWorkList; SearchTime: string): boolean;    //�������� ���. ������� ���������
var   CurrentElement: TAddressWorkList;
begin
  CurrentElement:=HeadAddres;
   while  (CurrentElement^.Address<>nil) and  (CurrentElement^.Work.FinishTime<> SearchTime) do
   begin
     CurrentElement:= CurrentElement^.Address;
     if  CurrentElement^.Work.FinishTime=SearchTime then
     result:= True
     else
     result:= false;
   end;
end;

procedure EditElement(HeadAddress:TAddressWorkList); //�������������� �������� ������
var Choise: integer;
    NameOfTheProject, Answer,VVodElement: string;
    CurrentElement: TAddressWorkList;
    Found: boolean;
    ExitOfEditElement: boolean;
begin
   Found:=False;
   ExitOfEditElement:=False;
   CurrentElement:=HeadAddress;
   if CurrentElement^.Address=nil then
   begin
     writeln('C����� ������, �������������� ����������. �������� ��������!');
     writeln('������� enter ��� ����������� � ������� ����');
     readln;
     clrscr;
     MainMenu;
     ExitOfEditElement:=True;
   end;

   while ExitOfEditElement=False do
   begin
     writeln('������� �������� �������, ������� ������ �������������');
     readln(NameOfTheProject);
       while (CurrentElement^.Address<>nil)  and Not(Found) do
       begin
         CurrentElement:= CurrentElement^.Address;
         if CurrentElement^.Work.NameOfTheProject=NameOfTheProject then
         Found:=True;
       end;

     if Found then
     begin

       writeln;
       writeln('�� ������ �������� ������ �������������?');
       writeln('1. ��� �����������');
       writeln('2. �������� �������');
       writeln('3. ������� � ������ ������� �������');
       writeln('4. ���� ����� �������');
       writeln('5. ����� ������ ������ ');
       writeln('6. ����� ��������� ������' );
       readln(Choise);

         if (Choise<1) or (Choise>6) then
         begin
           writeln('�� ����� �������� ��������. ���������� ��� ���!');
           ExitOfEditElement:=True;
         end;

         case choise of
           1:
               begin
                 writeln('������� ����� ��� ����������� ');
                 readln(VVodElement);
                 CurrentElement^.Work.NameOfWorker:=VVodElement;
                 writeln('��� ����������� ���� ��������.');
                 ExitOfEditElement:=True;
                 writeln;
                 end;

           2:
               begin
                writeln('������� ����� �������� �������');
                readln(VVodElement);
                if ProjectExist(HeadAddress,VVodElement) then
                writeln('����� ������ ��� ����������')
                else
                  begin
                   CurrentElement^.Work.NameOfTheProject:=VVodElement;
                   writeln('�������� ������� ���� ��������. ');
                   ExitOfEditElement:=True;
                   writeln;
                  end;
               end;

           3:
               begin
                 writeln('������� ����� ������� �������');
                 readln(VVodElement);
                 CurrentElement^.Work.Task:=VVodElement;
                 writeln('������� ������� ���� ��������.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           4:
               begin
                 writeln('������� ����� ���� ����� �������');
                 readln(VVodElement);
                 CurrentElement^.Work.DateBeforeDo:=VVodElement;
                 writeln('���� ����� ������� ���� ��������. ');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           5:
               begin
                 writeln('������� ����� ����� ������ ������');
                 readln(VVodElement);
                 CurrentElement^.Work.StartTime:=VVodElement;
                 writeln('����� ������ ������ ���� ��������.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           6:
               begin
                 writeln('������� ����� ����� ��������� ������');
                 readln(VVodElement);
                 CurrentElement^.Work.FinishTime:=VVodElement;
                 writeln('����� ��������� ������ ���� ��������.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
         end;

       end
       else
       begin
         writeln('��������� ������ �� ������. ���������� ��� ���!');
         ExitOfEditElement:=True;
         writeln;
         ExitOfEditElement:=True;
         end;

   end;
end;

procedure SwapElementsOfWorkList (FirstElement, SecondElement:TAddressWorkList);  //����� ���� ���������
var
FirstTempElement : TAddressWorkList;
SecondTempElement :TAddressWorkList;
begin

FirstTempElement := FirstElement^.Address; //1 �������
FirstElement^.Address := FirstElement^.Address^.Address; //2  �������
SecondTempElement := SecondElement^.Address;
SecondElement^.Address:= FirstTempElement;
FirstTempElement^.Address := SecondTempElement;

end;

function SearchListLength(HeadAddress:TAddressWorkList):integer;
var CurrentElement: TAddressWorkList;
    Counter: integer;
begin
    Counter:=0;
    CurrentElement:=HeadAddress;
    while CurrentElement^.Address<>nil do
    begin
      inc(Counter);
      CurrentElement:=CurrentElement^.Address;
    end;
    inc(Counter);
    result:=Counter;
end;

function CompareDates (FirstElement,SecondElement:TAddressWorkList):boolean;    //��������� ���� ���
var
FirstDate, SecondDate: string;
Temp1,Temp2:string[10];
begin

FirstDate:=FirstElement^.Work.DateBeforeDo;
Temp1:=Copy(FirstDate,7,4)+'.';
Temp1:=Temp1+Copy(FirstDate,4,2)+'.';
Temp1:=Temp1+Copy(FirstDate,1,2);

SecondDate:=SecondElement^.Work.DateBeforeDo;
Temp2:=Copy(SecondDate,7,4)+'.';
Temp2:=Temp2+Copy(SecondDate,4,2)+'.';
Temp2:=Temp2+Copy(SecondDate,1,2);

  if Temp1>Temp2 then result:=true
   else
      result:=false;
end;

procedure SortByDate(HeadAddress:TAddressWorkList);   //���������� ��������� �� ����
 var ListLength,i,j: integer;
     FirstElement, SecondElement: TAddressWorkList;
     a,b: string;
begin
   ListLength:=SearchListLength(HeadAddress);
   dec(ListLength);

  for i := 1 to ListLength-1  do
  begin
    FirstElement:=HeadAddress;
    SecondElement:=FirstElement^.Address^.Address;
    for j:=1 to ListLength-i do
    begin
       if CompareDates(FirstElement^.Address, SecondElement) then
       SwapElementsOfWorkList(FirstElement, SecondElement);
       FirstElement:=FirstElement^.Address;
       SecondElement:=SecondElement^.Address;
    end;
  end;
end;

procedure SortElements(HeadAddress:TAddressWorkList);    //���������� ���������
var CurrentElement: TAddressWorkList;
    NameOfWorker,Answer: string;
    Found:boolean;
begin
    Found := false;
    CurrentElement:=HeadAddress;
    if CurrentElement^.Address=nil then
    begin
     writeln('������ ������. �������� ��������!');
     writeln('������� enter ��� ����������� � ������� ����');
     readln;
     clrscr;
     MainMenu;
   end
       else
      begin
          writeln('������� ��� �����������');
          Readln(NameOfWorker);

          if WorkerExist(HeadAddress,NameOfWorker)=True then
          begin
          writeln('������ ���� �������, ��������������� �� ����, ������ ��� �������� ������ ������ �����������:');
          while (CurrentElement^.Address<>nil) do
            begin
               CurrentElement:=CurrentElement^.Address;
               if  CurrentElement^.Work.NameOfWorker = NameOfWorker  then
                begin
                  Found := true;
                end;
            end;

              if Found then
              begin
              SortByDate(HeadAddress);
              currentelement := Headaddress^.address;

              while CurrentElement<>nil do
                begin
                   write('����: ',currentelement^.work.datebeforedo);
                   writeln('  ������: ', currentelement^.work.task);
                  currentelement := currentelement^.address;
                end;
               end;
             writeln;
          end
            else
              begin
                writeln('����������� �� ������.');
                end;
      end;
 end;

procedure SearchByNameOfWorker(HeadAddres: TAddressWorkList;NameOfWorker:string);  //����� ���  ����������
var  CurrentElement: TAddressWorkList;
begin
    CurrentElement:=HeadAddress;
    while (CurrentElement^.Address<>nil) do
    begin
     CurrentElement:=CurrentElement^.Address;
     if CurrentElement^.Work.NameOfWorker=NameOfWorker then
     OutputElement(CurrentElement);
    end;
end;

procedure SearchByNameOfTheProject(HeadAddres: TAddressWorkList;NameOfTheProject:string);     //����� �������� �������
var  CurrentElement: TAddressWorkList;
begin
      CurrentElement:=HeadAddress;
      while CurrentElement^.Address<>nil do
      begin
        CurrentElement:=CurrentElement^.Address;
        if CurrentElement^.Work.NameOfTheProject=NameOfTheProject then
        OutputElement(CurrentElement);
      end;
end;

procedure SearchByTask (HeadAddres: TAddressWorkList;Task:string);     //����� ������
var  CurrentElement: TAddressWorkList;
 begin
     CurrentElement:=HeadAddress;
      while CurrentElement^.Address<>nil do
      begin
        CurrentElement:=CurrentElement^.Address;
        if CurrentElement^.Work.Task=Task then
        OutputElement(CurrentElement);
      end;
 end;


procedure SearchByDateBeforeDo (HeadAddres: TAddressWorkList;Date:string);       //����� ���� ����� �������
var  CurrentElement: TAddressWorkList;
 begin
    CurrentElement:=HeadAddress;
      while CurrentElement^.Address<>nil do
      begin
        CurrentElement:=CurrentElement^.Address;
        if CurrentElement^.Work.DateBeforeDo=Date then
        OutputElement(CurrentElement);
      end;
 end;

 procedure SearchByStartTime (HeadAddres: TAddressWorkList;Time:string);        //����� ������� ������  ������
var  CurrentElement: TAddressWorkList;
 begin
      CurrentElement:=HeadAddress;
      while CurrentElement^.Address<>nil do
      begin
        CurrentElement:=CurrentElement^.Address;
        if CurrentElement^.Work.StartTime=Time then
        OutputElement(CurrentElement);
      end;
 end;


procedure SearchByFinishTime (HeadAddres: TAddressWorkList;Time:string);         //����� ������� ��������� ������
var  CurrentElement: TAddressWorkList;
 begin
     CurrentElement:=HeadAddress;
      while CurrentElement^.Address<>nil do
      begin
        CurrentElement:=CurrentElement^.Address;
        if CurrentElement^.Work.FinishTime=Time then
        OutputElement(CurrentElement);
      end;
 end;

procedure SearchElements(HeadAddres: TAddressWorkList);       //����� ���������
var VVodElement: string;
    CurrentElement: TAddressWorkList;
    Choise: integer;
begin
    CurrentElement:=HeadAddress;
    if CurrentElement^.Address=nil then
   begin
     writeln('C����� ������. �������� ��������!');
     writeln('������� enter ��� ����������� � ������� ����');
     readln;
     clrscr;
     MainMenu;
   end;
    writeln;
    writeln('�� ������ �������� ������ ��������� �����?');
    writeln('1. ��� �����������');
    writeln('2. �������� �������');
    writeln('3. ������� � ������ ������� �������');
    writeln('4. ���� ����� �������');
    writeln('5. ����� ������ ������ ');
    writeln('6. ����� ��������� ������' );
    readln(Choise);
     if (Choise<1) or (Choise>6) then
     begin
           writeln('�� ����� �������� ��������. ���������� ��� ���!');
     end
     else
     begin
        case Choise of
         1:
              begin
                writeln('������� ��� ����������� ��� ������');
                readln(VVodElement);
                if WorkerExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByNameOfWorker(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;

         2:
              begin
                writeln('������� �������� ������� ��� ������');
                readln(VVodElement);
                   if ProjectExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByNameOfTheproject(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;

          3:
              begin
                writeln('������� ������� � ������ ������� ��� ������');
                readln(VVodElement);
                   if TaskExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByTask(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;

          4:
              begin
                writeln('������� ���� ����� �������  ��� ������');
                readln(VVodElement);
                   if DateBeforeDoExist(HeadAddress,VVodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByDateBeforeDo(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;

           5:
              begin
                writeln('������� ����� ������ ������ ��� ������');
                readln(VVodElement);
                   if StartTimeExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByStartTime(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;

          6:
              begin
                writeln('������� ����� ��������� ������ ��� ������');
                readln(VVodElement);
                   if FinishTimeExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('��������� ��������:');
                  writeln;
                  SearchByFinishTime(HeadAddress, VVodElement)
                end
                  else
                    writeln('������� ������ �� ������');
              end;
        end;
     end;
end;

function CompareDate(CurrentElement: TAddressWorkList; CurrentDate:TDateTime): boolean;   //��������� ���� �������� � �������
 var
    d1, d2: TDate;   //���� ��� ���������
begin
    d1 := CurrentDate; // ������� ����
    d2 := strToDate(CurrentElement^.Work.DateBeforeDo); // ���� ��� ���������
    if d1 > d2 then
    Result:=false   // ������� ���� ������
    else
    Result:=true;  //������� ���� ������
  end;

procedure WorkerTaskOverMonth(HeadAddres:TAddressWorkList);        // ������ ���������� �� ������� �����
var NameOfWorker: string;
    CurrentElement:  TAddressWorkList;
    Found: boolean;
    k: integer;
    CurrentDate: TDateTime;
    TaskFile: TextFile;
begin
   AssignFile( TaskFile, 'Task Over Month.txt');
   if not FileExists('Task Over Month.txt') then
    begin
    Rewrite(TaskFile);
    CloseFile(TaskFile);
    end;
   Append(TaskFile);

   CurrentElement:=HeadAddress;
   Found:=False;
   k:=1;
   if CurrentElement^.Address=nil then
   begin
   writeln('������ ������. �������� ��������!');
   writeln('������� enter ��� ����������� � ������� ����');
   readln;
   clrscr;
   MainMenu;
   end;

   writeln('������� ��� ����������');
   readln(NameOfWorker);
   if WorkerExist(HeadAddress,NameOfWorker)=true then
   begin
   writeln(TaskFile,'������ ���� �����, ������ ��� �������� ������ ������ ����������� �� ������� �����:');
   writeln(TaskFile,'��� ����������: ', NameOfWorker );
   end;
   writeln;

   CurrentDate:=Date();
   while (CurrentElement^.Address<>nil) do
    begin
      CurrentElement:= CurrentElement^.Address;
      if CurrentElement^.Work.NameOfWorker=NameOfWorker then
      begin
        if CompareDate(CurrentElement,CurrentDate )=True then
          begin
          writeln ( k,'. ',CurrentElement^.Work.Task);
          writeln(TaskFile,k,'. ',CurrentElement^.Work.Task);
          inc(k);
        end;
         Found:=true;
      end;
    end;
    if not(found) then
    writeln('��������� �� ������');
    writeln;
    writeln(TaskFile,' ');
    CloseFile(TaskFile);
end;

function GetPreviousMonth: TDateTime;
  var
  myDate : TDateTime;
begin
  myDate := Date();  // ������� ����
  myDate := IncMonth(myDate,-1); // ���������� �����
  result:=MyDate;
end;

function SearchMonthName(k:word): string;     // ����� �������� ������ �� ��� ������
begin
       case k of
   1:   SearchMonthName:='������';
   2:   SearchMonthName:='�������';
   3:   SearchMonthName:='����';
   4:   SearchMonthName:='������';
   5:   SearchMonthName:='���';
   6:   SearchMonthName:='����';
   7:   SearchMonthName:='����';
   8:   SearchMonthName:='������';
   9:   SearchMonthName:='��������';
   10:  SearchMonthName:='�������';
   11:  SearchMonthName:='������';
   12:  SearchMonthName:='�������';
   end;
end;

procedure SumTimeOfWork (HeadAddress:TAddressWorkList);   //������� ������� ������  �����������
var  CurrentElement:  TAddressWorkList;
     Res: string;
     TimeStart, TimeFinish: TDateTime;
     myHour, myMin, mySec, myMilli, SumInMin : Word;
     NewRes,LastMonthDate,�urrentDate : TdateTime;
     PrevYear, PrevMonth, PrevDay : Word;
     CurrYear, CurrMonth, CurrDay: Word;
     PreviousMonth, CurrentMonth: string;
     SumTimeInMonthHour: word;
     SumTimeInMonthMin: real;
     DaysInLastMonth: word;
     TaskFile: TextFile;
begin

     CurrentElement:=HeadAddress;
     if CurrentElement^.Address=nil then
     begin
     writeln('������ ������. �������� ��������!');
     writeln('������� enter ��� ����������� � ������� ����');
     readln;
     clrscr;
     MainMenu;
     end
  else
        begin
             AssignFile( TaskFile,'.\Summary Time Of Work.txt');
          if not FileExists('.\Summary Time Of Work.txt') then
           begin
           Rewrite(TaskFile);
           CloseFile(TaskFile);
           end;
           Append(TaskFile);

           writeln(TaskFile,'');
           �urrentDate:=Date(); //������� ����
           DecodeDate(�urrentDate, CurrYear, CurrMonth, CurrDay);
           CurrentMonth:=SearchMonthName(CurrMonth);
           writeln('������� �����: ', CurrentMonth);
           writeln(TaskFile,'������� �����: ', CurrentMonth);
           LastMonthDate:= GetPreviousMonth; //  ����  ����������� ������
           DecodeDate(LastMonthDate, PrevYear, PrevMonth, PrevDay);
           DaysInLastMonth:=DaysInAMonth(PrevYear,PrevMonth);
           PreviousMonth:= SearchMonthName(PrevMonth);
           writeln('���������� �����: ', PreviousMonth);
           writeln(TaskFile,'���������� �����: ', PreviousMonth);
           writeln('���� � ���������� ������: ',DaysInLastMonth);
           writeln(TaskFile,'���� � ���������� ������: ',DaysInLastMonth);
           writeln;
           writeln(TaskFile,'');
           writeln('������ �����������:');
           writeln(TaskFile,'������ �����������:');
           writeln(TaskFile,'');
           writeln;

          while  CurrentElement^.Address<> nil do
          begin
             CurrentElement:=CurrentElement^.Address;
             TimeStart:=StrToTime(CurrentElement^.Work.StartTime);
             TimeFinish:=StrToTime(CurrentElement^.Work.FinishTime);
             Res:=TimeToStr( TimeFinish- TimeStart);
             writeln('��� ����������: ',CurrentElement^.Work.NameOfWorker);
             writeln(TaskFile,'��� ����������: ',CurrentElement^.Work.NameOfWorker);
             Newres:= TimeFinish- TimeStart;
             DecodeTime(NewRes, myHour, myMin, mySec, myMilli);
             writeln('����� ������ � ����: ',MyHour,' � ',MyMin,' ���' );
             writeln(TaskFile,'����� ������ � ����: ',MyHour,' � ',MyMin,' ���' );
             SumInMin:= MyHour*60+MyMin;
             SumTimeInMonthHour:=Trunc((SumInMin*DaysInLastMonth)/60);
             SumTimeInMonthMin := (Frac ((SumInMin*DaysInLastMonth)/60))*100;
             writeln('��������� ����� ������ �� ���������� �����: ',SumTimeInMonthHour,' � ' , SumTimeInMonthMin:3:2,' ���');
             writeln(TaskFile,'��������� ����� ������ �� ���������� �����: ',SumTimeInMonthHour,' � ' , SumTimeInMonthMin:3:2,' ���');
             writeln;
             writeln(TaskFile,'');
           end;
          CloseFile(TaskFile);
        end;
end;

end.
