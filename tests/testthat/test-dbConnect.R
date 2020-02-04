context('dbConnect')

test_that('dbConnect constructs PrestoConnection correctly', {
  expect_error(dbConnect(DoordaHostSDK::DoordaHost()), label='not enough arguments')
  
  expect_error(
    dbConnect(
      DoordaHostSDK::DoordaHost(),
      catalog='jmx'
    ),
    'argument ".*" is missing, with no default',
    label='not enough arguments'
  )
  
  expect_is(
    dbConnect(
      DoordaHostSDK::DoordaHost(),
      catalog='jmx',
      schema='test',
      password='test',
      user=Sys.getenv('USER')
    ),
    'DoordaHostConnection'
  )
})