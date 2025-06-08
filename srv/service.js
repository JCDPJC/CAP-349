const cds = require('@sap/cds');

require('dotenv').config();

// Export the module to the project, the class extend cds.ApplicationService
module.exports = class LogaliGroup extends cds.ApplicationService {

    async init() {

        // Entidades que gestiono
        const { Products, Inventories, CBusinessPartner, CSuppliers } = this.entities;

        //Conexiones
        const cloud = await cds.connect.to("API_BUSINESS_PARTNER");

        // READ External entities
        this.on('READ', CBusinessPartner, async (req)=>{
            return await cloud.tx(req).send({
                query: req.query,
                headers: {
                  //  apikey : "c2rf2xo8m6c0p6LA2wQt4vab9J0FcVXj"
                    apikey : process.env.APIKEY
                }
            })
        });

        this.on('READ', CSuppliers, async (req)=>{

            return await cloud.tx(req).send({
                query: req.query,
                headers: {
                    apikey : process.env.APIKEY
                }
            })
        });

        // Event ´BEFORE create
        this.before('NEW', Products.drafts, async (req) => {
            console.log(req.data);
            // Initialize Detail woth these values
            req.data.detail ??= {
                baseUnit: 'EA',
                width: null,
                height: null,
                depth: null,
                weight: null,
                unitVolume: 'CM',
                unitWeight: 'KG'
            }
        });

        this.before('NEW', Inventories.drafts, async (req) => {
            let result = await SELECT.one.from(Inventories).columns('max(stockNumber) as max');   //Persistent table
            let result2 = await SELECT.one.from(Inventories.drafts).columns('max(stockNumber) as max').where({ product_ID: req.data.product_ID }); //Draft Table

            let max = parseInt(result.max);  //Convert to number
            let max2 = parseInt(result2.max);
            let newMax = 0;

            if (isNaN(max2)) {
                newMax = max + 1;
            } else if (max < max2) {
                newMax = max2 + 1;
            } else {
                newMax = max + 1;
            }

            req.data.stockNumber = newMax.toString();
        });

        //Action es con ON y el nombre de la acción
        this.on('SetStock', async (req) =>{
            const productId = req.params[0].ID;
            const inventoryId = req.params[1].ID;

            // Value of Quantity
            const amount = await SELECT.one.from(Inventories).columns('quantity').where({ID: inventoryId});
            let newAmount = 0;

            if (req.data.option === 'A') {
                console.log("Estoy dentro");
                newAmount = amount.quantity + req.data.amount;
                if (newAmount > 100) {  
                    await UPDATE(Products).set({statu_code: 'InStock'}).where({ID: productId});  //UPDATE Status
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});

                return req.info(200, `The amount ${req.data.amount} has benn added to the inventory`);
            } else if (req.data.amount > amount.quantity) {
                return req.error(400,`There is no availability for the requested quantity`);
            } else {
                newAmount = amount.quantity - req.data.amount;

                if (newAmount > 0 && newAmount <= 100 ) {
                    await UPDATE(Products).set({statu_code: 'LowAvailability'}).where({ID: productId});  //UPDATE Status
                } else if  (newAmount === 0) {
                    await UPDATE(Products).set({statu_code: 'OutOfStock'}).where({ID: productId});       //UPDATE Status
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                return req.info(200, `The amount ${req.data.amount} has benn removed form the inventory`);
            }

        });



        return super.init();
    }
}