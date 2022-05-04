const { main } = require('./main')

jest.setTimeout(20 * 1000)

test('main', async () => {
  expect(await main()).toBe(496)
})
