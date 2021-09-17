class Triple {
  final BigInt d;
  final BigInt s;
  final BigInt t;

  Triple(this.d, this.s, this.t);
}

class RSA {
  /// mencari nilai N
  BigInt fn(BigInt p, BigInt q) {
    return p * q;
  }

  // mencari nilai R
  BigInt fr(BigInt p, BigInt q) {
    return (p - BigInt.one) * (q - BigInt.one);
  }

  // mencari nilai E
  BigInt findE(BigInt r) {
    for (BigInt i = BigInt.one; i < BigInt.from(100); i += BigInt.one) {
      if (egcd(i, r) == BigInt.one) {
        print(i);
      }
      break;
    }
  }

  // Mencari nilai E
  egcd(BigInt e, BigInt r) {
    if (r == BigInt.zero) {
      return e;
    }
    return egcd(r, e % r);
  }

// ini udah betul
  eugcd(BigInt e, BigInt r) {
    for (BigInt i = BigInt.zero; i < r; i += BigInt.one) {
      while (e != BigInt.zero) {
        BigInt a = r ~/ e;
        BigInt b = r % e;
        if (b != BigInt.zero) {
          print(" $r = $a*($e) + $b");
        }
        r = e;
        e = b;
      }
    }
  }

  // ini udah bener
  Triple eea(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return new Triple(a, BigInt.one, BigInt.zero);
    } else {
      var ext = eea(b, a % b);
      return Triple(ext.d, ext.t, (ext.s - (a ~/ b) * ext.t));
    }
  }

  BigInt multInv(BigInt e, BigInt r) {
    var tup = eea(e, r);
    if (tup.d != BigInt.one) {
      return null;
    } else {
      if (tup.s < BigInt.zero) {
        print("masih salah tapi bener");
      } else if (tup.s > BigInt.zero) {
        print("udah bener");
      }
      return tup.s % r;
    }
  }

  encrypt(BigInt e, BigInt n, BigInt plain) {
    BigInt x;
    BigInt m = BigInt.zero;

    m = plain.modPow(e, n);
    x = m;

    return x;
  }

  decript(BigInt d, BigInt n, BigInt chiper) {
    BigInt m;

    BigInt x;

    x = chiper.modPow(d, n);
    m = x;

    return m;
  }
}
