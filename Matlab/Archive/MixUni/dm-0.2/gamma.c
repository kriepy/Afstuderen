/*
    gamma.c
    gamma, digamma and trigamma function by Thomas Minka
    $Id: gamma.c,v 1.1 2005/12/27 14:10:31 dmochiha Exp $

*/
#include <stdlib.h>
#include <math.h>
#include <float.h>

/* Logarithm of the gamma function.

   References:

   1) W. J. Cody and K. E. Hillstrom, 'Chebyshev Approximations for
      the Natural Logarithm of the Gamma Function,' Math. Comp. 21,
      1967, pp. 198-203.

   2) K. E. Hillstrom, ANL/AMD Program ANLC366S, DGAMMA/DLGAMA, May,
      1969.
 
   3) Hart, Et. Al., Computer Approximations, Wiley and sons, New
      York, 1968.

   From matlab/gammaln.m
*/
double gammaln(double x)
{
  double result, y, xnum, xden;
  int i;
  static double d1 = -5.772156649015328605195174e-1;
  static double p1[] = { 
    4.945235359296727046734888e0, 2.018112620856775083915565e2, 
    2.290838373831346393026739e3, 1.131967205903380828685045e4, 
    2.855724635671635335736389e4, 3.848496228443793359990269e4, 
    2.637748787624195437963534e4, 7.225813979700288197698961e3 
  };
  static double q1[] = {
    6.748212550303777196073036e1, 1.113332393857199323513008e3, 
    7.738757056935398733233834e3, 2.763987074403340708898585e4, 
    5.499310206226157329794414e4, 6.161122180066002127833352e4, 
    3.635127591501940507276287e4, 8.785536302431013170870835e3
  };
  static double d2 = 4.227843350984671393993777e-1;
  static double p2[] = {
    4.974607845568932035012064e0, 5.424138599891070494101986e2, 
    1.550693864978364947665077e4, 1.847932904445632425417223e5, 
    1.088204769468828767498470e6, 3.338152967987029735917223e6, 
    5.106661678927352456275255e6, 3.074109054850539556250927e6
  };
  static double q2[] = {
    1.830328399370592604055942e2, 7.765049321445005871323047e3, 
    1.331903827966074194402448e5, 1.136705821321969608938755e6, 
    5.267964117437946917577538e6, 1.346701454311101692290052e7, 
    1.782736530353274213975932e7, 9.533095591844353613395747e6
  };
  static double d4 = 1.791759469228055000094023e0;
  static double p4[] = {
    1.474502166059939948905062e4, 2.426813369486704502836312e6, 
    1.214755574045093227939592e8, 2.663432449630976949898078e9, 
    2.940378956634553899906876e10, 1.702665737765398868392998e11, 
    4.926125793377430887588120e11, 5.606251856223951465078242e11
  };
  static double q4[] = {
    2.690530175870899333379843e3, 6.393885654300092398984238e5, 
    4.135599930241388052042842e7, 1.120872109616147941376570e9, 
    1.488613728678813811542398e10, 1.016803586272438228077304e11, 
    3.417476345507377132798597e11, 4.463158187419713286462081e11
  };
  static double c[] = {
    -1.910444077728e-03, 8.4171387781295e-04, 
    -5.952379913043012e-04, 7.93650793500350248e-04, 
    -2.777777777777681622553e-03, 8.333333333333333331554247e-02, 
    5.7083835261e-03
  };
  static double a = 0.6796875;

  if((x <= 0.5) || ((x > a) && (x <= 1.5))) {
    if(x <= 0.5) {
      result = -log(x);
      /*  Test whether X < machine epsilon. */
      if(x+1 == 1) {
	return result;
      }
    }
    else {
      result = 0;
      x = (x - 0.5) - 0.5;
    }
    xnum = 0;
    xden = 1;
    for(i=0;i<8;i++) {
      xnum = xnum * x + p1[i];
      xden = xden * x + q1[i];
    }
    result += x*(d1 + x*(xnum/xden));
  }
  else if((x <= a) || ((x > 1.5) && (x <= 4))) {
    if(x <= a) {
      result = -log(x);
      x = (x - 0.5) - 0.5;
    }
    else {
      result = 0;
      x -= 2;
    }
    xnum = 0;
    xden = 1;
    for(i=0;i<8;i++) {
      xnum = xnum * x + p2[i];
      xden = xden * x + q2[i];
    }
    result += x*(d2 + x*(xnum/xden));
  }
  else if(x <= 12) {
    x -= 4;
    xnum = 0;
    xden = -1;
    for(i=0;i<8;i++) {
      xnum = xnum * x + p4[i];
      xden = xden * x + q4[i];
    }
    result = d4 + x*(xnum/xden);
  }
  /*  X > 12  */
  else {
    y = log(x);
    result = x*(y - 1) - y*0.5 + .9189385332046727417803297;
    x = 1/x;
    y = x*x;
    xnum = c[6];
    for(i=0;i<6;i++) {
      xnum = xnum * y + c[i];
    }
    xnum *= x;
    result += xnum;
  }
  return result;
}

/* The digamma function is the derivative of gammaln.

   Reference:
    J Bernardo,
    Psi ( Digamma ) Function,
    Algorithm AS 103,
    Applied Statistics,
    Volume 25, Number 3, pages 315-317, 1976.

    From http://www.psc.edu/~burkardt/src/dirichlet/dirichlet.f
    (with modifications for negative numbers and extra precision)
*/
double digamma(double x)
{
  double result;
  static const double
	  neginf = -1.0/0.0,
	  c = 12,
	  s = 1e-6,
	  d1 = -0.57721566490153286,
	  d2 = 1.6449340668482264365, /* pi^2/6 */
	  s3 = 1./12,
	  s4 = 1./120,
	  s5 = 1./252,
	  s6 = 1./240,
	  s7 = 1./132;
	  /* s8 = 691/32760, */
	  /* s9 = 1/12, */
	  /* s10 = 3617/8160; */
  /* Illegal arguments */
  if((x == neginf) || isnan(x)) {
    return 0.0/0.0;
  }
  /* Singularities */
  if((x <= 0) && (floor(x) == x)) {
    return neginf;
  }
  /* Negative values */
  /* Use the reflection formula (Jeffrey 11.1.6):
   * digamma(-x) = digamma(x+1) + pi*cot(pi*x)
   *
   * This is related to the identity
   * digamma(-x) = digamma(x+1) - digamma(z) + digamma(1-z)
   * where z is the fractional part of x
   * For example:
   * digamma(-3.1) = 1/3.1 + 1/2.1 + 1/1.1 + 1/0.1 + digamma(1-0.1)
   *               = digamma(4.1) - digamma(0.1) + digamma(1-0.1)
   * Then we use
   * digamma(1-z) - digamma(z) = pi*cot(pi*z)
   */
  if(x < 0) {
    return digamma(1-x) + M_PI/tan(-M_PI*x);
  }
  /* Use Taylor series if argument <= S */
  if(x <= s) return d1 - 1/x + d2*x;
  /* Reduce to digamma(X + N) where (X + N) >= C */
  result = 0;
  while(x < c) {
    result -= 1/x;
    x++;
  }
  /* Use de Moivre's expansion if argument >= C */
  /* This expansion can be computed in Maple via asympt(Psi(x),x) */
  if(x >= c) {
    double r = 1/x;
    result += log(x) - 0.5*r;
    r *= r;
    result -= r * (s3 - r * (s4 - r * (s5 - r * (s6 - r * s7))));
  }
  return result;
}

/* The trigamma function is the derivative of the digamma function.

   Reference:

    B Schneider,
    Trigamma Function,
    Algorithm AS 121,
    Applied Statistics, 
    Volume 27, Number 1, page 97-99, 1978.

    From http://www.psc.edu/~burkardt/src/dirichlet/dirichlet.f
    (with modification for negative arguments and extra precision)
*/
double trigamma(double x)
{
  double result;
  double neginf = -1.0/0.0,
	  small = 1e-4,
	  large = 8,
	  c = 1.6449340668482264365, /* pi^2/6 = Zeta(2) */
	  c1 = -2.404113806319188570799476,  /* -2 Zeta(3) */
	  b2 =  1./6,
	  b4 = -1./30,
	  b6 =  1./42,
	  b8 = -1./30,
	  b10 = 5./66;
  /* Illegal arguments */
  if((x == neginf) || isnan(x)) {
    return 0.0/0.0;
  }
  /* Singularities */
  if((x <= 0) && (floor(x) == x)) {
    return -neginf;
  }
  /* Negative values */
  /* Use the derivative of the digamma reflection formula:
   * -trigamma(-x) = trigamma(x+1) - (pi*csc(pi*x))^2
   */
  if(x < 0) {
    result = M_PI/sin(-M_PI*x);
    return -trigamma(1-x) + result*result;
  }
  /* Use Taylor series if argument <= small */
  if(x <= small) {
    return 1/(x*x) + c + c1*x;
  }
  result = 0;
  /* Reduce to trigamma(x+n) where ( X + N ) >= B */
  while(x < large) {
    result += 1/(x*x);
    x++;
  }
  /* Apply asymptotic formula when X >= B */
  /* This expansion can be computed in Maple via asympt(Psi(1,x),x) */
  if(x >= large) {
    double r = 1/(x*x);
    result += 0.5*r + (1 + r*(b2 + r*(b4 + r*(b6 + r*(b8 + r*b10)))))/x;
  }
  return result;
}

