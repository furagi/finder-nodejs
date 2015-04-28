settings = {
    PORT: 9201
    HOST: 'localhost'
    PROJECT_NAME: 'finder'
    DATABASE: {
        protocol: 'mysql',
        query: {pool: on},
        host: 'sanddb.gtflix.com',
        user: 'develop',
        password: 'develop@box',
        database: 'finder'
    }
    MEMCACHE: {
        "servers": ["memcached1.ttc-prod.avodn.lan"],
        "prefix": "finder__"
    }
    SESSION: {
        cookie_name: "finder-sid",
        cookie_secret: "shakabalaha"
    }
    USER: {
        salt: 'white death'
    }
}

try
    local = require('./local');
    require('underscore').extend settings, local
catch e
    console.log("Can't load local settings");

global.settings = settings
