var catalogDB = db.getSiblingDB("Amazon_Ecommerce_NoSQL");

// Screenshot 2 - NoSQL collections
printjson(catalogDB.getCollectionNames().sort());


// Screenshot 4 - Product catalog using JSON documents
printjson(catalogDB.products.find({_id: {$in: [1,2,3,4,5,6]}}).sort({_id:1}).toArray());


// Screenshot 6 - Electronics products (NoSQL)
printjson(catalogDB.products.find({"category.category_name":"Electronics", _id: {$in:[1,2,3,4,5,6]}}, {product_name:1,price_inr:1}).sort({_id:1}).toArray());


// Screenshot 8 - Price greater than INR 1000 (NoSQL)
printjson(catalogDB.products.find({price_inr:{$gt:1000}, _id:{$in:[1,2,3,4,5,6]}}, {product_name:1,price_inr:1}).sort({_id:1}).toArray());


// Screenshot 10 - Product count by category (NoSQL)
printjson(catalogDB.products.aggregate([
  {$match:{_id:{$in:[1,2,3,4,5,6]}}},
  {$group:{_id:"$category.category_name", Product_Count:{$sum:1}}},
  {$sort:{_id:1}}
]).toArray());
