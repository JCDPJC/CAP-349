using {LogaliGroup as service} from '../service';

annotate service.Inventories with {
    stockNumber @title: 'Stock Number' @Common.FieldControl: #ReadOnly;
    department  @title: 'Department';
    min         @title: 'Minimun';
    max         @title: 'Maximun';
    target      @title: 'Target';
    quantity    @title: 'Quantity' @Measures.Unit : baseUnit @Common.FieldControl: #ReadOnly;  //link Unit
    baseUnit    @title: 'Base Unit' @Common.IsUnit @Common.FieldControl: #ReadOnly;    //Define as Unit
};    //text in labels

annotate service.Inventories with {
    department @Common: {                //to only see the text instead of the key
        Text : department.department,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Departments',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : department_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    }
};


annotate service.Inventories with @(
    Common.SemanticKey: [    //Flag field as key in bold
        stockNumber
    ],

// Header in Object-PAge
    UI.HeaderInfo         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Inventory',
        TypeNamePlural: 'Inventories',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.productName   //from association in Inventories
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product.product   //from association in Inventories
        }
    },

// Line Item    
    UI.LineItem  : [
        {
            $Type : 'UI.DataField',
            Value : stockNumber
        },
        {
            $Type : 'UI.DataField',
            Value : department_ID
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#Bullet',   //to show the Chart in the lineitem
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            },
        },
        {
            $Type : 'UI.DataField',
            Value : quantity
        },
        // {
        //     $Type : 'UI.DataFieldForAction',
        //     Action : 'LogaliGroup.setStock',
        //     Label : 'Set Stock',
        //     Inline : true,
        // },
    ],
    UI.DataPoint  : {
        $Type : 'UI.DataPointType',
        Value : target,        //field from the entity
        MinimumValue : min,    //field from the entity
        MaximumValue : max,    //field from the entity
        CriticalityCalculation : {
            $Type : 'UI.CriticalityCalculationType',
            ImprovementDirection : #Maximize,  //direction of the Trend-Criticality Calculation
            ToleranceRangeLowValue : 200,
            DeviationRangeLowValue : 100
        },
    },
    UI.Chart #Bullet : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bullet,    //Graphic type
        Measures : [                    // Measures = Es igual a la parte numerica
            target   //field from the entity
        ],
        MeasureAttributes: [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DataPoint : '@UI.DataPoint',
                Measure : target  //field from the entity
            }
        ]
    },
    UI.FieldGroup  : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : stockNumber
            },
            {
                $Type : 'UI.DataField',
                Value : department_ID
            },
            {
                $Type : 'UI.DataField',
                Value : min
            },
            {
                $Type : 'UI.DataField',
                Value : max
            },
            {
                $Type : 'UI.DataField',
                Value : target
            },
            {
                $Type : 'UI.DataField',
                Value : quantity
            }
        ]
    },
    UI.Facets:[
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup',
            Label : 'Inventory Information',
            ID : 'InventoryInformation'
        }
    ]
);