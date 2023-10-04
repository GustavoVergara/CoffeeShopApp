const express = require('express')
const app = express()
const port = process.env.PORT || 5000
const filesystem = require('fs');
const path = require('path');
const rootPath = path.resolve(__dirname);

app.get("/store/:storeID/menu", (request, response) => {
//   var menuJSON = filesystem.readFileSync(`jsons/store/${request.params.storeID}/menu.json`, "utf8")
//   response.send(menuJSON)
  response.sendFile(`jsons/store/${request.params.storeID}/menu.json`, { root: rootPath })
})

// app.get("/game/:gameID", (request, response) => {
//   var matchesJSON = JSON.parse(filesystem.readFileSync("jsons/games.json", "utf8"))
//   var selectedMatch = matchesJSON.filter((el) => { return el.id == request.params.gameID })[0]

//   if (selectedMatch != undefined) {
//     response.send({
//       "game": selectedMatch,
//       "moves": JSON.parse(filesystem.readFileSync("jsons/moves.json", "utf8"))
//     })
//   } else {
//     response.sendStatus(404);
//   }
// })

app.listen(port, () => {
  console.log(`Server running at port ${port}`);
})
