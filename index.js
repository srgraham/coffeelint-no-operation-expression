// Generated by CoffeeScript 1.10.0
(function() {
  var NoOperationExpression, getNodeType;

  getNodeType = function(node) {
    return node.constructor.name;
  };

  module.exports = NoOperationExpression = (function() {
    function NoOperationExpression() {}

    NoOperationExpression.prototype.rule = {
      name: 'no_operation_expression',
      level: 'error',
      message: 'Useless value. No expression.',
      description: 'Finds instances where there\'s some code that doesn\'t do anything.\nThis could mean a variable, string, or number on a line with no assignment or calls happening to it.\nEx: Any of these statements on a line by itself\n  5\n  \'stuff\'\n  obj\n\nBy themselves, they don\'t do anything at all. They\'re likely a development oversight\nThe chai variables "expect", "assert", and "should" bypass this rule\n  since they have __getter__ magic happening in them.'
    };

    NoOperationExpression.prototype.lintAST = function(node, astApi) {
      this.astApi = astApi;
      this.lintNode(node, 0);
    };

    NoOperationExpression.prototype.lintBlock = function(node) {
      var child_count, skip_count;
      child_count = 0;
      node.eachChild(function() {
        child_count += 1;
      });
      skip_count = 0;
      node.eachChild((function(_this) {
        return function(child) {
          var err, is_chai;
          if (skip_count > 0) {
            skip_count -= 1;
            return;
          }
          switch (getNodeType(child)) {
            case 'Op':
              skip_count += 2;
              break;
            case 'Value':
              is_chai = false;
              child.eachChild(function(c) {
                if (getNodeType(c) === 'Call') {
                  c.eachChild(function(cc) {
                    if (getNodeType(cc) === 'Value') {
                      switch (cc.base.value) {
                        case 'assert':
                        case 'expect':
                        case 'should':
                          is_chai = true;
                          return false;
                      }
                    }
                  });
                }
              });
              if (!is_chai) {
                err = _this.astApi.createError({
                  lineNumber: child.locationData.first_line + 1
                });
                _this.errors.push(err);
              }
              break;
            default:
              child.eachChild(function(c) {
                _this.lintNode(c);
              });
          }
        };
      })(this));
    };

    NoOperationExpression.prototype.lintNode = function(node) {
      var node_name;
      node_name = getNodeType(node);
      switch (node_name) {
        case 'Block':
          this.lintBlock(node);
          break;
        case 'Code':
          node.eachChild((function(_this) {
            return function(child) {
              if (getNodeType(child) === 'Block') {
                _this.lintNode(child);
              }
            };
          })(this));
      }
    };

    return NoOperationExpression;

  })();

}).call(this);

//# sourceMappingURL=index.js.map
