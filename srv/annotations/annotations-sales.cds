using {LogaliGroup as service} from '../service';

annotate service.Sales with {
    monthCode     @title: 'Month Code'  @Common.IsCalendarMonth;  //the field is a Month
    month         @title: 'Month'       @Common.IsCalendarMonth;  //the field is a Month
    year          @title: 'Year'        @Common.IsCalendarYear;   //the field is a year
    quantitySales @title: 'Quantity Sales';
};  //Text i nlabels

annotate service.Sales with @(
    Analytics.AggregatedProperty #sum: {
        Name: 'Sales',
        AggregationMethod : 'sum',
        AggregatableProperty : quantitySales,
        ![@Common.Label] : 'Sales'
    },
    Aggregation.ApplySupported: {
        Transformations : [
   // This is the list of functions availables in the Graphic
            'aggregate',  //Aggragate is used
            'topcount',
            'bottomcount',
            'identity',
            'concat',
            'groupby',   // is used
            'filter',
            'top',
            'skip',
            'orderby',
            'search',
        ],
        GroupableProperties: [
            'month',
            'year'
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : quantitySales
            }
        ]
    },
    UI.Chart  : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,  //Chart type
        DynamicMeasures : [   //Measure from the Graph  (key-value in BW)
            '@Analytics.AggregatedProperty#sum',
        ],
        Dimensions:[ year, month]  //Dimensions         (infoObjwct in BW)
    },
);