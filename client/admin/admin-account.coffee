Template.admin_account.onCreated ->
  @subscribe 'orders_stored'

Template.admin_account.onRendered ->
  $('.admin_account .datepicker').pickadate
    selecteMonths: true
    selectYears: 15

Template.admin_account.events
  'change .admin_account #start': (e) ->
    e.preventDefault()
    Session.set 'ACCOUNT_START_DATE', e.target.value

  'change .admin_account #end': (e) ->
    e.preventDefault()
    Session.set 'ACCOUNT_END_DATE', e.target.value

Template.admin_account.helpers
  orders: ->
    if Session.get('ACCOUNT_START_DATE')?
      start = new Date Session.get 'ACCOUNT_START_DATE'
    else
      start = new Date '2000-11-01T01:30:00Z'
    if Session.get('ACCOUNT_END_DATE')?
      end = new Date Session.get 'ACCOUNT_END_DATE'
    else
      end = new Date()
    end.setDate end.getDate() + 1
    OrdersStored.find
      createdAt:
        $gt: start
        $lt: end

  sum_total: ->
    if Session.get('ACCOUNT_START_DATE')?
      start = new Date Session.get 'ACCOUNT_START_DATE'
    else
      start = new Date '2000-11-01T01:30:00Z'
    if Session.get('ACCOUNT_END_DATE')?
      end = new Date Session.get 'ACCOUNT_END_DATE'
    else
      end = new Date()
    end.setDate end.getDate() + 1
    orders = OrdersStored.find
      createdAt:
        $gt: start
        $lt: end
    .fetch()
    sum = 0
    for order in orders
      sum = sum + order.total
    sum

  sum_actual: ->
    if Session.get('ACCOUNT_START_DATE')?
      start = new Date Session.get 'ACCOUNT_START_DATE'
    else
      start = new Date '2000-11-01T01:30:00Z'
    if Session.get('ACCOUNT_END_DATE')?
      end = new Date Session.get 'ACCOUNT_END_DATE'
    else
      end = new Date()
    end.setDate end.getDate() + 1
    orders = OrdersStored.find
      createdAt:
        $gt: start
        $lt: end
    .fetch()
    sum = 0
    for order in orders
      sum = sum + order.actual
    sum