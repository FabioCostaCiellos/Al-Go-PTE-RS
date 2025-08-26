page 80000 ReceiveData
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ReceiveData;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the record.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the record.';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                Caption = 'Upload File';
                Image = Import;
                ToolTip = 'Import data from a file using Data Exchange Definition.';

                trigger OnAction()
                var
                    DataProcessing: Codeunit DataExProcessing;
                begin
                    DataProcessing.ImportDataExchangeFile(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}