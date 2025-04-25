namespace com.logaligroup;   // Un namespace para clasificar

// Aspects
using {
    cuid,      // key ID  : UUID;
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

// Types
type decimal : Decimal(5, 3);

// Definimos entidades, sólo estas van en plural
entity Products : cuid, managed {
    product       : String(8);
    productName   : String(80);
    description   : LargeString;          // 1024 chars
    category      : Association to Categories; //category      --- category_ID   // 1..1 relation  //Fiels *_ID es el almacenado
    subCategory   : Association to SubCategories; //subCategory   --- subCategory_ID    // 1..1 relation //Fiels *_ID es el almacenado
    statu         : Association to Status; //statu --- statu_code
    price         : Decimal(5, 2);
    rating        : Decimal(3, 2);     //Decimal de 3 dígitos y 2 son decimales
    currency      : String;
    detail        : Association to ProductDetails;
    supplier      : Association to Suppliers;
    toReviews     : Association to many Reviews
                        on toReviews.product = $self;
    toInventories : Association to many Inventories
                        on toInventories.product = $self;
    toSales       : Association to many Sales
                        on toSales.product = $self;
};

entity ProductDetails : cuid {
    baseUnit   : String default 'EA';  //Con valor por defecto
    width      : decimal;
    height     : decimal;
    depth      : decimal;
    weight     : decimal;
    unitVolume : String default 'CM';  //Con valor por defecto
    unitWeight : String default 'KG';  //Con valor por defecto
};

entity Suppliers : cuid {
    supplier     : String(9);
    supplierName : String(40);
    webAddress   : String(250);
    contact      : Association to Contacts;
};

entity Contacts : cuid {
    fullName    : String(40);
    email       : String(80);
    phoneNumber : String(14);
};

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    reviewText : LargeString;
    product    : Association to Products;
};

entity Inventories : cuid {
    stockNumber : String(9);
    department  : Association to Departments;
    min         : Integer;
    max         : Integer;
    target      : Integer;
    quantity    : Decimal(4, 3);
    baseUnit    : String default 'EA';
    product     : Association to Products;
};

entity Sales : cuid {
    month         : String(20);
    year          : String(4);
    quantitySales : Integer;
    product       : Association to Products;
};


/** Code List */

entity Status : CodeList {
    key code : String(20) enum {
            InStock         = 'In Stock';
            OutOfStock      = 'Out of Stock';
            LowAvailability = 'Low Availabilit';
        }
};

/** Value Helps */

entity Categories : cuid {
    category        : String(80);
    toSubCategories : Association to many SubCategories
                          on toSubCategories.category = $self;   //1..N relation is needed for navigation
};

entity SubCategories : cuid {
    subCategory : String(80);
    category    : Association to Categories;  //category      --- category_ID
};

entity Departments : cuid {
    department : String(40);
};