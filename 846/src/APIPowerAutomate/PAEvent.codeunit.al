codeunit 80001 PAEvent
{

    TableNo = Customer;
    trigger OnRun()
    var
        Cust: Record Customer;
        Page: Page PowerAutomate;
    begin
        Page.GetRecord(Cust);
        Message(Cust."No.");
    end;

    // [EventSubscriber(ObjectType::Page, Page::PowerAutomate, SyncCustomer, '', false, false)]
    // local procedure SyncCustomer(var Customer: Record Customer)
    // begin
    //     Message('SyncCustomer trigger');
    // end;
}