{MetadataDetail} = require './metadata-detail'
{MetadataReferences} = require './metadata-references'
{MetadataType, isItemScheme} = require './metadata-type'
{AgenciesRefType, MultipleIDType, MultipleVersionsType, NestedIDType} =
  require '../utils/sdmx-patterns'
{isValidEnum, isValidPattern, createErrorMessage} =
  require '../utils/validators'

defaults =
  agency: 'all'
  id: 'all'
  version: 'latest'
  detail: MetadataDetail.FULL
  references: MetadataReferences.NONE
  item: 'all'

ValidQuery =
  resource: (q, i, e) -> isValidEnum(i, MetadataType, 'resources', e)
  agency: (q, i, e) -> isValidPattern(i, AgenciesRefType, 'agencies', e)
  id: (q, i, e) -> isValidPattern(i, MultipleIDType, 'resource ids', e)
  version: (q, i, e) -> isValidPattern(i, MultipleVersionsType, 'versions', e)
  detail: (q, i, e) -> isValidEnum(i, MetadataDetail, 'details', e)
  references: (q, i, e) -> isValidEnum(i, MetadataReferences, 'references', e)
  item: (q, i, e) ->
    isValidPattern(i, NestedIDType, 'items', e) and canHaveItem(q, e)

canHaveItem = (query, errors) ->
  allowed = query.item is 'all' or isItemScheme query.resource
  errors.push "#{query.resource} is not an item scheme and therefore it is \
  not possible to query by item" unless allowed
  allowed

isValidQuery = (query) ->
  errors = []
  isValid = false
  for k, v of query
    isValid = ValidQuery[k](query, v, errors) if k of ValidQuery
    break unless isValid
  {isValid: isValid, errors: errors}

toQueryParam = (p) -> p.join('+')

# A query for structural metadata, as defined by the SDMX RESTful API.
query = class MetadataQuery

  @from: (opts) ->
    a = opts?.agency ? defaults.agency
    a = toQueryParam a if Array.isArray a
    id = opts?.id ? defaults.id
    id = toQueryParam id if Array.isArray id
    vs = opts?.version ? defaults.version
    vs = toQueryParam vs if Array.isArray vs
    query =
      resource: opts?.resource
      agency: a
      id: id
      version: vs
      detail: opts?.detail ? defaults.detail
      references: opts?.references ? defaults.references
      item: opts?.item ? defaults.item
    input = isValidQuery query
    throw Error createErrorMessage(input.errors, 'metadata query') \
      unless input.isValid
    query

exports.MetadataQuery = query
