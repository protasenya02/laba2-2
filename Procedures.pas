

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

procedure ReadFile;   //Чтение из файла
begin
   AssignFile( WorkFile, 'File Of Work.txt');
   if FileExists('File Of Work.txt') then
   Reset(WorkFile) //чтение
   else
   Rewrite(WorkFile);  //запись
end;

function SearchHead:TAddressWorkList;
var   Head, Temp: TAddressWorkList;
begin
  Reset(WorkFile); //чтение
  New(Head);
  Head^.address:=nil;
  result:= Head;  // поиск адреса первого элемента
  Temp:=Head;
  while not(Eof(WorkFile)) do
  begin
  New(Temp^.Address);
  Temp:=Temp^.Address;
  Read(WorkFile,Temp^.Work);
  Temp^.Address:=nil;
  end;
end;

procedure SaveFile( HeadAddress:TAddressWorkList);   //сохранение файла
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
         writeln('Изменения были сохранены');
         ClearMemory(HeadAddress);
      end;
end;

procedure OutputElement(CurrentElement:TAddressWorkList);    //вывод 1 элемента
begin
    with  CurrentElement^.Work do
          begin
               write('ФИО исполнителя: ');
               writeln (NameOfWorker);
               write('Название проекта: ');
               writeln(NameOfTheProject);
               write('Задание в рамках данного проекта: ');
               writeln( Task);
               write('Дата сдачи задания: ');
               writeln(DateBeforeDo);
               write('Время начала работы: ');
               writeln(StartTime);
               write('Время окончания работы: ' );
               writeln(FinishTime);
               writeln;
          end;
end;

procedure AddElements( HeadAddress: TAddressWorkList); //добавление элементов в список
var CurrentAddress: TAddressWorkList;
    NumberOfElements,i: integer;
begin
  CurrentAddress :=HeadAddress;
  while (CurrentAddress^.Address<>nil) do
  CurrentAddress:= CurrentAddress^.address;
  writeln('Введите количество элементов, которые вы хотите добавить:');
  readln(NumberOfElements );
      for i := 1 to NumberOfElements do
      begin
       writeln;
       New(CurrentAddress^.Address);
       CurrentAddress:=CurrentAddress^.Address;
         with  CurrentAddress^.Work do
            begin
         write('ФИО исполнителя: ');
         readln (NameOfWorker);
         write('Название проекта: ');
         readln(NameOfTheProject);
         write('Задание в рамках данного проекта: ');
         readln( Task);
         write('Дата сдачи задания: ');
         readln(DateBeforeDo);
         write('Время начала работы: ');
         readln(StartTime);
         write('Время окончания работы: ' );
         readln(FinishTime);
         writeln;
        end;
        CurrentAddress^.address:=nil;
      end;
      writeln;
      if NumberOfElements=1 then
      writeln('Элемент добавлен.')
      else
      writeln ('Элементы добавлены.');
end;

procedure WatchTheList(HeadAddress:TAddressWorkList);  // просмотр всего списка
var CurrentAddress: TAddressWorkList;
begin
  CurrentAddress:=HeadAddress;
 if   CurrentAddress^.Address=nil then
  writeln('Список пустой. Добавьте элементы!')
   else
     begin
        writeln('Весь список работ:');
        writeln;
       while CurrentAddress^.Address<>nil do
         begin
            with CurrentAddress^.Address^.Work do
            begin
             write('ФИО исполнителя: ');
             writeln (NameOfWorker);
             write('Название проекта: ');
             writeln(NameOfTheProject);
             write('Задание в рамках данного проекта: ');
             writeln( Task);
             write('Дата сдачи задания: ');
             writeln(DateBeforeDo);
             write('Время начала работы: ');
             writeln(StartTime);
             write('Время окончания работы: ' );
             writeln(FinishTime);
             writeln;
            end;
          CurrentAddress:=CurrentAddress^.Address;
         end;

   end;
end;

procedure clrscr;  // очистка консоли
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

function PrintMenuTasks:string;        //вывод пунктов меню
begin
    writeln('Выберите пункт меню: ');
    writeln;
    writeln('1. Чтение данных из файла');
    writeln('2. Просмотр всего списка ');
    writeln('3. Сортировка списка  по дате для сотрудника ');
    writeln('4. Поиск данных с использованием фильтров');
    writeln('5. Добавление данных в список ');
    writeln('6. Удаление данных из списка ');
    writeln('7. Редактирование данных ');
    writeln('8. Cписок сотрудников с указанием суммарного времени их работы за прошедший месяц ');
    writeln('9. Список всех задач, работа над которыми велась одним сотрудником за текущие сутки');
    writeln('10. Выход из программы без сохранения изменений');
    writeln('11. Выход с сохранением изменений');
    writeln;
end;

procedure MainMenu;           //меню
var Choise: integer;

begin
    PrintMenuTasks;
    readln(Choise);

    if (Choise>11) or (Choise<1)  then
    begin
    writeln('Вы ввели неверное значение. Попробуйте еще раз!');
    writeln;
    MainMenu;
    end;


    case  Choise of
     1:
             begin
              ReadFile;
              writeln('Файл прочитан');
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;

     2:
              begin
              WatchTheList(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;

      3:
              begin
              SortElements(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;

      4:
              begin
              SearchElements(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;


     5:
              begin
              AddElements(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;

     6:
              begin
              DeleteElement(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;

     7:
             begin
              EditElement(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
             end;
     8:
            begin
              SumTimeOfWork (HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
            end;

     9:
            begin
              WorkerTaskOverMonth(HeadAddress);
              writeln('Нажмите enter для возвращения в главное меню');
              readln;
              clrscr;
              MainMenu;
            end;


     10:  ClearMemory(HeadAddress);

     11:   SaveFile(HeadAddress);

  end;
end;

Procedure DeleteElement(HeadAddress:TAddressWorkList);  //удаление элемента списка
var CurrentElement, PrevElement: TAddressWorkList;
    Choise: integer;
    Found: boolean;
    NameOfWorker, NameOfTheProject,Answer: string;
begin
   CurrentElement:=HeadAddress;
   if CurrentElement^.Address=nil then
   begin
   writeln('Список пустой. Добавьте элементы!');
   writeln('Нажмите enter для возвращения в главное меню');
   readln;
   clrscr;
   MainMenu;
   end
    else
  begin
       writeln('По какому критерию хотите удалить?');
       writeln('1. ФИО исполнителя      2. Название проекта');
       readln(Choise);
       if (Choise<>1) and (Choise<>2) then
       begin
         writeln('Вы ввели неверное значение. Попробуйте еще раз');
         DeleteElement(HeadAddress);
       end;

       case Choise of
        1:     // ФИО исполнителя
            begin
              Found:=False;
              writeln('Введите ФИО исполнителя');
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
                 writeln('Элемент списка удален');
                end
                  else
                  begin
                   writeln('Введенный элемент списка не найден');
                  end;
            end;

        2:  // название проекта
              begin
              Found:=False;
              writeln('Введите название проекта');
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
                 writeln('Элемент списка удален');
                end
                  else
                     begin
                     writeln('Введенный элемент списка не найден');
                    end;
            end;
       end;
     end;
end;

procedure ClearMemory( HeadAddress: TAddressWorkList);         //очистка памяти
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

function ProjectExist(HeadAddres:TAddressWorkList; SearchProject: string): boolean;     // проверка существования проекта
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

function WorkerExist(HeadAddres:TAddressWorkList; SearchWorker: string): boolean;  //проверка сущ. работника
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

function TaskExist(HeadAddres:TAddressWorkList; SearchTask: string): boolean;  //проверка сущ. задачи
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

function DateBeforeDoExist(HeadAddres:TAddressWorkList; SearchDate: string): boolean;   //проверка сущ. даты сдачи проекта
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

function StartTimeExist(HeadAddres:TAddressWorkList; SearchTime: string): boolean;      //проверка сущ. времени начала
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

function FinishTimeExist(HeadAddres:TAddressWorkList; SearchTime: string): boolean;    //проверка сущ. времени окончания
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

procedure EditElement(HeadAddress:TAddressWorkList); //Редактирование элемента списка
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
     writeln('Cписок пустой, редактирование невозможно. Добавьте элементы!');
     writeln('Нажмите enter для возвращения в главное меню');
     readln;
     clrscr;
     MainMenu;
     ExitOfEditElement:=True;
   end;

   while ExitOfEditElement=False do
   begin
     writeln('Введите название проекта, который хотите редактировать');
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
       writeln('По какому критерию хотите редактировать?');
       writeln('1. ФИО исполнителя');
       writeln('2. Название проекта');
       writeln('3. Задание в рамках данного проекта');
       writeln('4. Дата сдачи задания');
       writeln('5. Время начала работы ');
       writeln('6. Время окончания работы' );
       readln(Choise);

         if (Choise<1) or (Choise>6) then
         begin
           writeln('Вы ввели неверное значение. Попробуйте еще раз!');
           ExitOfEditElement:=True;
         end;

         case choise of
           1:
               begin
                 writeln('Введите новое ФИО исполнителя ');
                 readln(VVodElement);
                 CurrentElement^.Work.NameOfWorker:=VVodElement;
                 writeln('ФИО исполнителя было изменено.');
                 ExitOfEditElement:=True;
                 writeln;
                 end;

           2:
               begin
                writeln('Введите новое название проекта');
                readln(VVodElement);
                if ProjectExist(HeadAddress,VVodElement) then
                writeln('Такой проект уже существует')
                else
                  begin
                   CurrentElement^.Work.NameOfTheProject:=VVodElement;
                   writeln('Название проекта было изменено. ');
                   ExitOfEditElement:=True;
                   writeln;
                  end;
               end;

           3:
               begin
                 writeln('Введите новое задание проекта');
                 readln(VVodElement);
                 CurrentElement^.Work.Task:=VVodElement;
                 writeln('Задание проекта было изменено.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           4:
               begin
                 writeln('Введите новую дату сдачи задания');
                 readln(VVodElement);
                 CurrentElement^.Work.DateBeforeDo:=VVodElement;
                 writeln('Дата сдачи задания была изменена. ');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           5:
               begin
                 writeln('Введите новое время начала работы');
                 readln(VVodElement);
                 CurrentElement^.Work.StartTime:=VVodElement;
                 writeln('Время начала работы было изменено.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
           6:
               begin
                 writeln('Введите новое время окончания работы');
                 readln(VVodElement);
                 CurrentElement^.Work.FinishTime:=VVodElement;
                 writeln('Время окончания работы было изменено.');
                 ExitOfEditElement:=True;
                 writeln;
               end;
         end;

       end
       else
       begin
         writeln('Введенный проект не найден. Попробуйте еще раз!');
         ExitOfEditElement:=True;
         writeln;
         ExitOfEditElement:=True;
         end;

   end;
end;

procedure SwapElementsOfWorkList (FirstElement, SecondElement:TAddressWorkList);  //обмен двух элементов
var
FirstTempElement : TAddressWorkList;
SecondTempElement :TAddressWorkList;
begin

FirstTempElement := FirstElement^.Address; //1 элемент
FirstElement^.Address := FirstElement^.Address^.Address; //2  элемент
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

function CompareDates (FirstElement,SecondElement:TAddressWorkList):boolean;    //сравнение двух дат
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

procedure SortByDate(HeadAddress:TAddressWorkList);   //сортировка элементов по дате
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

procedure SortElements(HeadAddress:TAddressWorkList);    //сортировка элементов
var CurrentElement: TAddressWorkList;
    NameOfWorker,Answer: string;
    Found:boolean;
begin
    Found := false;
    CurrentElement:=HeadAddress;
    if CurrentElement^.Address=nil then
    begin
     writeln('Список пустой. Добавьте элементы!');
     writeln('Нажмите enter для возвращения в главное меню');
     readln;
     clrscr;
     MainMenu;
   end
       else
      begin
          writeln('Введите ФИО исполнителя');
          Readln(NameOfWorker);

          if WorkerExist(HeadAddress,NameOfWorker)=True then
          begin
          writeln('Список всех заданий, отсортированных по дате, работа над которыми велась данным сотрудником:');
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
                   write('Дата: ',currentelement^.work.datebeforedo);
                   writeln('  Задача: ', currentelement^.work.task);
                  currentelement := currentelement^.address;
                end;
               end;
             writeln;
          end
            else
              begin
                writeln('Исполнитель не найден.');
                end;
      end;
 end;

procedure SearchByNameOfWorker(HeadAddres: TAddressWorkList;NameOfWorker:string);  //поиск ФИО  сотрудника
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

procedure SearchByNameOfTheProject(HeadAddres: TAddressWorkList;NameOfTheProject:string);     //поиск названия проекта
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

procedure SearchByTask (HeadAddres: TAddressWorkList;Task:string);     //поиск задачи
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


procedure SearchByDateBeforeDo (HeadAddres: TAddressWorkList;Date:string);       //поиск даны сдачи проекта
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

 procedure SearchByStartTime (HeadAddres: TAddressWorkList;Time:string);        //поиск времени начала  работы
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


procedure SearchByFinishTime (HeadAddres: TAddressWorkList;Time:string);         //поиск времени окончания работы
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

procedure SearchElements(HeadAddres: TAddressWorkList);       //поиск элементов
var VVodElement: string;
    CurrentElement: TAddressWorkList;
    Choise: integer;
begin
    CurrentElement:=HeadAddress;
    if CurrentElement^.Address=nil then
   begin
     writeln('Cписок пустой. Добавьте элементы!');
     writeln('Нажмите enter для возвращения в главное меню');
     readln;
     clrscr;
     MainMenu;
   end;
    writeln;
    writeln('По какому критерию хотите проводить поиск?');
    writeln('1. ФИО исполнителя');
    writeln('2. Название проекта');
    writeln('3. Задание в рамках данного проекта');
    writeln('4. Дата сдачи задания');
    writeln('5. Время начала работы ');
    writeln('6. Время окончания работы' );
    readln(Choise);
     if (Choise<1) or (Choise>6) then
     begin
           writeln('Вы ввели неверное значение. Попробуйте еще раз!');
     end
     else
     begin
        case Choise of
         1:
              begin
                writeln('Введите ФИО исполнителя для поиска');
                readln(VVodElement);
                if WorkerExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByNameOfWorker(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;

         2:
              begin
                writeln('Введите название проекта для поиска');
                readln(VVodElement);
                   if ProjectExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByNameOfTheproject(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;

          3:
              begin
                writeln('Введите задание в рамках проекта для поиска');
                readln(VVodElement);
                   if TaskExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByTask(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;

          4:
              begin
                writeln('Введите дату сдачи задания  для поиска');
                readln(VVodElement);
                   if DateBeforeDoExist(HeadAddress,VVodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByDateBeforeDo(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;

           5:
              begin
                writeln('Введите время начала работы для поиска');
                readln(VVodElement);
                   if StartTimeExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByStartTime(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;

          6:
              begin
                writeln('Введите время окончания работы для поиска');
                readln(VVodElement);
                   if FinishTimeExist(HeadAddress,VvodElement)=True then
                begin
                  writeln('Найденные элементы:');
                  writeln;
                  SearchByFinishTime(HeadAddress, VVodElement)
                end
                  else
                    writeln('Элемент списка не найден');
              end;
        end;
     end;
end;

function CompareDate(CurrentElement: TAddressWorkList; CurrentDate:TDateTime): boolean;   //сравнение даты элемента с текущей
 var
    d1, d2: TDate;   //даты для сравнения
begin
    d1 := CurrentDate; // текущая дата
    d2 := strToDate(CurrentElement^.Work.DateBeforeDo); // дата для сравнения
    if d1 > d2 then
    Result:=false   // Текущая дата больше
    else
    Result:=true;  //Текущая дата меньше
  end;

procedure WorkerTaskOverMonth(HeadAddres:TAddressWorkList);        // задачи сотрудника за текущие сутки
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
   writeln('Список пустой. Добавьте элементы!');
   writeln('Нажмите enter для возвращения в главное меню');
   readln;
   clrscr;
   MainMenu;
   end;

   writeln('Введите ФИО сотрудника');
   readln(NameOfWorker);
   if WorkerExist(HeadAddress,NameOfWorker)=true then
   begin
   writeln(TaskFile,'Список всех задач, работа над которыми велась данным сотрудником за текущие сутки:');
   writeln(TaskFile,'ФИО сотрудника: ', NameOfWorker );
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
    writeln('Сотрудник не найден');
    writeln;
    writeln(TaskFile,' ');
    CloseFile(TaskFile);
end;

function GetPreviousMonth: TDateTime;
  var
  myDate : TDateTime;
begin
  myDate := Date();  // Текущая дата
  myDate := IncMonth(myDate,-1); // Предыдущий месяц
  result:=MyDate;
end;

function SearchMonthName(k:word): string;     // поиск названия месяца по его номеру
begin
       case k of
   1:   SearchMonthName:='январь';
   2:   SearchMonthName:='февраль';
   3:   SearchMonthName:='март';
   4:   SearchMonthName:='апрель';
   5:   SearchMonthName:='май';
   6:   SearchMonthName:='июнь';
   7:   SearchMonthName:='июль';
   8:   SearchMonthName:='август';
   9:   SearchMonthName:='сентябрь';
   10:  SearchMonthName:='октябрь';
   11:  SearchMonthName:='ноябрь';
   12:  SearchMonthName:='декабрь';
   end;
end;

procedure SumTimeOfWork (HeadAddress:TAddressWorkList);   //подсчет времени работы  сотрудников
var  CurrentElement:  TAddressWorkList;
     Res: string;
     TimeStart, TimeFinish: TDateTime;
     myHour, myMin, mySec, myMilli, SumInMin : Word;
     NewRes,LastMonthDate,СurrentDate : TdateTime;
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
     writeln('Список пустой. Добавьте элементы!');
     writeln('Нажмите enter для возвращения в главное меню');
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
           СurrentDate:=Date(); //текущая дата
           DecodeDate(СurrentDate, CurrYear, CurrMonth, CurrDay);
           CurrentMonth:=SearchMonthName(CurrMonth);
           writeln('Текущий месяц: ', CurrentMonth);
           writeln(TaskFile,'Текущий месяц: ', CurrentMonth);
           LastMonthDate:= GetPreviousMonth; //  дата  предыдущего месяца
           DecodeDate(LastMonthDate, PrevYear, PrevMonth, PrevDay);
           DaysInLastMonth:=DaysInAMonth(PrevYear,PrevMonth);
           PreviousMonth:= SearchMonthName(PrevMonth);
           writeln('Предыдущий месяц: ', PreviousMonth);
           writeln(TaskFile,'Предыдущий месяц: ', PreviousMonth);
           writeln('Дней в предыдущем месяце: ',DaysInLastMonth);
           writeln(TaskFile,'Дней в предыдущем месяце: ',DaysInLastMonth);
           writeln;
           writeln(TaskFile,'');
           writeln('Список сотрудников:');
           writeln(TaskFile,'Список сотрудников:');
           writeln(TaskFile,'');
           writeln;

          while  CurrentElement^.Address<> nil do
          begin
             CurrentElement:=CurrentElement^.Address;
             TimeStart:=StrToTime(CurrentElement^.Work.StartTime);
             TimeFinish:=StrToTime(CurrentElement^.Work.FinishTime);
             Res:=TimeToStr( TimeFinish- TimeStart);
             writeln('ФИО сотрудника: ',CurrentElement^.Work.NameOfWorker);
             writeln(TaskFile,'ФИО сотрудника: ',CurrentElement^.Work.NameOfWorker);
             Newres:= TimeFinish- TimeStart;
             DecodeTime(NewRes, myHour, myMin, mySec, myMilli);
             writeln('Время работы в день: ',MyHour,' ч ',MyMin,' мин' );
             writeln(TaskFile,'Время работы в день: ',MyHour,' ч ',MyMin,' мин' );
             SumInMin:= MyHour*60+MyMin;
             SumTimeInMonthHour:=Trunc((SumInMin*DaysInLastMonth)/60);
             SumTimeInMonthMin := (Frac ((SumInMin*DaysInLastMonth)/60))*100;
             writeln('Суммарное время работы за прошедшиий месяц: ',SumTimeInMonthHour,' ч ' , SumTimeInMonthMin:3:2,' мин');
             writeln(TaskFile,'Суммарное время работы за прошедшиий месяц: ',SumTimeInMonthHour,' ч ' , SumTimeInMonthMin:3:2,' мин');
             writeln;
             writeln(TaskFile,'');
           end;
          CloseFile(TaskFile);
        end;
end;

end.
