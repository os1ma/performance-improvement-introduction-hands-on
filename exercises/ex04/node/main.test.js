const { main } = require('./main')

test('main', () => {
  expect(() => main()).not.toThrow()
})
