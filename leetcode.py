#python3
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        dp = [[1 for j in range(i+1)] for i in range(numRows)]
        for i in range(numRows):
            for j in range(1,i):
                dp[i][j] = dp[i-1][j-1] + dp[i-1][j]
        return dp 

#python3
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        res = []
        for i in range(numRows):
            row = [1] * (i + 1)
            for j in range(1, i):
                row[j] = res[i - 1][j - 1] + res[i - 1][j]
            res.append(row)
        return res
#python
class Solution(object):
    def generate(self, numRows):
        """
        :type numRows: int
        :rtype: List[List[int]]
        """
        res = []
        for i in range(numRows):
            row = [1] * (i + 1)
            for j in range(1, i):
                row[j] = res[i - 1][j - 1] + res[i - 1][j]
            res.append(row)
        return res
