codeunit 80000 DataExProcessing
{
    TableNo = ReceiveData;
    trigger OnRun()
    begin
        ImportDataExchangeFile(Rec);
    end;

    procedure ImportDataExchangeFile(var ReceiveDataRec: Record ReceiveData)
    var
        TempBlob: Codeunit "Temp Blob";
        DataExchDef: Record "Data Exch. Def";
        DataExchField: Record "Data Exch. Field";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExch: Record "Data Exch.";
        DataExchEntryNo: Integer;
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
    begin
        // Check if Data Exchange Definition exists
        if not DataExchDef.Get('TEST2608') then
            Error('Data Exchange Definition TEST2608 not found.');

        // Prompt user to select a file
        if UploadIntoStream('Select file to import', '', '', FileName, InStream) then begin
            // Store the file in TempBlob
            TempBlob.CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            TempBlob.CreateInStream(InStream);

            // Create Data Exchange record
            DataExch.Init();
            if DataExch.FindLast() then
                DataExchEntryNo := DataExch."Entry No." + 1
            else
                DataExchEntryNo := 1;

            DataExch."Entry No." := DataExchEntryNo;
            DataExch."Data Exch. Def Code" := 'TEST2608';
            DataExch."File Name" := FileName;
            DataExch.Insert(true);

            // Process the file according to the Data Exchange Definition
            ProcessImportedFile(DataExch."Entry No.", ReceiveDataRec);
        end;
    end;

    local procedure ProcessImportedFile(DataExchEntryNo: Integer; var ReceiveDataRec: Record ReceiveData)
    var
        DataExch: Record "Data Exch.";
        DataExchField: Record "Data Exch. Field";
        DataExchColumnDef: Record "Data Exch. Column Def";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        ReceiveDataRecord: Record ReceiveData;
        FieldRef: FieldRef;
        RecRef: RecordRef;
        LineNo: Integer;
        IDValue: Integer;
        NameValue: Text[250];
    begin
        // Read the imported data exchange
        DataExch.Get(DataExchEntryNo);

        // Get the field data from the Data Exchange
        DataExchField.SetRange("Data Exch. No.", DataExchEntryNo);

        if DataExchField.FindSet() then
            repeat
                // Process each line in the file
                if LineNo <> DataExchField."Line No." then begin
                    if LineNo <> 0 then begin
                        // Insert a new record for each line
                        ReceiveDataRecord.Init();
                        ReceiveDataRecord.ID := IDValue;
                        ReceiveDataRecord.Name := NameValue;
                        ReceiveDataRecord.Insert(true);
                    end;

                    LineNo := DataExchField."Line No.";
                end;

                // Map the fields based on the column definition
                DataExchColumnDef.SetRange("Data Exch. Def Code", DataExch."Data Exch. Def Code");
                DataExchColumnDef.SetRange("Column No.", DataExchField."Column No.");
                if DataExchColumnDef.FindFirst() then begin
                    case DataExchColumnDef.Name of
                        'ID':
                            Evaluate(IDValue, DataExchField.Value);
                        'Name':
                            NameValue := CopyStr(DataExchField.Value, 1, 250);
                    end;
                end;
            until DataExchField.Next() = 0;

        // Insert the last record if exists
        if LineNo <> 0 then begin
            ReceiveDataRecord.Init();
            ReceiveDataRecord.ID := IDValue;
            ReceiveDataRecord.Name := NameValue;
            ReceiveDataRecord.Insert(true);
        end;

        // Return the last inserted record
        ReceiveDataRec := ReceiveDataRecord;
    end;

}