using {LogaliGroup as service} from '../service';
using from './annotations-suppliers';
using from './annotations-productdetails.cds';
using from './annotations-reviews';
using from './annotations-inventories';
using from './annotations-sales';

// Draft enabled
annotate service.Products with @odata.draft.enabled;

annotate service.Products with { //Field Labels with @title
    product     @title            : 'Product';
    productName @title            : 'Product Name';
    category    @title            : 'Category';
    subCategory @title            : 'SubCategory';
    supplier    @title            : 'Supplier';
    statu       @title            : 'Status';
    rating      @title            : 'Rating';
    price       @title            : 'Price'  @Measures.ISOCurrency: currency_code; // Need a currency field
    currency    @Common.IsCurrency: true; // Is a currency del vocabulario @Common
    image       @title            : 'Image';
};

annotate service.Products with {
    statu       @Common: { //Status text instead code
        Text           : statu.name, // Use association
        TextArrangement: #TextOnly
    };

    category    @Common: {
        Text           : category.category,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Categories',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: category_ID,
                ValueListProperty: 'ID'
            }]
        },
    };

    subCategory @Common: {
        Text           : subCategory.subCategory,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_SubCategories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: category_ID,
                    ValueListProperty: 'category_ID',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: subCategory_ID,
                    ValueListProperty: 'ID'
                }
            ]
        }
    };

    supplier    @Common: {
        Text           : supplier.supplierName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: supplier_ID,
                ValueListProperty: 'ID'
            }]
        }
    };

    statu       @Common: {ValueListWithFixedValues}
};

annotate service.Products with @(

// Side effect
    Common.SideEffects: {
        $Type : 'Common.SideEffectsType',
        SourceProperties : [
            supplier_ID    //field as source, the navigation field
        ],
        TargetEntities : [
            supplier      //Target entity
        ],
    },

// Restriction in a filteer
    Capabilities.FilterRestrictions: {
        $Type : 'Capabilities.FilterRestrictionsType',
        FilterExpressionRestrictions : [
            {
                $Type : 'Capabilities.FilterExpressionRestrictionType',
                Property : product,
                AllowedExpressions : 'SearchExpression'
            }
        ]
    },

    UI.HeaderInfo                    : { //Header Info
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : {
            $Type: 'UI.DataField',
            Value: productName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product
        }
    },
    // Filtros
    UI.SelectionFields               : [
        product,
        supplier_ID,
        category_ID,
        subCategory_ID,
        statu_code
    ],

    UI.LineItem                      : [ //Annotation Line Item
        {
            $Type                : 'UI.DataField',
            Value                : image, //The image
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type: 'UI.DataField', //Fielld Type
            Value: product // Field Name for the annotation
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
            $Type                : 'UI.DataField',
            Value                : statu_code,
            Criticality          : statu.criticality, //Origin of Criticality
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type                : 'UI.DataFieldForAnnotation', //The field affected will be set in Target - Call annotation inside a Table
            Target               : '@UI.DataPoint#Variant1', //DataPoint - with qualifier #variant1
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem' // Define width
            }
        },
        {
            $Type: 'UI.DataField',
            Value: price
        }
    ],

    UI.DataPoint #Variant1           : { //DataPoint - with qualifier #variant1
        $Type        : 'UI.DataPointType',
        Visualization: #Rating, // Is a rating
        Value        : rating // Field Name for the annotation
    },

    UI.FieldGroup #Image             : { //For the image
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: image,
            Label: ''
        }],
    },

    // Fieldgroup for Header Facets
    UI.FieldGroup #HeaderA           : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: supplier_ID
            },
            {
                $Type: 'UI.DataField',
                Value: category_ID
            },
            {
                $Type: 'UI.DataField',
                Value: subCategory_ID
            }
        ]
    },
    UI.FieldGroup #ProductDescription: {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: description
     //       ![@Common.FieldControl] : 
        }]
    },
    UI.FieldGroup #Statu             : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type      : 'UI.DataField',
            Value      : statu_code,
            Criticality: statu.criticality,
            Label      : '',
            ![@Common.FieldControl] : {
                    $edmJson: {
                        $If: [     //Expresión dinámica
                            {
                                $Eq: [
                                    {
                                        $Path: 'IsActiveEntity'
                                    },
                                    false
                                ]
                            },
                            1,  //ReadOnly
                            3   //Optional
                        ]
                    }
                },
        }]
    },
    UI.FieldGroup #Price             : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: price,
            Label: '' // Remove label
        }]
    },

    // Header Facets
    UI.HeaderFacets                  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Image',
            ID    : 'Image'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#HeaderA',
            ID    : 'HeaderA',
            Label : '  '
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#ProductDescription',
            ID    : 'ProductDescription',
            Label : 'Product Description'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Statu',
            ID    : 'ProductStatu',
            Label : 'Availability'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Price',
            ID    : 'Price',
            Label : 'Price'
        }
    ],

    // Facet detail with FacetCollections
    UI.Facets                        : [
        {
            $Type : 'UI.CollectionFacet',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: 'supplier/@UI.FieldGroup#Supplier',
                    Label : 'Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: 'supplier/contact/@UI.FieldGroup#Contact', // Navigation using supplier first
                    Label : 'Contact Person'
                }
            ],
            Label : 'Supplier Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'detail/@UI.FieldGroup',
            Label : 'Product Information',
            ID    : 'ProductInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID    : 'toReviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toInventories/@UI.LineItem',
            Label : 'Inventory Information',
            ID    : 'toInventories'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toSales/@UI.Chart',
            Label : 'Sales',
            ID    : 'toSales'
        }
    ]

);
