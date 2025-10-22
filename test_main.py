import unittest
from main import add


class TestMain(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)
    def test_sub(self):
        self.assertEqual(sub(3,3), 0)
        self.assertEqual(sub(3,2), 2)

if __name__ == "__main__":
    unittest.main()
