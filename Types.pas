unit Types;


interface
uses   System.SysUtils;

  //информационное поле
type

  Twork = record
    NameOfWorker:     string[30];
    NameOfTheProject: string[20];
    Task:             string[50];
    DateBeforeDo:     string[20];
    StartTime:        string[20];
    FinishTime:       string[20];

  end;

  TAddressWorkList= ^TworkList;  //адрес

  TWorkList= record     // элемент списка
       Work: Twork;
       Address: TAddressWorkList;

  end;


  TFile = file of Twork;    // типизированный файл


var
  WorkFile: TFile;
  HeadAddress: TAddressWorkList;


implementation

end.
