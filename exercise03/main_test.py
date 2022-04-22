import unittest

from main import fixed, main


class TestMain(unittest.TestCase):

    def test_main(self):
        self.assertEqual(main(), 496)
        # self.assertEqual(fixed(), 496)


if __name__ == '__main__':
    unittest.main()
