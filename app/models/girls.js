// Generated by CoffeeScript 1.8.0
var async, fs, _;

_ = require('underscore');

fs = require('fs');

async = require('async');

module.exports = function(db) {
  var Girls;
  Girls = db.define('girl', {
    girl_id: {
      type: 'serial',
      key: true
    },
    name: {
      type: 'text',
      size: 100
    },
    description: {
      type: 'text',
      size: 1000
    },
    rating: {
      type: 'number',
      defaultValue: 0
    },
    profile_photo: {
      type: 'text'
    }
  }, {
    methods: {
      add_categories: function(categories, callback) {
        return async.waterfall([
          (function(_this) {
            return function(next) {
              return _this.set_categories(categories, next);
            };
          })(this), (function(_this) {
            return function(categories, next) {
              return Girls.get(_this.girl_id, next);
            };
          })(this)
        ], (function(_this) {
          return function(err, girl) {
            if (!err) {
              _this.categories = girl.categories;
            }
            return callback(err, _this);
          };
        })(this));
      },
      update_categories: function(categories, callback) {
        var added_diff, deleted_diff, self_categories_ids, update_categories_ids, _ref;
        if (!(((_ref = this.categories) != null ? _ref.length : void 0) > 0)) {
          this.add_categories(categories, callback);
          return;
        }
        update_categories_ids = _.map(categories, function(category) {
          return category.category_id;
        });
        deleted_diff = this.categories.filter(function(category) {
          return update_categories_ids.indexOf(category.category_id) === -1;
        });
        self_categories_ids = this.categories.map(function(category) {
          return category.category_id;
        });
        added_diff = _.filter(categories, function(category) {
          return self_categories_ids.indexOf(category.category_id) === -1;
        });
        return async.waterfall([
          (function(_this) {
            return function(next) {
              return _this.delete_categories(deleted_diff, next);
            };
          })(this), (function(_this) {
            return function(categories, next) {
              return _this.set_categories(added_diff, next);
            };
          })(this), (function(_this) {
            return function(categories, next) {
              return Girls.get(_this.girl_id, next);
            };
          })(this)
        ], (function(_this) {
          return function(err, girl) {
            if (!err) {
              _this.categories = girl.categories;
            }
            return callback(err, _this);
          };
        })(this));
      }
    }
  });
  return Girls.hasMany('categories', db.models.category, {}, {
    autoFetch: true,
    mergeId: 'girl_id',
    mergeAssocId: 'category_id',
    delAccessor: 'delete_categories',
    mergeTable: 'girl_to_category',
    getAccessor: 'get_categories',
    setAccessor: 'set_categories'
  });
};
