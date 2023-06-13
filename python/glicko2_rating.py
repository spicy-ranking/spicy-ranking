import math

class Player:

    # レーティング変動の時間的な制約
    _tau = 0.5

    def getRating(self):
        return (self.__rating * 173.7178) + 1500 

    def setRating(self, rating):
        self.__rating = (rating - 1500) / 173.7178

    # プレイヤーのレーティングを取得
    rating = property(getRating, setRating)

    def getRd(self):
        return self.__rd * 173.7178

    def setRd(self, rd):
        self.__rd = rd / 173.7178

    # プレイヤーの信頼性を表す指標
    rd = property(getRd, setRd)
     
    def __init__(self, rating = 1500, rd = 350, vol = 0.06):
        # For testing purposes, preload the values
        # assigned to an unrated player.
        self.setRating(rating)
        self.setRd(rd)
        self.vol = vol
            
    def _preRatingRD(self):
        """
        レーティング期間の初めにプライヤーのRDを計算および更新する
        
        preRatingRD() -> None
        
        """
        self.__rd = math.sqrt(math.pow(self.__rd, 2) + math.pow(self.vol, 2))
        
    def update_player(self, rating_list, RD_list, outcome_list):
        # 
        
        """ 
        プレイヤーの新しいレートとRDを計算する
        - rating_list: 対戦相手のレーティングのリスト
        - RD_list: 対戦相手のRDリスト
        - outcome_list: 対戦結果のリスト
        
        update_player(list[int], list[int], list[bool]) -> None
        
        """
        # Convert the rating and rating deviation values for internal use.
        rating_list = [(x - 1500) / 173.7178 for x in rating_list]
        RD_list = [x / 173.7178 for x in RD_list]

        v = self._v(rating_list, RD_list)
        self.vol = self._newVol(rating_list, RD_list, outcome_list, v)
        self._preRatingRD()
        
        self.__rd = 1 / math.sqrt((1 / math.pow(self.__rd, 2)) + (1 / v))
        
        tempSum = 0
        for i in range(len(rating_list)):
            tempSum += self._g(RD_list[i]) * \
                       (outcome_list[i] - self._E(rating_list[i], RD_list[i]))
        self.__rating += math.pow(self.__rd, 2) * tempSum
        
    #step 5        
    def _newVol(self, rating_list, RD_list, outcome_list, v):
        """
        新しいボラティリティ（レーティングの不確かさ）を計算
        
        _newVol(list, list, list, float) -> float
        
        """
        #step 1
        a = math.log(self.vol**2)
        eps = 0.000001
        A = a
        
        #step 2
        B = None
        delta = self._delta(rating_list, RD_list, outcome_list, v)
        tau = self._tau
        if (delta ** 2)  > ((self.__rd**2) + v):
          B = math.log(delta**2 - self.__rd**2 - v)
        else:        
          k = 1
          while self._f(a - k * math.sqrt(tau**2), delta, v, a) < 0:
            k = k + 1
          B = a - k * math.sqrt(tau **2)
        
        #step 3
        fA = self._f(A, delta, v, a)
        fB = self._f(B, delta, v, a)
        
        #step 4
        while math.fabs(B - A) > eps:
          #a
          C = A + ((A - B) * fA)/(fB - fA)
          fC = self._f(C, delta, v, a)
          #b
          if fC * fB < 0:
            A = B
            fA = fB
          else:
            fA = fA/2.0
          #c
          B = C
          fB = fC
        
        #step 5
        return math.exp(A / 2)
        
    def _f(self, x, delta, v, a):
        """
        ボラティリティの計算に使用される関数

        """
        ex = math.exp(x)
        num1 = ex * (delta**2 - self.__rating**2 - v - ex)
        denom1 = 2 * ((self.__rating**2 + v + ex)**2)
        return  (num1 / denom1) - ((x - a) / (self._tau**2))
        
    def _delta(self, rating_list, RD_list, outcome_list, v):
        """ 
        グリコ2システムのデルタ関数を計算する
        
        _delta(list, list, list) -> float
        
        """
        tempSum = 0
        for i in range(len(rating_list)):
            tempSum += self._g(RD_list[i]) * (outcome_list[i] - self._E(rating_list[i], RD_list[i]))
        return v * tempSum
        
    def _v(self, rating_list, RD_list):
        """ 
        グリコ2システムのv関数を計算
        
        _v(list[int], list[int]) -> float
        
        """
        tempSum = 0
        for i in range(len(rating_list)):
            tempE = self._E(rating_list[i], RD_list[i])
            tempSum += math.pow(self._g(RD_list[i]), 2) * tempE * (1 - tempE)
        return 1 / tempSum
        
    def _E(self, p2rating, p2RD):
        """
        グリコ2システムのE関数を計算
        
        _E(int) -> float
        
        """
        return 1 / (1 + math.exp(-1 * self._g(p2RD) * \
                                 (self.__rating - p2rating)))
        
    def _g(self, RD):
        """
        グリコ2システムのg(RD)関数を計算

        _g() -> float
        
        """
        return 1 / math.sqrt(1 + 3 * math.pow(RD, 2) / math.pow(math.pi, 2))
        
    def did_not_compete(self):
        """ 
        プレイヤーが試合に参加しなかった場合の処理（いらないかも）
        Applies Step 6 of the algorithm. Use this for
        players who did not compete in the rating period.

        did_not_compete() -> None
        
        """
        self._preRatingRD()

