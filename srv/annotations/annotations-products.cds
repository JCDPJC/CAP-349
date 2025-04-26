using {LogaliGroup as service} from '../service';

annotate service.Products with {                        //Field Labels with @title
    product     @title        : 'Product';
    productName @title        : 'Product Name';
    category    @title        : 'Category';
    subCategory @title        : 'SubCategory';
    statu       @title        : 'Statu';
    rating      @title        : 'Rating';
    price       @title        : 'Price'  @Measures.ISOCurrency: currency;  // Need a currency field
    currency    @Common.IsCurrency: true;   // Is a currency del vocabulario @Common
};

annotate service.Products with @(
    UI.LineItem: [     //Annotation Line Item
        {
            $Type: 'UI.DataField',  //Fielld Type
            Value: product           // Field Name for the annotation
        },
        {
            $Type: 'UI.DataField',
            Value: productName
        },
        {
            $Type: 'UI.DataField',
            Value: category_ID
        },
        {
            $Type: 'UI.DataField',
            Value: subCategory_ID
        },
        {
            $Type: 'UI.DataField',
            Value: statu_code
        },
        {
            $Type : 'UI.DataFieldForAnnotation',   //The field affected will be set in Target - Call annotation inside a Table
            Target : '@UI.DataPoint#Variant1',     //DataPoint - with qualifier #variant1
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'     // Define width
            }
        },
        {
            $Type: 'UI.DataField',
            Value: price
        }
    ],
    UI.DataPoint #Variant1: {           //DataPoint - with qualifier #variant1
        $Type : 'UI.DataPointType',
        Visualization : #Rating,   // Is a rating
        Value : rating            // Field Name for the annotation
    }
);
