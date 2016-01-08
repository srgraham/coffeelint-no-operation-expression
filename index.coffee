
getNodeType = (node)->
  return node.constructor.name

cloneStack = (stack)->
  out = []
  stack.forEach (val)->
    out.push val
    return
  return out

dumpStack = (stack)->
  out = []
  for i in stack
    out.push getNodeType(i)
  return out

var_skip_arr = ['expect', 'assert']

# CodeFragment, Base, Block, Literal, Undefined, Null, Bool, Return, Value, Comment, Call, Extends, Access, Index, Range, Slice, Obj, Arr, Class, Assign, Code, Param, Splat, Expansion, While, Op, In, Try, Throw, Existence, Parens, For, Switch, If,

module.exports = class NoOperationExpression
  rule:
    name: 'no_operation_expression'
    level: 'error'
    message: 'Useless value. No expression.'
    description: '''
      Finds instances where there's some code that doesn't do anything.
      This could mean a variable, string, or number on a line with no assignment or calls happening to it.
      Ex: Any of these statements on a line by itself
        5
        'stuff'
        obj

      By themselves, they don't do anything at all. They're likely a development oversight
      The chai variables "expect", "assert", and "should" bypass this rule
        since they have __getter__ magic happening in them.
    '''

  lintAST: (node, astApi) ->
    @astApi = astApi
    @lintNode node, []

    node.eachChild (child)=>
      @lintBodyChild child
      return

    return

  lintNode: (node, stack)->
    node_type = getNodeType(node)
    stack = cloneStack(stack)
    stack.push node

    switch node_type
      # Classes are objects, so we need to pass through their guts
      # Parens just make an extra block which is useless to look at
      when 'Class', 'Parens'
        break
      else

        body_keys = ['body', 'elseBody']

        for body_key in body_keys

          if node[body_key]

            # break out if it's an assignment on If or Switch
            # todo: this is ugly. figure out how to pass assignment down the chain correctly
            if ['If', 'Switch'].indexOf(node_type) != -1
              if getNodeType(stack[stack.length - 2]) is 'Assign'
                break

            # if we're auto returning the last statement, we need to skip over it in our bad expressions check
            last_node = null

            switch node_type
              when 'Code'
                last_node = node[body_key].lastNonComment(node[body_key].expressions)

            node[body_key].eachChild (child)=>
              if child isnt last_node
                @lintBodyChild child
              return

    node.eachChild (child)=>
      @lintNode child, stack
      return
    return

  lintBodyChild: (node)->
    if @isBadChild(node)
#      console.log 'BAD NODE', getNodeType(node)
      @throwError node
    return

  isBadChild: (node)->
    node_type = getNodeType(node)
    switch node_type
      when 'Code'
        return true
      when 'Value'
        var_name = node.base?.variable?.base?.value
        if var_skip_arr.indexOf(var_name) != -1
          return false
        return true
    return false

  throwError: (node)->
    err = @astApi.createError
      lineNumber: node.locationData.first_line + 1
    @errors.push err
    return
