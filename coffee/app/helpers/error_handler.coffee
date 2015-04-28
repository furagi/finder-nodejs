module.exports = (err, req, res, next) ->
    if err.status is 403
        return res.status(403).end()

    is_production = process.env.NODE_ENV is 'production'
    #Logging
    errMessage = err.message or err
    logObject = {}
    if req.log
        if req.log.message
            errMessage = req.log.message + ': ' + errMessage;
        if req.log.logObject && typeof req.log.logObject is 'object'
            logObject = req.log.logObject;
        delete req.log;
    if typeof res.expressSend is 'function'
        res.send = res.expressSend;
        delete res.expressSend;
    if typeof res.expressRender is 'function'
        res.render = res.expressRender;
        delete res.expressRender;
    if typeof res.expressEnd is 'function'
        res.end = res.expressEnd
        delete res.expressEnd
    logObject.error = if err.stack then err.stack else err;
    logObject.ip = req.ip;
    logObject.ulr = req.originalUrl;
    status = err.status or 500
    level = 'warn'
    if status < 500
        logObject = null;
    else
        level = "error";
    logger.log(level, errMessage, logObject);

    res.status(err.status || 500);
    unless is_production
        return res.type('txt').send(err.stack || errMessage);

    message = 'Internal error';
    # respond with html page
    if req.accepts('html')
        return res.render( "#{res.status or 500}", {
            message : message
        });
    # respond with json
    if req.accepts('json')
        res.send({ error: message });
        return;
    #respond with plain text
    res.type('txt').send(message)
