/*jshint node:true*/
module.exports = function(app) {
  var express = require('express');
  var searchRouter = express.Router();

  searchRouter.get('/', function(req, res) {
    res.send({
        'data': [{
                  id: "1",
                  type: "searches",
                  links: {
                  self: "http://api.lvh.me:5000/searches/1"
                  },
                  attributes: {
                    "parsed": "tothu=[1,200]",
                    "name": "Housing Demand Research",
                    "query": {
                      filter: {
                        tothu: [1,200]
                      }
                    }
                  }
                },
                {
                  id: "2",
                  type: "searches",
                  links: {
                  self: "http://api.lvh.me:5000/searches/2"
                  },
                  attributes: {
                    "parsed": "commsf=[100,2000]",
                    "name": "Commercial Square FEet",
                    "query": {
                      filter: {
                        tothu: [100,2000]
                      }
                    }
                  }
                }
                  ]
    });
  });

  searchRouter.post('/', function(req, res) {
    res.status(201).send({
      'data': {
        id: "3",
        type: "searches",
        links: {
        self: "http://api.lvh.me:5000/searches/1"
        },
        attributes: {
          "parsed": "tothu=[1,200]",
          "name": "Other Research",
          "query": {
            filter: {
              tothu: [1,200]
            }
          }
        }
      }
    })
  });

  searchRouter.get('/:id', function(req, res) {
    res.send({
      'search': {
        id: req.params.id
      }
    });
  });

  searchRouter.put('/:id', function(req, res) {
    res.send({
      'search': {
        id: req.params.id
      }
    });
  });

  searchRouter.delete('/:id', function(req, res) {
    res.status(204).end();
  });

  // The POST and PUT call will not contain a request body
  // because the body-parser is not included by default.
  // To use req.body, run:

  //    npm install --save-dev body-parser

  // After installing, you need to `use` the body-parser for
  // this mock uncommenting the following line:
  //
  //app.use('/api/search', require('body-parser'));
  app.use('/api/searches', searchRouter);
};
