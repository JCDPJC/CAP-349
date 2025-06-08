using {com.logaligroup.jcd as entities} from '../db/schema'; //Le indico el schema
using {API_BUSINESS_PARTNER as cloud} from './external/API_BUSINESS_PARTNER';  //External service

service LogaliGroup { // Inicio de la definición del servicio

    type Dialog {
        option : String(10); //Add or Discount
        amount : Integer;
    };


    entity Products         as projection on entities.Products;
    entity ProductDetails   as projection on entities.ProductDetails;
    entity Suppliers        as projection on entities.Suppliers;
    entity Contacts         as projection on entities.Contacts;
    entity Reviews          as projection on entities.Reviews;

    entity Inventories      as projection on entities.Inventories
        actions {
            //FEATURE
            @Core.OperationAvailable: {$edmJson: {$If: [  //Expresión dinámica
                {$Eq: [
                    {$Path: 'in/product/IsActiveEntity'}, //If be are in edit mode
                    false
                ]},
                false, //In edit mode the operarion is disable
                true   // In read mode the operation in available
            ]}}
            
            // SIDE EFFECT
            @Common                 : {SideEffects: {
                $Type           : 'Common.SideEffectsType',
                TargetProperties: ['in/quantity'],
                TargetEntities  : [in.product],
            }, }
            //ACTION
           
            action SetStock(in : $self, //This reference is mandatory
                            option : Dialog : option,
                            amount : Dialog : amount, )
        };

    entity Sales            as projection on entities.Sales;
    /**Code List */
    entity Status           as projection on entities.Status;
    entity Options          as projection on entities.Options;
    /** Value Helps */
    entity VH_Categories    as projection on entities.Categories;
    entity VH_SubCategories as projection on entities.SubCategories;
    entity VH_Departments   as projection on entities.Departments;


    /** Entidades externas */
    entity CBusinessPartner as projection on cloud.A_BusinessPartner {
        key BusinessPartner as ID,
            FirstName as FirstName,
            LastName as LastName
    };

    entity CSuppliers as projection on cloud.A_Supplier {
        Supplier as ID,
        SupplierName as SupplierName,
        SupplierFullName as FullName
    };    
};
