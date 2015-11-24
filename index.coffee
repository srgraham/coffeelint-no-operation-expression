
getNodeType = (node)->
  return node.constructor.name

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
    @lintNode node, 0
    return

  lintBlock: (node)->
#    console.log 'hit block. childrens:'
    child_count = 0
    node.eachChild ()->
      child_count += 1
      return

#    console.log "has #{child_count} children"


    skip_count = 0
    node.eachChild (child)=>
      if skip_count > 0
        skip_count -= 1
        return

#      console.log getNodeType child


      switch getNodeType(child)
        when 'Op'
          skip_count += 2
        when 'Value'
          # ignore chai expect()
          is_chai = false

          child.eachChild (c)=>
            if getNodeType(c) is 'Call'
              c.eachChild (cc)=>
                if getNodeType(cc) is 'Value'
                  switch cc.base.value
                    when 'assert', 'expect', 'should'
                      is_chai = true
                      return false
                return
            return

          if not is_chai
            err = @astApi.createError
              lineNumber: child.locationData.first_line + 1
            @errors.push err
        else
          child.eachChild (c)=>
            @lintNode c
            return
      return
    return

  lintNode: (node) ->
    node_name = getNodeType node

    # starting a code block
    switch node_name
      when 'Block'
        @lintBlock node
      when 'Code'
        node.eachChild (child)=>
          if getNodeType(child) is 'Block'
            @lintNode child
          return

    return