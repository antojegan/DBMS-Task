var catalogDB = db.getSiblingDB("Amazon_Ecommerce_NoSQL");
if (!catalogDB.getCollectionNames().includes("products")) catalogDB.createCollection("products");
if (!catalogDB.getCollectionNames().includes("product_kv")) catalogDB.createCollection("product_kv");
print(catalogDB.getName()); printjson(catalogDB.getCollectionNames());
var products = [
  {
    "_id": 1,
    "product_name": "Wireless Mouse",
    "description": "USB wireless optical mouse",
    "price_inr": 599,
    "category": {
      "category_id": 1,
      "category_name": "Electronics"
    },
    "seller": {
      "seller_id": 1,
      "seller_name": "Tech World",
      "business_name": "Tech World Electronics"
    }
  },
  {
    "_id": 2,
    "product_name": "Bluetooth Headphones",
    "description": "Over-ear Bluetooth headphones",
    "price_inr": 1499,
    "category": {
      "category_id": 1,
      "category_name": "Electronics"
    },
    "seller": {
      "seller_id": 1,
      "seller_name": "Tech World",
      "business_name": "Tech World Electronics"
    }
  },
  {
    "_id": 3,
    "product_name": "Electric Kettle",
    "description": "1.5 litre electric kettle",
    "price_inr": 1199,
    "category": {
      "category_id": 2,
      "category_name": "Home Appliances"
    },
    "seller": {
      "seller_id": 2,
      "seller_name": "Home Needs",
      "business_name": "Home Needs Store"
    }
  },
  {
    "_id": 4,
    "product_name": "Mixer Grinder",
    "description": "Three-jar mixer grinder",
    "price_inr": 2499,
    "category": {
      "category_id": 2,
      "category_name": "Home Appliances"
    },
    "seller": {
      "seller_id": 2,
      "seller_name": "Home Needs",
      "business_name": "Home Needs Store"
    }
  },
  {
    "_id": 5,
    "product_name": "DBMS Fundamentals",
    "description": "Database Management Systems textbook",
    "price_inr": 650,
    "category": {
      "category_id": 3,
      "category_name": "Books"
    },
    "seller": {
      "seller_id": 3,
      "seller_name": "Book Point",
      "business_name": "Book Point"
    }
  },
  {
    "_id": 6,
    "product_name": "SQL for Beginners",
    "description": "Introduction to SQL programming",
    "price_inr": 450,
    "category": {
      "category_id": 3,
      "category_name": "Books"
    },
    "seller": {
      "seller_id": 3,
      "seller_name": "Book Point",
      "business_name": "Book Point"
    }
  }
];
printjson(catalogDB.products.bulkWrite(products.map(p => ({replaceOne:{filter:{_id:p._id},replacement:p,upsert:true}}))));
printjson(catalogDB.products.find({_id:{$in:[1,2,3,4,5,6]}}).sort({_id:1}).toArray());
printjson(catalogDB.products.find({"category.category_name":"Electronics"}).toArray());
printjson(catalogDB.products.find({"seller.seller_id":2}).toArray());
var demo = {...products[0],_id:"week7-demo",product_name:"Demo Mouse"};
catalogDB.products.replaceOne({_id:demo._id},demo,{upsert:true});
printjson(catalogDB.products.updateOne({_id:demo._id},{$set:{price_inr:649}}));
printjson(catalogDB.products.findOne({_id:demo._id}));
printjson(catalogDB.products.deleteOne({_id:"week7-demo"}));
printjson(catalogDB.products.findOne({_id:"week7-demo"}));
printjson(catalogDB.product_kv.bulkWrite(products.map(p => ({replaceOne:{filter:{_id:"product:"+p._id},replacement:{_id:"product:"+p._id,value:p},upsert:true}}))));
printjson(catalogDB.product_kv.find().sort({_id:1}).toArray());
printjson(catalogDB.product_kv.findOne({_id:"product:1"}));
