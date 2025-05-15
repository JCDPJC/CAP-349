using {LogaliGroup as service} from '../service';

annotate service.Status with {                        //Field Labels with @title
    code     @title : 'Status Name'
    @Common : { 
        Text : name,
        TextArrangement : #TextOnly
     }
};