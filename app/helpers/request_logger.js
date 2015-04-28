"use strict";

var _ = require("underscore");

var log = function(res, message, logObject, result) {
    var status = arguments[4] === undefined ? res.statusCode : arguments[4];
    var level = "info";
    if (typeof result === "string") {
        try {
            logObject.result = JSON.parse(result);
        } catch (_error) {
            logObject.result = result;
        }
    } else logObject.result = result;

    if (status) {
        if (status >= 400) {
            if (typeof result == "string") message += ": " + result;
            level = "warn";
        }
        if (status < 500) {
            logObject = null;
        } else {
            level = "error";
        }
    }
    logger.log(level, message, logObject);
};

var restore = function restore(req, res) {
    res.send = res.expressSend;
    delete res.expressSend;
    delete req.log;
    res.render = res.expressRender;
    delete res.expressRender;
    res.end = res.expressEnd;
    delete res.expressEnd;
};

module.exports = function (req, res, next) {
    var method = req.method.toUpperCase(),
        message = "" + method + " " + req.url,
        logObject = {
            request: {
                method: method,
                url: req.url,
                query: req.query,
                cookies: req.headers.cookie
            },
        errors: []
    };
    if (req.body) {
        logObject.request.body = {};
        _.extend(logObject.request.body, req.body);
    }

    if (req.session && req.session.user && req.session.user.login) {
        var login = req.session.user.login;
        message += " by " + login;
        logObject.user = login;
    }
    if (req.files) {
        logObject.files = [];
        var files = req.files["*"] || req.files;
        if (!_.isArray(files)) files = [files];
        for (var i = 0; i < files.length; i++) {
            if (files[i].id) logObject.request.files.push(_.pick(files[i], "id", "lastModified", "name", "path", "size", "type"));
        }
        if (!logObject.request.files.length) delete logObject.request.files;
    }
    res.expressSend = res.send;
    res.expressRender = res.render;
    res.expressEnd = res.end;
    req.log = { message: message, logObject: logObject };
    res.render = function (template) {
        var options = arguments[1] === undefined ? {} : arguments[1];
        restore(req, res);
        res.render(template, options);
        if (options.message) message += ": " + options.message;
        logObject.result = options.message;
        logger.log('info', message);
    };
    res.logError = function (error) {
        logObject.errors.push(error);
    };
    res.send = function (result) {
        var status = arguments[1] === undefined ? res.statusCode : arguments[1];
        log(res, message, logObject, result, status);
        restore(req, res);
        if (result === null || result === undefined) {
            res.status(status).end();
        } else {
            res.status(status).send(result);
        }
    };
    res.end = function () {
        var status = arguments[0] === undefined ? res.statusCode : arguments[0];
        if (typeof status != "number") {
            res.status(res.statusCode).send(status);
        } else {
            restore(req, res);
            log(res, message, logObject, null, status);
            res.status(status).end();
        }
    };
    next();
};
