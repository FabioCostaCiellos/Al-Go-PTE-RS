pageextension 80001 CustomerExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }
    
    actions
    {
        addfirst(History){
            action(SyncCust)
            {
                Caption = 'SyncCust';
                ToolTip = 'SyncCust';
                Image = Customer;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PAEvent: Codeunit PAEvent;
                begin
                    PAEvent.Run(Rec);
                end;
            }
        }
    }
    
  
}