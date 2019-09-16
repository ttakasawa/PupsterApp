const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();
const fetch = require('node-fetch');

//import { event } from 'firebase-functions/lib/providers/analytics';
const stripeWeb = require('stripe')(functions.config().stripe.token);


exports.stripeCharge = functions.database.ref('/webAppPayments/{userId}/{paymentId}')
    .onWrite((change,context) => {
        const payment = change.after.val();
        const userId = context.params.userId;
        const paymentId = context.params.paymentId;

        if (!payment || payment.charge) return

        const amount = payment.amount;
        const idempotency_key = paymentId;
        const source = payment.tokenId;
        const currency = 'usd';

        const charge = { amount, currency, source };

        return stripeWeb.charges.create(charge, { idempotency_key })
            .then(charge => {
                admin.database()
                    .ref(`/webAppPayments/${userId}/${paymentId}`)
                    .set(charge)

                return 0
            })
    })



exports.createProduct = functions.database.ref('/market/junk').onCreate((snapshot, context) => {
  dummy();

});

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
 dummy();
});

function dummy(){
  var varCheckoutId = "random";
  var varvariantId = "stuff";
  var varproductId = "to";
  var varproductPrice = "store";
  var varproductName = "for";
  var varuserId = "test";

  var temp = "lol";
  var tmp = "hi";
  var posting = {"hello8": {"id": temp, "lastname": tmp}};
  var after = JSON.stringify(posting);
  var second = JSON.parse(after);

  const timeS = Date.now();


  var constructedJson = {"checkOutId": varCheckoutId};
  var tempJ = JSON.stringify(constructedJson);
  var finalJ = JSON.parse(tempJ);
  console.log(finalJ);

  return admin.database().ref('/articles').child("test").update(finalJ);
}

function saveCheckOutRecord(checkOutId, variantId, productId, productPrice, productName, userId){
  admin.auth().verifyIdToken(userId)
  .then(function(decodedToken) {
    var uid = decodedToken.uid;
    const checkoutTime = Date.now();


    var constructedJson = {"checkOutId": checkOutId, "variantId": variantId, "productId": productId, "productPrice": productPrice, "varproductName": productName, "userID": userId, "time": checkoutTime};
    var tempJ = JSON.stringify(constructedJson);
    var finalJ = JSON.parse(tempJ);
    console.log(finalJ)

    return admin.database().ref('/purchases').child(checkOutId).update(finalJ);
  }).catch(function(error) {

    errorReport('purchase error for ' + checkOutId, 'user token not proper.')
    return admin.database().ref('/report').child('purchaseError').push(error);
    
  });
}


function errorReport(subTopic, value){
  
  return admin.database().ref('/report').child("serverErr").push().set({
    topic: subTopic,
    content: value
  });
}

function errorReportForProductStore(report){
  return admin.database().ref('/report').child("productAdd").push().set({
    topic: 'error on add/edit product',
    content: report
  });
}











const express = require('express');
//var stripe = require('stripe')('sk_test_e9QvD6WfoRhnIleY9AFYt2lZ');//sk_live_he2a0SgqmDTNoqcodl8GOTVO
var stripe = require('stripe')('sk_live_he2a0SgqmDTNoqcodl8GOTVO');
var bodyParser = require('body-parser');
var app = express();

const SECRET = 'a49ab068d586970e76af671b059083df1d833bc6a911d0f93fe6e736d6d23cab';
const crypto = require('crypto');


function rawBodySaver (req, res, buf, encoding) {
  console.log('get raw');
  if (buf && buf.length) {
    req.rawBody = buf.toString(encoding || 'utf8')
  }
}

app.use('/productWebhook', bodyParser.urlencoded({
  extended: true,
  verify: rawBodySaver
}));


app.post('/updateCollection', function(req, res) {
  console.log('updateCollection');

  var newCollection = req.body;
  var id = req.body.id
  console.log(newCollection);
  res.status(200).send();
  return populateCollection();
});


function populateCollection(){
  var latestCollection = `{
    shop{
      collections(reverse: true, sortKey: UPDATED_AT, first: 1){
        edges{
          node{
            id
            title
            description
            products(first: 10){
              edges{
                node{
                  id
                  title
                  priceRange{
                    minVariantPrice{
                      amount
                    }
                  }
                  images(first:1){
                    edges{
                      node{
                        originalSrc
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }`;
  var temp = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    latestCollection,
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    var productsInCollection = [];
    var productsImages = [];
    var productPrices = [];
    var productTitle = [];

    var newCollection = json.data.shop.collections.edges[0].node;
    var collectionId = newCollection.id;
    var collectionTitle = newCollection.title;
    var collectionDescription = newCollection.description
    var isCollectionready = true

    var productsArray = newCollection.products.edges;
    for(var i = 0; i < productsArray.length; i++) {
      var obj = productsArray[i].node;
      var pImage = obj.images.edges[0].node;
      var pMinPrice = obj.priceRange.minVariantPrice;
      
      productsInCollection.push(obj.id);
      productPrices.push(pMinPrice.amount);
      productTitle.push(obj.title);
      productsImages.push(pImage.originalSrc);
    }

    return writeCollectionToDB(collectionId, collectionTitle, collectionDescription, isCollectionready, productsInCollection, productsImages, productTitle, productPrices);
  })

  temp.catch(function(error) {
    console.log(error);
    return errorReport('collection appending failed at graphQL', error);
  });
}

function writeCollectionToDB(collectionId, collectionTitle, collectionDescription, isCollectionready, productsInCollection, productsImages, productTitle, productPrices){
  var collection = {"title": collectionTitle, "id" : collectionId, "description": collectionDescription, "isReady": isCollectionready,"productIds": productsInCollection, "productImages": productsImages, "productTitles": productTitle, "productPrices": productPrices};
  var collectionStr = JSON.stringify(collection);
  var appendCollection = JSON.parse(collectionStr);
  console.log(appendCollection)

  return admin.database().ref('/collection').child(collectionTitle).update(appendCollection);
}

function associateCustomerToCheckOut(checkOutId, accessTok){
  var queryToAssociate = `mutation {
    checkoutCustomerAssociate(checkoutId: "` + checkOutId + `", customerAccessToken: "` + accessTok + `") {
      userErrors {
        field
        message
      }
      checkout {
        id
        webUrl
      }
    }
  }`;

  
  console.log(queryToAssociate)

  var temp = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToAssociate,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){
    console.log(json);
    console.log(json.body);
    console.log(json.data);

    return 0;
  })
}


app.post('/check_out', (req, res) => {
  console.log('in checkout')
  console.log(req.body)
  var variantId = req.body.varientId;
  var productId = req.body.productId;
  var productPrice = req.body.price;
  var productName = req.body.name;
  var userId = req.body.userId;
  var accessTok = req.body.access;

  
  console.log(variantId)
  //variantId = "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0VmFyaWFudC8xMjQ2NDQ1NDMzNjU3MA=="

  var queryToCheckOut = `mutation {
    checkoutCreate(input: {
      lineItems: [{ variantId: "` + variantId +`" , quantity: 1 }]
    }) {
      checkout {
        id
        webUrl
      }
    }
  }`;

  
  console.log(queryToCheckOut)

  var temp = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToCheckOut,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    var testing = json.data.checkoutCreate.checkout
    var web = testing.webUrl;
    var checkOutId = testing.id

    res.status(200).send(web)
    if(accessTok !== 'none'){
      console.log('associate customer with checkout')
      associateCustomerToCheckOut(checkOutId, accessTok);
    }
    

    return saveCheckOutRecord(checkOutId, variantId, productId, productPrice, productName, userId);
    });

  temp.catch(function(error) {
    console.log(error);
    //console.log(err, req.body)
    res.status(500).end()
  });

});

function completeOrder(orderId){
  var query = `mutation {
    draftOrderComplete(id: DraftOrderDeleteInput(orderId)) {
      userErrors {
        field
        message
      }
      draftOrder {
        id
      }
    }
  }`;

  
  console.log(query)

  var queryToCompleteOrder = fetch('https://pupster2.myshopify.com/admin/api/graphql.json', { 
    method: 'POST',
    body:    query,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Access-Token': 'e5235f46fa396ab84fa439c2a4d31cb2', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    //TODO: fail and get money back

    var resData = json.data;
    console.log(resData);

    return true;
    });

  queryToCompleteOrder.catch(function(error) {
    console.log(error);
    return false;
  });
}


app.post('/create_order', (req, res) => {
  console.log(req.body)

  var variantId = req.body.variantId;
  var email = req.body.email;
  var firstLine = req.body.firstLine;
  var secondLine = req.body.secondLine;
  var city = req.body.city;
  var state = req.body.state;
  var country = req.body.country;
  var zip = req.body.zip;
  var firstName = req.body.firstName;
  var lastName = req.body.lastName;

  var queryToCheckOut = `mutation {
    draftOrderCreate(input: {
      lineItems: [{ variantId: "` + variantId +`" , quantity: 1 }],
      email: "` + email +`",
      shippingAddress:{
        address1: "` + firstLine +`",
        address2: "` + secondLine +`",
        city:"` + city +`",
        country: "` + country +`",
        firstName:"` + firstName +`",
        lastName: "` + lastName +`",
        province:"` + state +`",
        zip:"` + zip +`"
      }
    }) {
      userErrors {
        field
        message
      }
      draftOrder {
        id
      }
    }
  }`;

  
  console.log(queryToCheckOut)

  var graphQuery = fetch('https://pupster2.myshopify.com/admin/api/graphql.json', { 
    method: 'POST',
    body:    queryToCheckOut,
    headers: { 'X-Shopify-Access-Token': 'e5235f46fa396ab84fa439c2a4d31cb2', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    var resData = json.data;
    var orderId = resData.draftOrderCreate.draftOrder.id;

    var query = `mutation {
      draftOrderComplete(id: "` + orderId +`") {
        userErrors {
          field
          message
        }
        draftOrder {
          id
        }
      }
    }`;

    
    console.log(query)

    var queryToCompleteOrder = fetch('https://pupster2.myshopify.com/admin/api/graphql.json', { 
      method: 'POST',
      body:    query,
          //body: JSON.stringify({ query: bodyS }),
      headers: { 'X-Shopify-Access-Token': 'e5235f46fa396ab84fa439c2a4d31cb2', 'Content-Type': 'application/graphql' }
    }).then(
      res => res.json()
    ).then(function (json){
      var result = json.data;
      console.log(result);
      res.status(200).send()
      return 0;
    });

    queryToCompleteOrder.catch(function(error) {
      console.log(error);
      res.status(500).end()
      return false;
    });


    return 0;
    });

  graphQuery.catch(function(error) {
    console.log(error);
    //console.log(err, req.body)
    res.status(500).end()
  });
  return;
});





function storeMarketCredentials(userId, newCustomerId, accessToken, expiration){
  console.log("storing in real time db")
  var date = new Date(expiration);
  var inMillisecond = date.getTime();
  var inSeconds = inMillisecond / 100;

  var constructedJson = {"customerID": newCustomerId, "accessToken": accessToken, "expiration": inSeconds};
  var tempJ = JSON.stringify(constructedJson);
  var finalJ = JSON.parse(tempJ);
  console.log(finalJ);

  admin.auth().verifyIdToken(userId)
  .then(function(decodedToken) {
    var uid = decodedToken.uid;

    var shopifyNodeJson = {"accessToken": accessToken, "expiration": inSeconds, userId: uid};
    var tempShopify = JSON.stringify(shopifyNodeJson);
    var finalShopify = JSON.parse(tempShopify);
    
    admin.database().ref('/shopifyUser').child(newCustomerId).update(finalShopify);
    return admin.database().ref('/users').child(uid).child('shopifyInfo').update(finalJ);
  }).catch(function(error) {
    return errorReport('user id was not valid in storeMarketCredentials', 'Userid is ' + userId + ', new customerID ' + newCustomerId + ', access token ' + accessToken+ ', and expiration ' + expiration);
    //return admin.database().ref('/report').child(userId).child('shopifyActivationFailed').update(finalJ);
    
  });
}



function activateShopifyUser(userId, email, pass, newCustomerId){
  if (email === "none"){
    errorReport('activateShopifyUser', 'email is none for user ' + userId)
  }
  if (pass === "none"){
    errorReport('activateShopifyUser', 'password is none for user ' + userId)
  }
  var queryToCreateToken = `mutation{
    customerAccessTokenCreate(input: 
      {email: "` + email + `", password: "` + pass + `"}
    ){
      userErrors {
        field
        message
      }
      customerAccessToken {
        accessToken
        expiresAt
      }
    }
  }`;

  var createAccessToken = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToCreateToken,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()

  ).then(function(accessJson){
    console.log("creating access token")
    var result = accessJson.data.customerAccessTokenCreate;
    console.log(result);

    var queryError = result.userErrors;
    var messageerror = queryError.message;
    if ( typeof messageerror !== 'undefined' && messageerror ){
      console.log("error found");
      errorReport('user activation failed for user ' + userId, messageerror)
    }else{
      var accessToken = result.customerAccessToken.accessToken;
      //console.log(accessToken)

      var expiration = result.customerAccessToken.expiresAt;
      //console.log(expiration)

      storeMarketCredentials(userId, newCustomerId, accessToken, expiration);
    }


    return 0;
  });

  createAccessToken.catch(function(error) {
    console.log(error);
    //console.log(err, req.body)
    res.status(500).end()
  });
}


app.post('/recreateAccessToken', (req, res) => {
  var email = req.body.email;
  var userId = req.body.userId;
  var pass = req.body.pass;
  var shopifyCustomerID = req.body.shopifyCustomerID;
  if (email === "none" || userId === "none" || pass === "none"){
    errorReport("recreateAccessToken", "no proper data is provided");
    res.status(500).end()
    return
  }else{
    res.status(200).send()
  }
  activateShopifyUser(userId, email, pass, shopifyCustomerID)
});

app.post('/renewCustomerToken', (req, res) => {
  var currentToken = req.body.ct;
  var userId = req.body.userid;
  var shopifyCustomerID = req.body.customerId;
  if (currentToken === "none" || userId === "none" || shopifyCustomerID === "none"){
    errorReport("renewCustomerToken", "no proper data is provided");
    res.status(500).end()
    return
  }else{
    res.status(200).send()
  }

  var queryToCreateCustomer = `mutation{
    customerAccessTokenRenew(customerAccessToken: "` + currentToken + `"){
      userErrors {
        field
        message
      }
      customerAccessToken {
        accessToken
        expiresAt
      }
    }
  }`;

  var renew = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToCreateCustomer,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){
    console.log('in renewing customer token');
    console.log(json);
    console.log(json.body);
    
    var result = json.data;
    console.log(result);
    
    var second = result.customerAccessTokenRenew;
    console.log(second)
    var accessData = second.customerAccessToken;
    var newToken = accessData.accessToken;
    var newExp = accessData.expiresAt;

    return storeMarketCredentials(userId, shopifyCustomerID, newToken, newExp)
  })

  renew.catch(function(error) {
    console.log(error);
    //console.log(err, req.body)
    res.status(500).end()
  });

});



app.post('/create_shopify', (req, res) => {
  console.log("in the create shopify");

  var email = req.body.email;
  var pass = req.body.password;
  var fName = req.body.first;
  var lName = req.body.last;
  var userId = req.body.userid;

  res.status(200).send();

  var queryToCreateCustomer = `mutation{
    customerCreate(input: 
      {email: "` + email + `", password: "` + pass + `", firstName: "` + fName + `", lastName: "` + lName + `"}
    ){
      userErrors {
          field
          message
        }
        customer {
          id
        }
    }
  }`;

  console.log(queryToCreateCustomer)

  var create = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToCreateCustomer,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    var result = json.data.customerCreate
    console.log(json.data)


    var fail = result.userErrors
    var errorFromShopify = result.userErrors;
    var message = errorFromShopify.message;

    if (!result){
      console.log("error found: result null");
      errorReport("errorCreateShopifyNull", "null has returned");
      //checkIfCreated();
      res.status(500).end();
      return 0;

    }else{

      if ( typeof message !== 'undefined' && message ){
        console.log("error found: ErrorFromShopify");
        errorReport("error", "errorFromShopify.message is true: " + email);
        //checkIfCreated();
        res.status(500).end();
        return 0;
      }
    }

    

    var customerDataSegment = result.customer;
    console.log("customer created")
    console.log(customerDataSegment)

    if ( customerDataSegment === null ){
      console.log("error found: customerDataSegment is null");
      errorReport("errorCreateShopify", "customerDataSegment is null");
      //checkIfCreated();
      res.status(500).end();
      return 0;
    }

    var newCustomerId = customerDataSegment.id;
    console.log(newCustomerId);
    res.status(200).send();

    activateShopifyUser(userId, email, pass, newCustomerId);

    
    
    return 0;
  });


  create.catch(function(error) {
    console.log(error);
    //console.log(err, req.body)
    res.status(500).end()
  });
});


app.post('/charge', (req, res) => {
  var customer = req.body.customer;
  var amount = req.body.amount;
  var currency = req.body.currency;
  var shipping = req.body.shipping;

  stripe.charges.create({
    customer : customer,
    amount : amount,
    currency : currency,
    shipping : shipping
  }, function(err, charge){
    if (err){
      console.log(err, req.body)
      res.status(500).end()
    } else {
      console.log()
      res.status(200).send()
    }
  })

});


app.post('/ephemeral_keys', (req, res) => {
  var customerID = req.body.customer_id;
  var api_version = req.body.api_version;

  stripe.ephemeralKeys.create(
    {customer : customerID},
    {stripe_version : api_version}
  ).then((key) => {
    console.log('success')
    res.status(200).send(key)
    return
  }).catch((err) => {
    console.log(err, req.body)
    res.status(500).end()
  });
});

app.post('/create_customer', (req, res) => {
  var email = req.body.email;
  stripe.customers.create({

    email: req.body.email

    }, function(err, customer) {
      if (err){
        console.log(err, req.body)
        console.log('create customer failed for')
        console.log(email)
        res.status(500).end()
      }else{
        console.log('create customer succcess')
        //console.log(customer.body.id)
        console.log(customer.id)
        
        res.status(200).send(customer.id)
      }
   }
 );
});


function storeProducts(newProduct, pid, res){
  admin.database().ref('/products').child(pid).update(newProduct);
  return queryGraphQLForId(pid, 'create', res);
}

function deleteProducts(deleteItem){
  //var deleteItem = req.query.date;
  console.log('deleting');
  var db = admin.database();
  var productToBeRemoved = db.ref('/products');
  var updateVal = {};

  return productToBeRemoved.child(deleteItem).remove();


}

function updateProducts(pid, updatedProduct, res){
  console.log('update');
  admin.database().ref('/products').child(pid).update(updatedProduct);
  return queryGraphQLForId(pid, 'update', res);
}


function createCollection(newCollection){
  return admin.database().ref('/collections').update(newCollection);
}

function replaceKey(pid, productGraphId){
  var booksRef = admin.database().ref('products');
  var swap = booksRef.child(pid).once('value').then(function(snap) {
    var data = snap.val();
    //data.bookInfo.bookTitle = productGraphId;
    var update = {};
    update[pid] = null;
    update[productGraphId] = data;
    if (data !== null){
      console.log('update product ended successfully with id ' + productGraphId + ' with data: ' + data);
      booksRef.update(update);

    }
    
    
    return 0;
  });

  swap.catch(function(error) {
    console.log('error in replaceKey');

    return 0
  });
}

function storeGraphQLIds(pid, productGraphId, variantGraphIds){
    //let prodId = 
    var prodRef = admin.database().ref('/products').child(pid);
    var variantsArr = prodRef.child("variants")
    variantsArr.on("value", function(snapshot) {
      
      var firebaseVariants = snapshot.val()
      if (firebaseVariants !== null){
        for(var i = 0; i < firebaseVariants.length; i++) {
          var obj = firebaseVariants[i];
          if (obj){
            //console.log("firebase id    " + obj.id + "   graphId   " + variantGraphIds[i]);
          }
          

          var variantgraphjson = {"GraphId": variantGraphIds[i]};
          var variantgraphjsonStr = JSON.stringify(variantgraphjson); 
          var jsonForGraphVariant = JSON.parse(variantgraphjsonStr);
          variantsArr.child(i).update(jsonForGraphVariant);
        }
      }
      
    }, function (errorObject) {
      console.log("The read failed: " + errorObject.code);
    });

    var temp = {"productGraphId": productGraphId};
    var stringifyObj = JSON.stringify(temp); 
    var jsonTemp = JSON.parse(stringifyObj);
    //var jsonTemp = JSON.parse(temp);
    console.log(jsonTemp)
    //prodRef.update(jsonTemp);

    return replaceKey(pid, productGraphId);
}

function queryGraphQLForId(pid, option, res){
  var operation = 'CREATED_AT';
  if (option === 'create'){
    operation = 'CREATED_AT';
  }else if(option === 'update'){
    operation = 'UPDATED_AT'
  }
  var queryToCheckOut = `{
  shop{
    products(sortKey:` + operation + `, first: 1, reverse: true) {
    
      edges{
        node{
          id
          title
          variants(first: 200){
            edges{
              node{
                id
              }
            }
          }
        
        }
      }
    }
  }
}`;

  
  //console.log(queryToCheckOut)

  var temp = fetch('https://pupster2.myshopify.com/api/graphql', { 
    method: 'POST',
    body:    queryToCheckOut,
        //body: JSON.stringify({ query: bodyS }),
    headers: { 'X-Shopify-Storefront-Access-Token': '6ebb5540bc8b5fe3509fc83a68d3da4d', 'Content-Type': 'application/graphql' }
  }).then(
    res => res.json()
  ).then(function (json){

    res.status(200).send();
    var variantGraphIds = [];
    var productGraphId = json.data.shop.products.edges[0].node.id;

    var variantNodesArrayFromGraph = json.data.shop.products.edges[0].node.variants.edges;
    for(var i = 0; i < variantNodesArrayFromGraph.length; i++) {
      var obj = variantNodesArrayFromGraph[i].node;
      variantGraphIds.push(obj.id);
    }

    /*if(option === 'update'){
      populateCollection();
    }*/

    return storeGraphQLIds(pid, productGraphId, variantGraphIds);
  });

  temp.catch(function(error) {
    console.log(error);
    console.log('graphQL failed')
    return 0
  });
}


app.post('/productWebhook', function(req, res) {
  console.log('webhook receedjj');
  console.log(req.body.id);
  var pid = req.body.id
  var newProduct = req.body;
  if (validateRequest (req)){
    console.log("success ");
  }else{
    console.log('faile');
    
  }
  res.status(200).send();

  storeProducts(newProduct, pid, res);
  //verifyShopifyHook(req);

  console.log('real one');
  console.log(req.headers['x-shopify-hmac-sha256']);
  console.log("new webhook");

});



app.post('/deleteProduct', function(req, res) {
  console.log('deletung');
  console.log(req.body);
  console.log(req.body.id);
  var deleteItem = req.body.id;
  res.status(200).send();
  deleteProducts(deleteItem);
});

app.post('/updateProduct', function(req, res) {
  console.log('updating');
  updatedProduct = req.body;
  pid = req.body.id;
  //res.status(200).send();
  console.log(pid)
  updateProducts(pid, updatedProduct, res)
});



app.post('/updateProd', function(req, res) {
  console.log('updating in new one');
  updatedProduct = req.body;
  pid = req.body.id;
  //res.status(200).send();
  console.log(pid)
  updateProducts(pid, updatedProduct, res)
});





exports.app = functions.https.onRequest(app);




















//webhook verification related

function verifyShopifyHook(req) {
  console.log('on verifyToken');
    



   /*var hat = new Buffer(
        crypto.createHmac('SHA256', SECRET).update(req.body).digest('hex')
    ).toString('base64');*/

//var hash = crypto.createHmac('sha256',SECRET).update(req.body,'utf8').digest('base64');
/*var crypto = require('crypto');
var s = 'The quick brown fox jumps over the lazy dog';
console.log(
    new Buffer(
        crypto.createHmac('SHA256', SECRET).update(s).digest('hex')
    ).toString('base64')
);
*/
//.toString('utf8');


    //console.log(alt);
    
    //console.log(hat);
    var digesting = crypto.createHmac('SHA256', SECRET)
            .update(new Buffer(req.rowBody, 'utf8'))
            .digest('base64');


    console.log(digesting);
    console.log(req.headers['x-shopify-hmac-sha256']);
    
    //return digest === req.headers['X-Shopify-Hmac-Sha256'];
    return digest === req.headers['x-shopify-hmac-sha256'];
}

function handleRequest(req, res) {
  console.log('in handleRequest');
    if (verifyShopifyHook(req)) {
      console.log('verify!');
        res.writeHead(200);
        res.end('Verified webhook');
    } else {
      console.log('verify fail!');
        res.writeHead(401);
        res.end('Unverified webhook');
    }
}

function validateRequest (req) {
  console.log('validateRequest');
  const digest = crypto
        .createHmac('sha256', SECRET)
        .update(JSON.stringify(req.body))
        .digest('base64');

  const digesting = crypto
        .createHmac('sha256', SECRET)
        .update(toString(req.body))
        .digest('base64');

  const dig = crypto
        .createHmac('sha256', SECRET)
        .update(JSON.stringify(req.body))
        .digest('base64');

        console.log('dv');
        //console.log(est);
        console.log(digest);
        console.log(digesting);
        console.log(dig);
        var dgf = crypto.createHmac('SHA256', SECRET)
            .update(new Buffer(req.body.toString(), 'utf8'))
            .digest('base64');

         console.log(dgf);
        console.log('sdv');

      if (req.headers['x-shopify-hmac-sha256'] !== `sha1=${digest}`) {
        console.log('unauthorized');
        return false;
      }else{
        console.log('done');
        return true;
      }
}





exports.sendMessageNotificationToUser = functions.database.ref('UserMessages/{userId}/{messageKey}').onCreate((snapshot, context) => {
  const original = snapshot.val();

  var key = context.params.messageKey
  var userAuthKey = context.params.userId

  console.log('message detected')

  if (original === true) {

    admin.database().ref('messages').child(key).once('value').then(function(snap) {

      var messageData = snap.val();
      var messageContext = messageData.text
      if (typeof messageContext === 'undefined'){
        messageContext = 'Gwen has sent you an image.'
      }
      console.log('user message queried')

      admin.database().ref('users').child(userAuthKey).once('value').then(function(snap) {
        var userData = snap.val();
        var fcmToken = userData.firMessagingRegistrationToken;
        if (typeof fcmToken === 'undefined'){
          console.log('no token')
          return false
        }else{
          console.log(fcmToken)
        }

        var message = {
          notification: {
            title: 'Gwen',
            body: messageContext
          },
          token: fcmToken

        };

        admin.messaging().send(message).then((response) => {
          // Response is a message ID string.
          console.log('Successfully sent message to user:', message);
          return 0;
        }).catch((error) => {
          console.log('Error sending message:', error);
          return 0;
        });

        return true
      }).catch((error) => {
        console.log('Error sending message:', error);
        return 0;
      });
      return true
    }).catch(error => {
      return false
    });

    
  }

  return true
});






exports.sendMessageNotification = functions.database.ref('UserMessages/{adminId}/{userID}/{messageKey}').onCreate((snapshot, context) => {
  const original = snapshot.val();

  var key = context.params.messageKey
  var userAuthKey = context.params.adminId


  if (original === true) {
    console.log('admin should get notify')

    admin.database().ref('messages').child(key).once('value').then(function(snap) {

      var messageData = snap.val();
      var messageContext = messageData.text
      if (typeof messageContext === 'undefined'){
        messageContext = 'User has sent you an image.'
      }


      admin.database().ref('Admin/9pXwaz1BtmbCxtxRTq7T8hyWNJG3/adminUsers').child('5KYzJlRpJQR5tI8Rea520wMziWi1').once('value').then(function(snap) {
        var userData = snap.val();
        var fcmToken = userData;
        console.log('user queried');

        if (typeof fcmToken === 'undefined'){
          console.log('no token')
          return false
        }else{
          console.log(fcmToken)
        }

        var message = {
          notification: {
            title: 'Admin received a message!',
            body: messageContext
          },
          token: fcmToken
        };

        admin.messaging().send(message).then((response) => {
          // Response is a message ID string.
          console.log('Successfully sent message to admin:', message);
          return 0;
        }).catch((error) => {
          console.log('Error sending message:', error);
          return 0;
        });

        return true
      }).catch((error) => {
        console.log('Error quering user message:', error);
        return 0;
      });
      return true
    }).catch(error => {
      return false
    });

    
  }

  return true
});




