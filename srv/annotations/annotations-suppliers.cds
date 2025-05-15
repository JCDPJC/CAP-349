using {LogaliGroup as service} from '../service';

using from './annotations-contacts';

annotate service.Suppliers with { //Field Labels with @title
    ID           @title : 'Supplier'
                 @Common: {
        Text           : supplierName,
        TextArrangement: #TextOnly
    };

    supplier     @title : 'Supplier';
    supplierName @title : 'Supplier Name';
    webAddress   @title : 'Web Address';
};


annotate service.Suppliers with @(UI.FieldGroup #Supplier: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Value: supplier
        },
        {
            $Type: 'UI.DataField',
            Value: supplierName
        },
        {
            $Type: 'UI.DataField',
            Value: webAddress
        }
    ]
}

);
