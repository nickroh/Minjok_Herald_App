const functions = require('firebase-functions');

const express = require('express');
const engines = require('consolidate');
const firebase = require('firebase-admin');
const app = express();

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended:false}))


app.engine('hbs', engines.handlebars);
app.set('views','./views');
app.set('view engine', 'hbs');

app.get('/',(request, response)=>{
    response.set('Cache-Control','public, max-age=300, s-maxage=600');
    response.render('index',{layout: 'default', template: 'home-template'});
})

app.post('/check',(request, response)=>{
    var id = request.body.Id;
    var password = request.body.Pass;

    if(id == "minjokherald" && password == "2020press"){
        response.set('Cache-Control','public, max-age=300, s-maxage=600');
        response.render('mainpage',{layout: 'default', template: 'home-template'});
    }else{
        response.send(`id : ${id}, pw : ${password}  INVALID`);
    }
})

app.get('/signup',(request, response)=>{
    response.set('Cache-Control','public, max-age=300, s-maxage=600');
    response.render('signup',{layout: 'default', template: 'home-template'});
})

// app.get('/main',(request, response)=>{
//     response.set('Cache-Control','public, max-age=300, s-maxage=600');
//     response.render('mainpage',{layout: 'default', template: 'home-template'});
// })
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.app = functions.https.onRequest(app);

