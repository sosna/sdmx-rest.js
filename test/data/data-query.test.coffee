should = require('chai').should()

{DataDetail} = require '../../src/data/data-detail'
{DataQuery} = require '../../src/data/data-query'

describe 'Data queries', ->

  it 'has the expected properties', ->
    q = DataQuery.from {flow: 'ICP'}
    q.should.be.an 'object'
    q.should.have.property 'flow'
    q.should.have.property 'key'
    q.should.have.property 'provider'
    q.should.have.property 'start'
    q.should.have.property 'end'
    q.should.have.property 'updatedAfter'
    q.should.have.property 'firstNObs'
    q.should.have.property 'lastNObs'
    q.should.have.property 'obsDimension'
    q.should.have.property 'detail'
    q.should.have.property 'history'

  it 'has the expected defaults', ->
    flow = 'EXR'
    q = DataQuery.from {flow: flow}
    q.should.have.property('flow').that.equals flow
    q.should.have.property('key').that.equals 'all'
    q.should.have.property('provider').that.equals 'all'
    q.should.have.property('start').that.is.undefined
    q.should.have.property('end').that.is.undefined
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('firstNObs').that.is.undefined
    q.should.have.property('lastNObs').that.is.undefined
    q.should.have.property('obsDimension').that.equals 'TIME_PERIOD'
    q.should.have.property('detail').that.equals 'full'
    q.should.have.property('history').that.is.false

  describe 'when setting the flow', ->

    it 'throws an exception when the flow is not set', ->
      test = -> DataQuery.from({flow: ' '})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery.from({flow: undefined})
      should.Throw(test, Error, 'Not a valid data query')

    it 'throws an exception when the flow is invalid', ->
      test = -> DataQuery.from({flow: '1%'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the key', ->

    it 'a string representing the key can be used', ->
      flow = 'EXR'
      key = '.CHF+NOK.EUR..2'
      q = DataQuery.from({flow: flow, key: key})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('key').that.equals key

    it 'an array of arrays can be used to build the key', ->
      values = [
        ['D']
        ['NOK', 'RUB', 'CHF']
        ['EUR']
        []
        ['A']
      ]
      query = DataQuery.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals 'D.NOK+RUB+CHF.EUR..A'

    it 'a mixed array can be used to build the key', ->
      values = [
        'D'
        ['NOK', 'RUB', 'CHF']
        ''
        'SP00'
        undefined
      ]
      query = DataQuery.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals 'D.NOK+RUB+CHF..SP00.'

    it 'an exotic array can be used to build the key', ->
      values = [
        ''
        ['NOK', 'RUB', 'CHF']
        ['EUR']
        undefined
        null
      ]
      query = DataQuery.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals '.NOK+RUB+CHF.EUR..'

    it 'throws an exception if the value for the key is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', key: '1%'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the provider', ->

    it 'a string representing the provider can be used', ->
      flow = 'EXR'
      provider = 'ECB'
      q = DataQuery.from({flow: flow, provider: provider})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('provider').that.equals provider

      provider = 'SDMX,ECB'
      q = DataQuery.from({flow: flow, provider: provider})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('provider').that.equals provider

    it 'throws an exception if the value for provider is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', provider: 'SDMX,ECB,2.0'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the start and end periods', ->

    it 'a string representing years can be passed', ->
      flow = 'EXR'
      start = '2000'
      end = '2004'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'a string representing months can be passed', ->
      flow = 'EXR'
      start = '2000-01'
      end = '2004-12'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'a string representing days can be passed', ->
      flow = 'EXR'
      start = '2000-01-01'
      end = '2004-12-31'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'a string representing quarters can be passed', ->
      flow = 'EXR'
      start = '2000-Q1'
      end = '2004-Q4'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'a string representing semesters can be passed', ->
      flow = 'EXR'
      start = '2000-S1'
      end = '2004-S4'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'a string representing weeks can be passed', ->
      flow = 'EXR'
      start = '2000-W01'
      end = '2004-W53'
      q = DataQuery.from({flow: flow, start: start, end: end})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('start').that.equals start
      q.should.have.property('end').that.equals end

    it 'throws an exception if the value for start period is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', start: 'SDMX,ECB,2.0'})
      should.Throw(test, Error, 'Not a valid data query')

    it 'throws an exception if the value for end period is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', end: 'SDMX,ECB,2.0'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the updatedAfter timestamp', ->

    it 'a string representing a timestamp can be passed', ->
      flow = 'EXR'
      last = '2016-03-04T09:57:00Z'
      q = DataQuery.from({flow: flow, updatedAfter: last})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('updatedAfter').that.equals last

    it 'throws an exception if the value for updatedAfter is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', updatedAfter: 'now'})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery.from({flow: 'EXR', updatedAfter: '2000-Q1'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the first and last number of observations', ->

    it 'integers representing the desired number of obs can be passed', ->
      flow = 'EXR'
      firstN = 1
      lastN = 3
      q = DataQuery.from({flow: flow, firstNObs: firstN, lastNObs: lastN})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('firstNObs').that.equals firstN
      q.should.have.property('lastNObs').that.equals lastN

    it 'throws an exception if the value for firstObs is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', firstNObs: -2})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery.from({flow: 'EXR', firstNObs: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

    it 'throws an exception if the value for lastNObs is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', lastNObs: -2})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery.from({flow: 'EXR', lastNObs: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the dimension at observation level', ->

    it 'a string representing the dimension at the obs level can be passed', ->
      flow = 'ECB,EXR,latest'
      dim = 'CURRENCY'
      q = DataQuery.from({flow: flow, obsDimension: dim})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('obsDimension').that.equals dim

    it 'throws an exception if value for obs dimension is invalid', ->
      test = -> DataQuery.from({flow: 'EXR', obsDimension: '*&^%$#@!)'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the desired level of detail', ->

    it 'a string representing the desired level of detail can be passed', ->
      flow = 'ECB,EXR,1.0'
      detail = DataDetail.NO_DATA
      q = DataQuery.from({flow: flow, detail: detail})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('detail').that.equals detail

    it 'throws an exception if the value for the level of detail is unknown', ->
      test = -> DataQuery.from({flow: 'EXR', detail: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting whether historical data should be returned', ->

    it 'a boolean can be passed', ->
      flow = 'ECB,EXR'
      q = DataQuery.from({flow: flow, history: true})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('history').that.is.true

    it 'throws an exception if the value for history is not a boolean', ->
      test = -> DataQuery.from({flow: 'EXR', history: 'test'})
      should.Throw(test, Error, 'Not a valid data query')
