crypto = require 'crypto'

module.exports = (db) ->
    Users = db.define 'user', {
            user_id: {type: 'serial', key: on}
            email: {type: 'text', size: 45}
            password: {type: 'text', size: 64}
            is_admin: {type: 'boolean', defaultValue: false}
        }, {
            methods: {
                login: (callback) ->
                    sha256 = crypto.createHash 'sha256'
                    sha256.update @password + settings.user.salt
                    @password = sha256.digest 'hex'
                    Users.one {email: @email, password: @password}, (err, user) ->
                        if not err and not user
                            err = "User wasn't found"
                        callback err, user

            }
        }
