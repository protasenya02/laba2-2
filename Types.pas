unit Types;


interface
uses   System.SysUtils;

  //�������������� ����
type

  Twork = record
    NameOfWorker:     string[30];
    NameOfTheProject: string[20];
    Task:             string[50];
    DateBeforeDo:     string[20];
    StartTime:        string[20];
    FinishTime:       string[20];

  end;

  TAddressWorkList= ^TworkList;  //�����

  TWorkList= record     // ������� ������
       Work: Twork;
       Address: TAddressWorkList;

  end;


  TFile = file of Twork;    // �������������� ����


var
  WorkFile: TFile;
  HeadAddress: TAddressWorkList;


implementation

end.
