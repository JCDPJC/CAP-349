using {LogaliGroup as service} from '../service';

annotate service.Options with {
    code @title : 'Options' @Common: {
        Text : name,
        TextArrangement : #TextOnly
    }
};

annotate service.Dialog with {
    option @title: 'Option' @mandatory;
    amount @title : 'Amount' @mandatory;
};

annotate service.Dialog with {
   
    option @Common: {
        // ValueListWithFixedValues,
        ValueList : {
            $Type : 'Common.ValueListType',  //Combobox
            CollectionPath : 'Options',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : option,
                    ValueListProperty : 'code',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                }
            ]
        },

    }
};