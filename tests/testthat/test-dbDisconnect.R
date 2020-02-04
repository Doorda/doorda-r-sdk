context('dbDisconnect')

source('utilities.R')

test_that('dbDisconnect works with mock', {
  conn <- setup_mock_connection()
  expect_true(dbDisconnect(conn))
})