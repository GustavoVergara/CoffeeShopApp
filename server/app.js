const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = process.env.PORT || 5001
const filesystem = require('fs');
const path = require('path');
const rootPath = path.resolve(__dirname);
const { v4: uuidv4 } = require('uuid');

app.get("/store/:storeID/menu", (request, response) => {
  response.sendFile(`jsons/store/${request.params.storeID}/menu.json`, { root: rootPath })
})

app.post("/store/:storeID/order", bodyParser.json(), (request, response) => {
  var uuid = uuidv4();

  const date = new Date()
  bodyJSON = request.body;
  bodyJSON.order_id = uuid;
  bodyJSON.date = date.toISOString();
  bodyJSON.expected_delivery_date = new Date(date.getTime() + 15*60000).toISOString();
  bodyString = JSON.stringify(bodyJSON);

  var storePath = `orders/${bodyJSON.user.id}/${request.params.storeID}`;
  var orderPath = `${storePath}/${uuid}.json`;

  console.log(`[${bodyJSON.date}] Registering Order '${uuid}'. {"user": ${JSON.stringify(bodyJSON.user)}}`);

  filesystem.promises
    .mkdir(storePath, { recursive: true })
    .then(() => {
      return filesystem.promises.writeFile(orderPath, bodyString, { root: rootPath });
    })
    .finally(() => {
      response.status(200);
      response.sendFile(orderPath, { root: rootPath });  
    });
})

app.get("/store/:storeID/orders", bodyParser.json(), async (request, response) => {
  var userID = request.query.userID;
  if (userID == null) {
    response.sendStatus(400);
    return;
  }
  var responseBody = [];

  const files = await filesystem.promises.readdir(`orders/${userID}/${request.params.storeID}`, { root: rootPath });
  console.log(`Getting orders for {storeID: '${request.params.storeID}', userID: '${userID}'}`);

  for (const file of files) {
    const fileContents = await filesystem.promises.readFile(rootPath + `/orders/${userID}/${request.params.storeID}/` + file);
    console.log(`-> File '${file}': ${fileContents}`);
    responseBody.push(JSON.parse(fileContents));
  }
  
  response.status(200);
  response.send(responseBody);
})

app.use('/static', express.static(path.join(__dirname, 'public')))

app.listen(port, () => {
  console.log(`Server running at port ${port}`);
})
