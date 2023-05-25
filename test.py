from unittest import TestCase, main

from whiteboard import solution

class MatchTestCase2(TestCase):
    def test_1(self):
        self.assertEqual(solution(["T", "F", "F", "T" ]) ,"Outage")
    def test_2(self):
        self.assertEqual(solution(["T", "F", "T", "T"]), "Power")
    def test_3(self):
        self.assertEqual(solution(["T", "T", "T", "T"]), "Power")
    def test_4(self):
        self.assertEqual(solution(["F", "F", "F", "F"]), "Outage")
    def test_4(self):
        self.assertEqual(solution(["T", "T","T","T","F", "F"]), "Outage")
    def test_5(self):
        self.assertEqual(solution(["T", "F","T","T","T", "F"]), "Outage")

if __name__ == "__main__":
    main()