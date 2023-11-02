import 'dart:math';

class Player {
  static const double _tau = 0.5;
  late double _rating;
  late double _rd;
  late double vol;

  double get rating => (_rating * 173.7178) + 1500;

  set rating(double rating) {
    _rating = (rating - 1500) / 173.7178;
  }

  double get rd => _rd * 173.7178;

  set rd(double rd) {
    _rd = rd / 173.7178;
  }

  Player clone() {
    final clonedPlayer = Player();
    clonedPlayer.rating = rating;
    clonedPlayer.rd = rd;
    clonedPlayer.vol = vol;
    return clonedPlayer;
  }

  Player({double rating = 1500, double rd = 350, this.vol = 0.06}) {
    this.rating = rating;
    this.rd = rd;
  }

  void _preRatingRD() {
    _rd = sqrt(pow(_rd, 2) + pow(vol, 2));
  }

  void updatePlayer(
      List<double> ratingList, List<double> rdList, List<double> outcomeList) {
    ratingList = ratingList.map((x) => (x - 1500) / 173.7178).toList();
    rdList = rdList.map((x) => x / 173.7178).toList();

    double v = _v(ratingList, rdList);
    vol = _newVol(ratingList, rdList, outcomeList, v);
    _preRatingRD();

    _rd = 1 / sqrt((1 / pow(_rd, 2)) + (1 / v));

    double tempSum = 0;
    for (int i = 0; i < ratingList.length; i++) {
      tempSum +=
          _g(rdList[i]) * (outcomeList[i] - _e(ratingList[i], rdList[i]));
    }
    _rating += pow(_rd, 2) * tempSum;
  }

  double _newVol(List<double> ratingList, List<double> rdList,
      List<double> outcomeList, double v) {
    double a = log(pow(vol, 2));
    double eps = 0.000001;
    double A = a;
    // ↓ここのnull安全を外した
    double B;

    double delta = _delta(ratingList, rdList, outcomeList, v);
    double tau = _tau;

    if (pow(delta, 2) > (pow(_rd, 2) + v)) {
      B = log(pow(delta, 2) - pow(_rd, 2) - v);
    } else {
      int k = 1;
      while (_f(a - k * sqrt(pow(tau, 2)), delta, v, a) < 0) {
        k++;
      }
      B = a - k * sqrt(pow(tau, 2));
    }

    double fA = _f(A, delta, v, a);
    double fB = _f(B, delta, v, a);

    while (sqrt(pow(B - A, 2)) > eps) {
      double C = A + ((A - B) * fA) / (fB - fA);
      double fC = _f(C, delta, v, a);

      if (fC * fB < 0) {
        A = B;
        fA = fB;
      } else {
        fA = fA / 2.0;
      }

      B = C;
      fB = fC;
    }

    return exp(A / 2);
  }

  double _f(double x, double delta, double v, double a) {
    double ex = exp(x);
    double num1 = ex * (pow(delta, 2) - pow(_rating, 2) - v - ex);
    // 'as double' でdouble型へキャスト
    double denom1 = 2 * pow(pow(_rating, 2) + v + ex, 2) as double;
    return (num1 / denom1) - ((x - a) / pow(_tau, 2));
  }

  double _delta(List<double> ratingList, List<double> rdList,
      List<double> outcomeList, double v) {
    double tempSum = 0;
    for (int i = 0; i < ratingList.length; i++) {
      tempSum +=
          _g(rdList[i]) * (outcomeList[i] - _e(ratingList[i], rdList[i]));
    }
    return v * tempSum;
  }

  double _v(List<double> ratingList, List<double> rdList) {
    double tempSum = 0;
    for (int i = 0; i < ratingList.length; i++) {
      double tempE = _e(ratingList[i], rdList[i]);
      tempSum += pow(_g(rdList[i]), 2) * tempE * (1 - tempE);
    }
    return 1 / tempSum;
  }

  double _e(double p2rating, double p2RD) {
    return 1 / (1 + exp(-1 * _g(p2RD) * (_rating - p2rating)));
  }

  double _g(double rD) {
    return 1 / sqrt(1 + 3 * pow(rD, 2) / pow(pi, 2));
  }

  void didNotCompete() {
    _preRatingRD();
  }
}
