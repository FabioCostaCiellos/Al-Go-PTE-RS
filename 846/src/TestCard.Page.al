page 80001 TestCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Test Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Field1; Field1)
                {
                    Editable = false;
                }
                field(Field2; Field2)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateNumber)
            {
                Caption = 'Generate Number';
                ToolTip = 'Generate Number';
                Image = Ranges;

                trigger OnAction()
                begin
                    Randomize();
                    Field1 := Random(1000).ToText();
                    Field2 := Random(10000).ToText();
                end;
            }
        }
    }

    var
        Field1, Field2 : Text;
}