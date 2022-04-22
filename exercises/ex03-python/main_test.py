import unittest

from main import main


class TestMain(unittest.TestCase):

    def test_main(self):
        self.assertEqual(main(), 496)


if __name__ == '__main__':
    unittest.main()
