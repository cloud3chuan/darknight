# tool to clean the old assets files from stem cdn for maui

qiniu = require 'qiniu'
_ = require 'lodash'

qiniu.conf.ACCESS_KEY = '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_'
qiniu.conf.SECRET_KEY = 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv'

bucketName = 'stemcdn'
prefix = 'stem/'
marker = ''
limit = 1000

client = new qiniu.rs.Client()

processor = (err, ret) ->
  if err
    console.log err
  else
    items = ret.items

    if items.length > 0
      pathArray = []
      _.forEach items, (item) ->
        console.log "Delete #{item.key}..."
        path = new qiniu.rs.EntryPath bucketName, item.key
        pathArray.push path

      client.batchDelete pathArray, (err, result) ->
        console.log err if err


getVersions = ->
  startStr = process.argv[2]
  endStr = process.argv[3] ? startV

  reg = /(\d+_\d+_)(\d+)/

  startArr = startStr.match reg
  startV = +startArr[2]
  base = startArr[1]

  endArr = endStr.match reg
  endV = +endArr[2]

  [base, startV, endV]


[base, startV, endV] = getVersions()

_.forEach [startV..endV], (v) ->
  prefixStr = prefix + base + v
  console.log prefixStr
  qiniu.rsf.listPrefix(bucketName, prefixStr, marker, limit, processor)
