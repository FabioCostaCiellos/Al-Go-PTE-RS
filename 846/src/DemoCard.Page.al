page 80001 DemoCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Demo Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Field1; Random1000)
                {
                    Editable = false;
                }
                field(Field2; Random10000)
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
                    Random1000 := Random(1000).ToText();
                    Random10000 := Random(10000).ToText();
                end;
            }
        }
    }

    var
        Random1000, Random10000 : Text;
}