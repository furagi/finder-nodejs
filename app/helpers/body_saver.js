/*
Save request's body to request.body without any parsing
*/

module.exports = function(req, res, next) {
    req.on('data', function(chunk) {
        if(!req.body) req.body = '';
        req.body += chunk;
    });
    req.on('end', function() {
        __log('debug', "Post parameters: " + req.body);
        next();
    });
};